# PostgreSQL: pivot de metadados e MERGE

Desenvolvi este fluxo para organizar extração, transformação e disponibilização de dados. Esta é uma cópia pública adaptada do código histórico, sem acesso ao ambiente original.

- [DAG Python](../../dags/postgres_metadata_pivot.py)
- Agendamento original registrado no arquivo: '0 4 * * *'. O fuso depende da DAG/instância; não deduzi um horário local onde ele não é explícito.
- Publicação: agendamento desabilitado, DAG pausada na criação e notificações externas condicionadas a ENABLE_EXTERNAL_NOTIFICATIONS=true.
- 4 declarações de tarefas no código; fábricas e loops podem criar quantidades diferentes na importação do Airflow.
- 2 consultas SQL literais separadas para estudo; a execução usa a configuração no Python. As cópias SQL não são arquivos automaticamente carregados pela DAG.

## Processo e decisões

A consulta usa MAX(CASE...) e GROUP BY para transformar atributos de metadados em colunas de uma visão de interação. A carga substitui uma tabela temporária no BigQuery e um job de MERGE atualiza a tabela analítica. Os nomes de atributos e colunas precisam ser alinhados ao modelo da instalação de destino; a agregação MAX também exige verificar a regra quando há valores múltiplos.

## Tarefas

| Task ID | Operador | Parâmetros selecionados |
| --- | --- | --- |
| init | EmptyOperator | {} |
| extract_metadata_pivot | PostgresToGCSOperator | {"export_format": "'json'"} |
| load_metadata_pivot_to_bigquery | GCSToBigQueryOperator | {"source_format": "'NEWLINE_DELIMITED_JSON'", "write_disposition": "'WRITE_TRUNCATE'"} |
| merge_metadata_pivot | BigQueryInsertJobOperator | {} |

## Dependências extraídas do código

```mermaid
flowchart TD
    init["init"] --> extract_metadata_pivot["extract_metadata_pivot"]
    load_metadata_pivot_to_bigquery["load_metadata_pivot_to_bigquery"] --> merge_metadata_pivot["merge_metadata_pivot"]
    extract_metadata_pivot["extract_metadata_pivot"] --> load_metadata_pivot_to_bigquery["load_metadata_pivot_to_bigquery"]
```

O diagrama foi reconstruído estaticamente a partir das dependências Python, sem conexão com o Airflow. Para o monitor, a fábrica cria sensores dentro de um TaskGroup; consulte o código para a topologia dinâmica.

Consulte [limitações e correções](../correcoes-limitacoes.md) e [configuração](../configuracao.md) antes de adaptar este fluxo.
