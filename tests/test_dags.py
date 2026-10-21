"""Testes locais: não importam Airflow nem acessam serviços externos."""
import ast
import os
import re
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
DAGS = sorted((ROOT / 'dags').glob('*.py'))


def tree(file):
    return ast.parse(file.read_text(encoding='utf8'))


def calls(module, name):
    return [n for n in ast.walk(module) if isinstance(n, ast.Call) and ast.unparse(n.func) == name]


def isolated_function(file, name, env):
    module = tree(file)
    fn = next(n for n in ast.walk(module) if isinstance(n, ast.FunctionDef) and n.name == name)
    fn.decorator_list = []
    selected = ast.Module(body=[fn], type_ignores=[])
    exec(compile(ast.fix_missing_locations(selected), '<isolated>', 'exec'), env)
    return env[name]


class DagsTest(unittest.TestCase):
    def test_nine_files_compile_without_execution(self):
        self.assertEqual(len(DAGS), 9)
        for p in DAGS:
            with self.subTest(file=p.name):
                compile(p.read_text(encoding='utf8'), p.name, 'exec')

    def test_unique_dag_ids(self):
        ids = [ast.literal_eval(next(k.value for k in call.keywords if k.arg == 'dag_id'))
               for p in DAGS for call in calls(tree(p), 'dag') + calls(tree(p), 'DAG')]
        self.assertEqual(len(ids), 9)
        self.assertEqual(len(set(ids)), len(ids))
        self.assertTrue(all(i.startswith('demo_') for i in ids))

    def test_schedules_off_and_paused(self):
        for p in DAGS:
            for call in calls(tree(p), 'dag') + calls(tree(p), 'DAG'):
                kw = {k.arg: k.value for k in call.keywords}
                self.assertIsNone(ast.literal_eval(kw.get('schedule', kw.get('schedule_interval'))))
                self.assertTrue(ast.literal_eval(kw['is_paused_upon_creation']))

    def test_branch_returns_point_to_existing_tasks(self):
        for p in DAGS:
            t = tree(p)
            ids = {k.value.value for n in ast.walk(t) if isinstance(n, ast.Call)
                   for k in n.keywords if k.arg == 'task_id' and isinstance(k.value, ast.Constant)}
            functions = {n.name: n for n in ast.walk(t) if isinstance(n, ast.FunctionDef)}
            for call in calls(t, 'BranchPythonOperator'):
                fn_name = ast.unparse(next(k.value for k in call.keywords if k.arg == 'python_callable'))
                for ret in ast.walk(functions[fn_name]):
                    if isinstance(ret, ast.Return) and isinstance(ret.value, ast.Constant):
                        self.assertIn(ret.value.value, ids, f'{p.name}/{fn_name}')

    def test_pivot_no_data_follows_own_skip_branch(self):
        hook = lambda **kw: SimpleNamespace(get_first=lambda sql: (0,))
        fn = isolated_function(ROOT/'dags/postgres_metadata_branching.py', 'check_data_in_metadata_pivot', {'PostgresHook': hook})
        self.assertEqual(fn(), 'pause_task_metadata_pivot')

    def test_pivot_data_follows_own_extract_branch(self):
        hook = lambda **kw: SimpleNamespace(get_first=lambda sql: (4,))
        fn = isolated_function(ROOT/'dags/postgres_metadata_branching.py', 'check_data_in_metadata_pivot', {'PostgresHook': hook})
        self.assertEqual(fn(), 'extract_metadata_pivot')

    def test_pivot_empty_response_skips(self):
        hook = lambda **kw: SimpleNamespace(get_first=lambda sql: None)
        fn = isolated_function(ROOT/'dags/postgres_metadata_branching.py', 'check_data_in_metadata_pivot', {'PostgresHook': hook})
        self.assertEqual(fn(), 'pause_task_metadata_pivot')

    def test_monitor_separates_failure_from_success(self):
        sensor = calls(tree(ROOT/'dags/task_monitor_slack.py'), 'ExternalTaskSensor')[0]
        kw = {k.arg: ast.unparse(k.value) for k in sensor.keywords}
        self.assertEqual(kw['allowed_states'], '[State.SUCCESS]')
        self.assertEqual(kw['failed_states'], '[State.FAILED]')

    def test_sensor_creation_inside_task_group(self):
        t = tree(ROOT/'dags/task_monitor_slack.py')
        group = next(n for n in ast.walk(t) if isinstance(n, ast.With) and any(isinstance(i.context_expr, ast.Call) and ast.unparse(i.context_expr.func) == 'TaskGroup' for i in n.items))
        self.assertTrue(calls(group, 'create_sensor'))

    def test_monitor_imports_required_group_and_empty_operator(self):
        imports = {a.name for n in ast.walk(tree(ROOT/'dags/task_monitor_slack.py')) if isinstance(n, ast.ImportFrom) for a in n.names}
        self.assertTrue({'TaskGroup', 'EmptyOperator'} <= imports)

    def test_callbacks_do_nothing_without_opt_in(self):
        for p in DAGS:
            for fn in [n for n in ast.walk(tree(p)) if isinstance(n, ast.FunctionDef) and 'notification_callback' in n.name]:
                callback = isolated_function(p, fn.name, {'os': os})
                with patch.dict(os.environ, {'ENABLE_EXTERNAL_NOTIFICATIONS': 'false'}):
                    self.assertIsNone(callback({}))

    def test_monitor_missing_dates_does_not_crash_or_send_real_message(self):
        output = []
        class FakeNotifier:
            def __init__(self, **kw): output.append(kw)
            def notify(self, context): pass
        from datetime import datetime
        ti = SimpleNamespace(state='failed', dag_id='demo_monitor', task_id='watch_demo',
                             execution_date=datetime(2025, 1, 1), start_date=None, end_date=None,
                             try_number=1, max_tries=0, log_url='https://airflow.example.com')
        callback = isolated_function(ROOT/'dags/task_monitor_slack.py', 'slack_notification_callback',
                                     {'os': os, 'State': SimpleNamespace(SUCCESS='success'), 'SlackNotifier': FakeNotifier,
                                      'SLACK_CONNECTION_ID': 'demo_slack', 'SLACK_CHANNEL': '#demo'})
        with patch.dict(os.environ, {'ENABLE_EXTERNAL_NOTIFICATIONS': 'true'}): callback({'ti': ti})
        self.assertEqual(output[0]['slack_conn_id'], 'demo_slack')
        self.assertIn('FALHA', output[0]['text'])

    def test_no_removed_query_operator(self):
        for p in DAGS:
            self.assertNotIn('BigQueryExecuteQueryOperator', p.read_text(encoding='utf8'))

    def test_bigquery_jobs_have_configuration(self):
        for p in DAGS:
            for call in calls(tree(p), 'BigQueryInsertJobOperator'):
                self.assertIn('configuration', {k.arg for k in call.keywords})

    def test_slack_keyword_preserved(self):
        for p in DAGS:
            for call in calls(tree(p), 'SlackNotifier'):
                self.assertIn('slack_conn_id', {k.arg for k in call.keywords})

    def test_no_private_endpoints_or_known_tokens(self):
        for p in ROOT.rglob('*'):
            if p.is_file() and p.suffix in ['.py', '.sql', '.json', '.md'] and p.name != Path(__file__).name:
                s = p.read_text(encoding='utf8')
                self.assertIsNone(re.search(r'https://hooks\.slack\.com/|https://[^\s]+webhook|AIza[A-Za-z0-9_-]{20,}|pat-[A-Za-z0-9_-]{20,}', s, re.I), str(p))

    def test_local_links_resolve(self):
        for p in ROOT.rglob('*.md'):
            for link in re.findall(r'\]\(([^)]+)\)', p.read_text(encoding='utf8')):
                if '://' not in link and not link.startswith('#'):
                    self.assertTrue((p.parent / link.split('#')[0]).exists(), f'{p}: {link}')


if __name__ == '__main__':
    unittest.main()
