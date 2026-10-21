import os
from datetime import datetime, timedelta
from airflow import Dataset
import pytz
from airflow.utils.state import State
from airflow.decorators import dag
from airflow.operators.empty import EmptyOperator
from airflow.providers.google.cloud.transfers.mysql_to_gcs import MySQLToGCSOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.providers.slack.notifications.slack import SlackNotifier
from airflow.utils.trigger_rule import TriggerRule
SLACK_CONNECTION_ID = 'demo_slack'
SLACK_CHANNEL = '#demo-airflow'

def slack_notification_callback(context):
    if os.environ.get('ENABLE_EXTERNAL_NOTIFICATIONS') != 'true':
        return
    dag_run = context['dag_run']
    ti = context['ti']
    timezone = pytz.timezone('America/Sao_Paulo')
    dag_status = 'success'
    for task in dag_run.get_task_instances():
        if task.state == State.FAILED:
            dag_status = 'failed'
            break
    start = dag_run.start_date
    if start:
        start = start.astimezone(timezone)
        start_str = start.strftime('%d/%m/%Y %H:%M')
    else:
        start_str = 'N/A'
    end = datetime.utcnow().replace(tzinfo=pytz.utc).astimezone(timezone)
    end_str = end.strftime('%d/%m/%Y %H:%M')
    if start:
        duration_seconds = (end - start).total_seconds()
        duration_str = f'{int(duration_seconds // 60)} minutos'
    else:
        duration_str = 'N/A'
    dag_link = f'https://airflow.example.com{ti.dag_id}/grid'
    emoji = ':white_check_mark:' if dag_status == 'success' else ':x:'
    message = f"\n*NPS DATA PIPELINE - STATUS*\n\n• *DAG*: `{ti.dag_id}`\n• *Status*: {('*SUCCESS*' if dag_status == 'success' else '*FAILED*')}\n• *Início*: {start_str}\n• *Fim*: {end_str}\n• *Duração*: {duration_str}\n• *Run ID*: `{dag_run.run_id}`\n\n🔗 <{dag_link}|Ver DAG no Airflow>\n"
    notifier = SlackNotifier(slack_conn_id=SLACK_CONNECTION_ID, text=message, channel=SLACK_CHANNEL)
    notifier.notify(context)
default_args = {'owner': 'aloisio lemos', 'retries': 1, 'retry_delay': timedelta(minutes=5)}
gcp_bucket_airflow = 'demo-airflow-data-bucket'

@dag(dag_id='demo_mysql_questions_history', start_date=datetime(2025, 2, 1), schedule=None, max_active_runs=1, default_args=default_args, catchup=False, tags=['NPS', 'BIGQUERY', 'daily', 'development', 'ingestion', 'MySQL', 'Google'], is_paused_upon_creation=True)
def nps_data_pipeline():
    init = EmptyOperator(task_id='init')
    question_answer_mysql_to_gcs = MySQLToGCSOperator(task_id='question_answer_mysql_to_gcs', mysql_conn_id='demo_mysql', sql="\n            SELECT \n                id,\n                question_id,\n                organization_id,\n                campaign_id,\n                type,\n                status,\n                create_time,\n                update_time,\n                FROM_UNIXTIME(create_time) AS create_DT,\n                FROM_UNIXTIME(update_time) AS update_DT\n            FROM \n                question_answer            \n            WHERE \n                FROM_UNIXTIME(create_time) BETWEEN '2021-06-30 23:59:59' AND '2021-12-31 23:59:59'\n        ", bucket=gcp_bucket_airflow, filename='demo/nps_tabelas_json/question_answer.json', export_format='json', gzip=True)
    load_question_answer_to_bq = GCSToBigQueryOperator(task_id='load_question_answer_to_bq', bucket=gcp_bucket_airflow, source_objects=['demo/nps_tabelas_json/question_answer.json'], destination_project_dataset_table='demo-project.analytics.question_answer', source_format='NEWLINE_DELIMITED_JSON', write_disposition='WRITE_APPEND', create_disposition='CREATE_IF_NEEDED', schema_fields=[{'name': 'id', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'question_id', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'organization_id', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'campaign_id', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'type', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'status', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'create_time', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'update_time', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'create_DT', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'update_DT', 'type': 'STRING', 'mode': 'NULLABLE'}])
    question_answer_nps_mysql_to_gcs = MySQLToGCSOperator(task_id='question_answer_nps_mysql_to_gcs', mysql_conn_id='demo_mysql', sql="\n            SELECT \n                id, \n                question_answer_id,\n                status, \n                nps_comment, \n                nps_answer,\n                last_nps_answer, \n                create_time,\n                update_time,\n                FROM_UNIXTIME(create_time) AS create_DT,\n                FROM_UNIXTIME(update_time) AS update_DT\n            FROM \n                common.question_answer_nps\n            WHERE \n                FROM_UNIXTIME(create_time) BETWEEN '2021-06-30 23:59:59' AND '2021-12-31 23:59:59'\n        ", bucket=gcp_bucket_airflow, filename='demo/nps_tabelas_json/question_answer_nps.json', export_format='json', gzip=True)
    load_question_answer_nps_to_bq = GCSToBigQueryOperator(task_id='load_question_answer_nps_to_bq', bucket=gcp_bucket_airflow, source_objects=['demo/nps_tabelas_json/question_answer_nps.json'], destination_project_dataset_table='demo-project.analytics.question_answer_nps', source_format='NEWLINE_DELIMITED_JSON', write_disposition='WRITE_APPEND', create_disposition='CREATE_IF_NEEDED', schema_fields=[{'name': 'id', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'question_answer_id', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'status', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'nps_comment', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'nps_answer', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'last_nps_answer', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'create_time', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'update_time', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'create_DT', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'update_DT', 'type': 'STRING', 'mode': 'NULLABLE'}])
    question_answer_csat_mysql_to_gcs = MySQLToGCSOperator(task_id='question_answer_csat_mysql_to_gcs', mysql_conn_id='demo_mysql', sql="\n            SELECT \n\t\t\t\tid,\n\t\t\t\tstatus,\n\t\t\t\tcsat_type,\n\t\t\t\tcsat_answer,\n\t\t\t\tcsat_comment,\n\t\t\t\tlast_csat_answer,\n\t\t\t\tquestion_answer_id,\n\t\t\t\tcreate_time,\n\t\t\t\tupdate_time,\n                FROM_UNIXTIME(create_time) AS create_DT,\n                FROM_UNIXTIME(update_time) AS update_DT\n            FROM \n                question_answer_csat\n            WHERE \n\t\t\t    FROM_UNIXTIME(create_time) BETWEEN '2025-01-01 00:00:00' AND '2025-12-31 23:59:59'\n        ", bucket=gcp_bucket_airflow, filename='demo/nps_tabelas_json/question_answer_csat.json', export_format='json', gzip=True)
    load_question_answer_csat_to_bq = GCSToBigQueryOperator(task_id='load_question_answer_csat_to_bq', bucket=gcp_bucket_airflow, source_objects=['demo/nps_tabelas_json/question_answer_csat.json'], destination_project_dataset_table='demo-project.analytics.question_answer_csat', source_format='NEWLINE_DELIMITED_JSON', write_disposition='WRITE_APPEND', create_disposition='CREATE_IF_NEEDED', schema_fields=[{'name': 'id', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'status', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'csat_type', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'csat_answer', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'csat_comment', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'last_csat_answer', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'question_answer_id', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'create_time', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'update_time', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'create_DT', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'update_DT', 'type': 'STRING', 'mode': 'NULLABLE'}])
    final_status = EmptyOperator(task_id='final_status', on_success_callback=slack_notification_callback, on_failure_callback=slack_notification_callback, trigger_rule=TriggerRule.ALL_DONE)
    init >> question_answer_mysql_to_gcs >> load_question_answer_to_bq
    load_question_answer_to_bq >> question_answer_nps_mysql_to_gcs >> load_question_answer_nps_to_bq
    load_question_answer_nps_to_bq >> question_answer_csat_mysql_to_gcs >> load_question_answer_csat_to_bq >> final_status
nps_data_pipeline = nps_data_pipeline()
