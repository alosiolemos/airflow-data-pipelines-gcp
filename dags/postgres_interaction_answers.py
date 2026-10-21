import os
from datetime import datetime, timedelta
from airflow.decorators import dag
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import BranchPythonOperator
from airflow.operators.python import PythonOperator
from airflow.operators.dummy import DummyOperator
from pendulum import timezone
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.google.cloud.transfers.postgres_to_gcs import PostgresToGCSOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
import logging
default_args = {'owner': 'aloisio lemos', 'retries': 1, 'retry_delay': timedelta(minutes=3), 'execution_timeout': timedelta(hours=2), 'email': ['contato@example.com'], 'email_on_failure': True, 'email_on_retry': True}
gcp_bucket_airflow = 'demo-airflow-data-bucket'

@dag(dag_id='demo_postgres_interaction_answers', start_date=datetime(2025, 3, 1, tzinfo=timezone('America/Sao_Paulo')), schedule=None, catchup=False, max_active_runs=1, default_args=default_args, tags=['CXM', 'GCS', 'postgres', 'development'], is_paused_upon_creation=True)
def postgres_to_gcs_to_bigquery_dag():
    init = EmptyOperator(task_id='init')
    data_anterior = "{{ (data_interval_end - macros.timedelta(days=1)).strftime('%Y-%m-%d') }}"

    def check_data_in_interaction_answers(**kwargs):
        postgres_hook_interaction_answers = PostgresHook(postgres_conn_id='demo_postgres')
        sql = f"\n        SELECT COUNT(*)\n            FROM demo_schema.interaction_answers\n                WHERE DATE(TO_TIMESTAMP(created_at) AT TIME ZONE 'America/Sao_Paulo') = DATE_TRUNC('day', CURRENT_DATE - INTERVAL '1 day')\n        "
        result = postgres_hook_interaction_answers.get_first(sql)
        if not result or result[0] == 0:
            print('Nenhum dado encontrado. Tarefa pausada.')
            return 'pause_task_interaction_answers'
        print('Dados encontrados. Prosseguindo com a carga no BigQuery.')
        return 'extract_interaction_answers'
    check_data_interaction_answers = BranchPythonOperator(task_id='check_data_interaction_answers', python_callable=check_data_in_interaction_answers)
    pause_task_interaction_answers = DummyOperator(task_id='pause_task_interaction_answers')
    extract_interaction_answers = PostgresToGCSOperator(task_id='extract_interaction_answers', postgres_conn_id='demo_postgres', sql=f"\n           SELECT \n                interaction_uuid,\n                survey_item_uuid,\n                answer,\n                comment,\n                created_at,\n                deleted_at,\n                TO_CHAR(TO_TIMESTAMP(created_at), 'YYYY-MM-DD HH24:MI') AS created_dt,\n                TO_CHAR(TO_TIMESTAMP(deleted_at), 'YYYY-MM-DD HH24:MI') AS deleted_dt,\n                TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI') AS extracted_at\n            FROM \n                demo_schema.interaction_answers\n            WHERE \n                DATE(TO_TIMESTAMP(created_at) AT TIME ZONE 'America/Sao_Paulo') BETWEEN \n                    (CURRENT_DATE - INTERVAL '20 day') AND \n                    (CURRENT_DATE - INTERVAL '0 day')\n        ", bucket=gcp_bucket_airflow, filename=f'DeepDive/demo/Bronze/interaction_answers_{data_anterior}.json', export_format='json', gzip=False)
    load_interaction_answers_temp = GCSToBigQueryOperator(task_id='load_interaction_answers_temp', bucket=gcp_bucket_airflow, source_objects=[f'DeepDive/demo/Bronze/interaction_answers_{data_anterior}.json'], destination_project_dataset_table='demo-project.analytics.interactions_answers_temp', source_format='NEWLINE_DELIMITED_JSON', create_disposition='CREATE_IF_NEEDED', write_disposition='WRITE_TRUNCATE', skip_leading_rows=1, ignore_unknown_values=True, schema_fields=[{'name': 'interaction_uuid', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'survey_item_uuid', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'answer', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'comment', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'created_at', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'deleted_at', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'created_dt', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'deleted_dt', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'extracted_at', 'type': 'STRING', 'mode': 'NULLABLE'}])
    merge_interactions_answers = BigQueryInsertJobOperator(task_id='merge_interactions_answers', configuration={'query': {'query': '\n            CREATE TABLE IF NOT EXISTS `demo-project.analytics.interaction_answers` AS \n            SELECT * FROM `demo-project.analytics.interactions_answers_temp`\n            WHERE 1 = 0;\n\n            MERGE INTO `demo-project.analytics.interaction_answers` AS target\n            USING `demo-project.analytics.interactions_answers_temp` AS source\n            ON target.interaction_uuid = source.interaction_uuid\n            AND target.survey_item_uuid = source.survey_item_uuid\n            WHEN MATCHED THEN\n            UPDATE SET \n                target.answer = source.answer,\n                target.comment = source.comment,\n                target.created_at = source.created_at,\n                target.deleted_at = source.deleted_at,\n                target.created_dt = source.created_dt,\n                target.deleted_dt = source.deleted_dt,\n                target.extracted_at = source.extracted_at\n            WHEN NOT MATCHED THEN\n            INSERT ROW;\n        ', 'useLegacySql': False}})
    continue_after_interaction_answers = DummyOperator(task_id='continue_after_interaction_answers', trigger_rule='all_done')
    init >> check_data_interaction_answers
    check_data_interaction_answers >> [pause_task_interaction_answers, extract_interaction_answers]
    extract_interaction_answers >> load_interaction_answers_temp >> merge_interactions_answers >> continue_after_interaction_answers
    pause_task_interaction_answers >> continue_after_interaction_answers
postgres_to_gcs_to_bigquery_dag()
