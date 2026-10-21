# PostgreSQL: ramificações por disponibilidade de dados

Desenvolvi este fluxo para organizar extração, transformação e disponibilização de dados. Esta é uma cópia pública adaptada do código histórico, sem acesso ao ambiente original.

- [DAG Python](../../dags/postgres_metadata_branching.py)
- Agendamento original registrado no arquivo: '0 4 * * *'. O fuso depende da DAG/instância; não deduzi um horário local onde ele não é explícito.
- Publicação: agendamento desabilitado, DAG pausada na criação e notificações externas condicionadas a ENABLE_EXTERNAL_NOTIFICATIONS=true.
- 15 declarações de tarefas no código; fábricas e loops podem criar quantidades diferentes na importação do Airflow.
- 6 consultas SQL literais separadas para estudo; a execução usa a configuração no Python. As cópias SQL não são arquivos automaticamente carregados pela DAG.

## Processo e decisões

O exemplo encadeia três blocos: metadata, interaction_metadata e pivot. Cada bloco consulta a existência de dados e retorna o task_id da extração ou do caminho sem carga. Corrigi o terceiro check, que retornava os nomes do primeiro bloco. As cargas usam APPEND; os caminhos intermediários all_done mantêm o fluxo, mas não são uma validação de sucesso de todas as cargas.

## Tarefas

| Task ID | Operador | Parâmetros selecionados |
| --- | --- | --- |
| init | EmptyOperator | {} |
| check_data_metadata | BranchPythonOperator | {} |
| pause_task_metadata | DummyOperator | {} |
| extract_metadata | PostgresToGCSOperator | {"export_format": "'json'"} |
| load_metadata_to_bigquery | GCSToBigQueryOperator | {"source_format": "'NEWLINE_DELIMITED_JSON'", "write_disposition": "'WRITE_APPEND'"} |
| continue_after_metadata | DummyOperator | {"trigger_rule": "'all_done'"} |
| check_data_interaction_metadata | BranchPythonOperator | {} |
| pause_task_interaction_metadata | DummyOperator | {} |
| extract_interaction_metadata | PostgresToGCSOperator | {"export_format": "'json'"} |
| load_interaction_metadata_to_bigquery | GCSToBigQueryOperator | {"source_format": "'NEWLINE_DELIMITED_JSON'", "write_disposition": "'WRITE_APPEND'"} |
| continue_after_interaction_metadata | DummyOperator | {"trigger_rule": "'all_done'"} |
| check_data_metadata_pivot | BranchPythonOperator | {} |
| pause_task_metadata_pivot | DummyOperator | {} |
| extract_metadata_pivot | PostgresToGCSOperator | {"export_format": "'json'"} |
| load_metadata_pivot_to_bigquery | GCSToBigQueryOperator | {"source_format": "'NEWLINE_DELIMITED_JSON'", "write_disposition": "'WRITE_APPEND'"} |

## Dependências extraídas do código

```mermaid
flowchart TD
    init["init"] --> check_data_metadata["check_data_metadata"]
    check_data_metadata["check_data_metadata"] --> pause_task_metadata["pause_task_metadata"]
    check_data_metadata["check_data_metadata"] --> extract_metadata["extract_metadata"]
    extract_metadata["extract_metadata"] --> load_metadata_to_bigquery["load_metadata_to_bigquery"]
    load_metadata_to_bigquery["load_metadata_to_bigquery"] --> continue_after_metadata["continue_after_metadata"]
    pause_task_metadata["pause_task_metadata"] --> continue_after_metadata["continue_after_metadata"]
    continue_after_metadata["continue_after_metadata"] --> check_data_interaction_metadata["check_data_interaction_metadata"]
    check_data_interaction_metadata["check_data_interaction_metadata"] --> pause_task_interaction_metadata["pause_task_interaction_metadata"]
    check_data_interaction_metadata["check_data_interaction_metadata"] --> extract_interaction_metadata["extract_interaction_metadata"]
    extract_interaction_metadata["extract_interaction_metadata"] --> load_interaction_metadata_to_bigquery["load_interaction_metadata_to_bigquery"]
    load_interaction_metadata_to_bigquery["load_interaction_metadata_to_bigquery"] --> continue_after_interaction_metadata["continue_after_interaction_metadata"]
    pause_task_interaction_metadata["pause_task_interaction_metadata"] --> continue_after_interaction_metadata["continue_after_interaction_metadata"]
    continue_after_interaction_metadata["continue_after_interaction_metadata"] --> check_data_metadata_pivot["check_data_metadata_pivot"]
    check_data_metadata_pivot["check_data_metadata_pivot"] --> pause_task_metadata_pivot["pause_task_metadata_pivot"]
    check_data_metadata_pivot["check_data_metadata_pivot"] --> extract_metadata_pivot["extract_metadata_pivot"]
    extract_metadata_pivot["extract_metadata_pivot"] --> load_metadata_pivot_to_bigquery["load_metadata_pivot_to_bigquery"]
```

O diagrama foi reconstruído estaticamente a partir das dependências Python, sem conexão com o Airflow. Para o monitor, a fábrica cria sensores dentro de um TaskGroup; consulte o código para a topologia dinâmica.

Consulte [limitações e correções](../correcoes-limitacoes.md) e [configuração](../configuracao.md) antes de adaptar este fluxo.
