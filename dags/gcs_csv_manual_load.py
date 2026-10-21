import os
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
default_args = {'owner': 'aloisio lemos', 'retries': 1, 'retry_delay': timedelta(minutes=5)}
gcp_bucket_airflow = 'demo-airflow-data-bucket'
gcs_file_path = 'demo/Teste/db_case_senior_performance_analyst.csv'
with DAG(dag_id='demo_gcs_csv_manual_load', start_date=datetime(2025, 2, 1), schedule=None, max_active_runs=1, default_args=default_args, catchup=False, tags=['CSV', 'BIGQUERY', 'manual', 'upload'], is_paused_upon_creation=True) as dag:
    start = EmptyOperator(task_id='start')
    load_csv_to_bigquery = GCSToBigQueryOperator(task_id='load_csv_to_bigquery', bucket=gcp_bucket_airflow, source_objects=[gcs_file_path], destination_project_dataset_table='demo-project.analytics.teste_nuvem', source_format='CSV', skip_leading_rows=1, field_delimiter=';', write_disposition='WRITE_TRUNCATE', create_disposition='CREATE_IF_NEEDED', schema_fields=[{'name': 'order_date', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'order_month', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'procesado', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'merchant_id', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'plan_ns', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'payment_method', 'type': 'STRING', 'mode': 'NULLABLE'}, {'name': 'installments', 'type': 'INTEGER', 'mode': 'NULLABLE'}, {'name': 'amount', 'type': 'NUMERIC', 'mode': 'NULLABLE'}, {'name': 'fee_merchant', 'type': 'NUMERIC', 'mode': 'NULLABLE'}, {'name': 'fee_procesador', 'type': 'NUMERIC', 'mode': 'NULLABLE'}, {'name': 'rebate', 'type': 'NUMERIC', 'mode': 'NULLABLE'}, {'name': 'cpt', 'type': 'NUMERIC', 'mode': 'NULLABLE'}])
    start >> load_csv_to_bigquery
