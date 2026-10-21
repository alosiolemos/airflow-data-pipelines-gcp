# Correções e limites da cópia pública

## Alterações realizadas

- Pivot com branching: retornos do terceiro check corrigidos para extract_metadata_pivot e pause_task_metadata_pivot.
- Monitor Slack: failed_states separado de allowed_states; sensores criados dentro do TaskGroup; duração protegida contra datas ausentes; alvo demonstrativo publicado.
- DAG IDs únicos; agendamentos públicos definidos como None e is_paused_upon_creation=True.
- Consultas do antigo BigQueryExecuteQueryOperator migradas para BigQueryInsertJobOperator, com o SQL e useLegacySql dentro da configuração do job. As consultas não foram executadas no BigQuery.
- Import de SlackNotifier normalizado para o módulo notifications.slack; outros padrões históricos do Airflow 2 foram mantidos.
- Nomes de empresas, conexões, schemas privados, projetos/datasets, buckets, canais, URLs, metadados e identificadores específicos substituídos por valores demonstrativos. Comentários originais foram removidos na reconstrução por AST.
- Callbacks condicionados a ENABLE_EXTERNAL_NOTIFICATIONS=true; webhook Teams obtido do ambiente, sem valor público.
- Filtros numéricos por entidade foram generalizados para IDs demonstrativos de 1001 a 1006, sem alterar datas ou flags de status.
- Os arquivos originais permaneceram intactos.

## Limitações importantes

- WRITE_APPEND pode repetir registros em reexecuções. Os fluxos não oferecem uma garantia geral de idempotência.
- Uma consulta COUNT que encontra dados não prova a existência de dados novos. Alguns filtros recuperam todo o histórico anterior ao dia corrente.
- WRITE_TRUNCATE substitui a tabela de destino. MERGE exige chave e unicidade coerentes na fonte; seu uso não elimina automaticamente duplicidades.
- Nomes de tarefas com “pause” representam uma ramificação sem extração, não uma pausa da DAG.
- Junções com trigger_rule=all_done seguem mesmo com falhas anteriores. Nos fluxos históricos com finalizadores all_done, não foi introduzida uma nova política de falha da DAG. Um callback que examina tarefas e um estado final verde podem divergir; não interprete o verde do finalizador como validação integral da carga.
- O sensor externo preserva a relação execution_delta de 10 minutos do original. É preciso alinhar a data lógica da execução externa e a do monitor; essa configuração não significa “vigiar a última execução”. Uma tarefa sem execução correspondente pode levar ao timeout.
- O alerta do monitor descreve o sensor e pode refletir timeout; a captura do sensor não é um log integral da tarefa externa.
- Schema SQL, tipos, chaves, partições e campos específicos exigem adaptação. O SQL mantém a lógica histórica com referências demonstrativas, não um conjunto de dados completo.
- Não houve importação em instância Airflow, acesso a bancos, upload GCS, execução SQL remota ou envio de notificações nesta preparação.
