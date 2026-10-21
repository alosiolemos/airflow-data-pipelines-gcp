# Como estudar e preparar a execução

## 1. Sem acesso ao Airflow antigo

Na pasta deste repositório, usando PowerShell ou terminal do VS Code com Python instalado, execute:

```powershell
python -m unittest discover -s tests -v
```

Os testes usam dados fictícios e análise de código. Não precisam de Airflow, credenciais ou nuvem. Não executam as DAGs.

## 2. Ambiente Airflow histórico de referência

O compose local de origem aponta por padrão para apache/airflow:2.10.4, mas permite sobrescrever a imagem. Isso não comprova qual versão rodou em cada captura. Não publiquei o compose nem o .env privados.

Para uma reprodução histórica isolada, a referência é Airflow 2.10.4 com Python 3.11, usando as [constraints oficiais](https://raw.githubusercontent.com/apache/airflow/constraints-2.10.4/constraints-3.11.txt). É uma referência legada, não uma recomendação de versão para produção atual. Não validei a instalação completa nesta preparação.

Em um terminal Linux/WSL2, dentro de um ambiente virtual Python 3.11 e na pasta do projeto:

```bash
python -m pip install -r requirements-airflow.txt --constraint https://raw.githubusercontent.com/apache/airflow/constraints-2.10.4/constraints-3.11.txt
```

O comando instala Airflow e os provedores de GCP, MySQL, PostgreSQL e Slack. A instalação pode precisar de bibliotecas do sistema para clientes de banco. A migração para versões atuais requer revisar imports, operadores e configuração; não foi presumida compatibilidade com Airflow 3.

Depois de preparar uma instância local, associe a pasta dags deste repositório à pasta de DAGs e confira os erros de importação. Não habilite os fluxos todos de uma vez. As cópias entram pausadas e sem agendamento; uma execução manual ainda pode acessar os destinos que você configurar.

## 3. Recursos demonstrativos a configurar

| Recurso | Marcador público |
| --- | --- |
| PostgreSQL Connection | demo_postgres |
| MySQL Connection | demo_mysql |
| Google Cloud Connection | google_cloud_default |
| Slack Connection | demo_slack |
| Bucket GCS | demo-airflow-data-bucket |
| Projeto e dataset BigQuery | demo-project.analytics |
| Schema PostgreSQL | demo_schema |

Configure credenciais via Airflow Connections/gestor de segredos, nunca dentro do código. Revise todas as referências demonstrativas e os schemas SQL antes de executar em um ambiente de teste. Os campos declarados em schema_fields não substituem um DDL completo da origem.

Para notificações, configure a conexão Slack ou o webhook Teams privado e habilite explicitamente ENABLE_EXTERNAL_NOTIFICATIONS=true somente em teste autorizado. Nenhum token acompanha este repositório.

Para o monitor externo, configure TASKS_TO_MONITOR e alinhe os agendamentos/datas lógicas antes de usar execution_delta. O exemplo aponta para demo_mysql_nps_parallel/finish, mas os agendamentos públicos estão desligados; não há uma rotina de monitoramento funcional automática após apenas copiar os arquivos.
