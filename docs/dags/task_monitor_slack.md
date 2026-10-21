# Monitoramento de tarefas externas e Slack

Desenvolvi este fluxo para organizar extração, transformação e disponibilização de dados. Esta é uma cópia pública adaptada do código histórico, sem acesso ao ambiente original.

- [DAG Python](../../dags/task_monitor_slack.py)
- Agendamento original registrado no arquivo: '*/10 * * * *'. O fuso depende da DAG/instância; não deduzi um horário local onde ele não é explícito.
- Publicação: agendamento desabilitado, DAG pausada na criação e notificações externas condicionadas a ENABLE_EXTERNAL_NOTIFICATIONS=true.
- 3 declarações de tarefas no código; fábricas e loops podem criar quantidades diferentes na importação do Airflow.
- 0 consultas SQL literais separadas para estudo; a execução usa a configuração no Python. As cópias SQL não são arquivos automaticamente carregados pela DAG.

## Processo e decisões

O monitor cria sensores para tarefas externas e notifica pelo Slack. Na cópia pública, TASKS_TO_MONITOR aponta para uma tarefa demonstrativa do repositório, falha externa pertence a failed_states e os sensores são criados no contexto do TaskGroup. O execution_delta histórico de dez minutos foi preservado como configuração a revisar: não equivale a buscar automaticamente a execução mais recente. Nenhum sensor foi executado nesta preparação.

## Tarefas

| Task ID | Operador | Parâmetros selecionados |
| --- | --- | --- |
| start | EmptyOperator | {} |
| end | EmptyOperator | {} |
| f'watch_{dag_id}_{task_id} | ExternalTaskSensor | {} |

## Dependências extraídas do código

```mermaid
flowchart TD
    monitor_group["monitor_group"] --> end["end"]
    start["start"] --> monitor_group["monitor_group"]
```

O diagrama foi reconstruído estaticamente a partir das dependências Python, sem conexão com o Airflow. Para o monitor, a fábrica cria sensores dentro de um TaskGroup; consulte o código para a topologia dinâmica.

Consulte [limitações e correções](../correcoes-limitacoes.md) e [configuração](../configuracao.md) antes de adaptar este fluxo.
