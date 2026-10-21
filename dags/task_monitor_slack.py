from airflow.utils.task_group import TaskGroup
from airflow.operators.empty import EmptyOperator
import os
from airflow.decorators import dag, task
from pendulum import datetime
from airflow.providers.slack.notifications.slack import SlackNotifier
from airflow.models import TaskInstance
from airflow.sensors.external_task import ExternalTaskSensor
from airflow.utils.state import State
from typing import List
from datetime import timedelta
SLACK_CONNECTION_ID = 'demo_slack'
SLACK_CHANNEL = '#demo-airflow'
TASKS_TO_MONITOR = {'demo_mysql_nps_parallel': ['finish']}

def slack_notification_callback(context):
    if os.environ.get('ENABLE_EXTERNAL_NOTIFICATIONS') != 'true':
        return
    ti = context['ti']
    emoji = ':white_check_mark:' if ti.state == State.SUCCESS else ':x:'
    status = 'CONCLUÍDO' if ti.state == State.SUCCESS else 'FALHA'
    message = f"\n{emoji} *MONITORAMENTO DE TAREFAS* {emoji}\n• *Pipeline*: `{ti.dag_id}`\n• *Tarefa*: `{ti.task_id}`\n• *Status*: {status}\n• *Execução*: {ti.execution_date.strftime('%d/%m/%Y %H:%M')}\n• *Duração*: {((ti.end_date - ti.start_date).total_seconds() / 60 if ti.end_date and ti.start_date else 0):.2f} min\n• *Tentativa*: {ti.try_number}/{ti.max_tries + 1}\n• *Logs*: {ti.log_url}"
    notifier = SlackNotifier(slack_conn_id=SLACK_CONNECTION_ID, text=message, channel=SLACK_CHANNEL)
    notifier.notify(context)

@dag(dag_id='demo_task_monitor_slack', start_date=datetime(2025, 5, 29), schedule_interval=None, catchup=False, tags=['monitoring', 'alerting'], default_args={'retries': 0, 'on_success_callback': slack_notification_callback, 'on_failure_callback': slack_notification_callback}, is_paused_upon_creation=True)
def task_monitoring_dag():

    def create_sensor(dag_id: str, task_id: str) -> ExternalTaskSensor:
        return ExternalTaskSensor(task_id=f'watch_{dag_id}_{task_id}', external_dag_id=dag_id, external_task_id=task_id, mode='reschedule', timeout=3600, allowed_states=[State.SUCCESS], execution_delta=timedelta(minutes=10), poke_interval=60, on_success_callback=slack_notification_callback, on_failure_callback=slack_notification_callback, failed_states=[State.FAILED])
    start = EmptyOperator(task_id='start')
    end = EmptyOperator(task_id='end')
    with TaskGroup('monitor_group') as monitor_group:
        for dag_id, tasks in TASKS_TO_MONITOR.items():
            for task_id in tasks:
                create_sensor(dag_id, task_id)
    start >> monitor_group >> end
task_monitor_dag = task_monitoring_dag()
