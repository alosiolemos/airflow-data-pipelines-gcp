# Validação desta publicação

Validação local de nove arquivos Python, sem importar ou executar Airflow. Os testes cobrem compilação, identificadores únicos, agendamentos desligados, estado pausado na criação, referências retornadas pelos branches, regras do sensor, agrupamento de tarefas, preservação dos parâmetros de notificação e links locais.

Os testes de lógica executam somente funções isoladas com PostgresHook e SlackNotifier falsos. Não consultam bancos nem enviam mensagens. Incluí casos de fonte vazia, fonte com registros, ausência de resposta, notificação desativada e duração sem datas disponíveis.

Na pasta do repositório, usando PowerShell ou terminal do VS Code com Python instalado:

```powershell
python -m unittest discover -s tests -v
```

Os testes estão em [test_dags.py](../tests/test_dags.py). Confira também os [resultados registrados](../tests/resultados.json).

Não foi realizado teste de importação em Airflow real, validação de SQL nos bancos, carga no GCS/BigQuery, teste de provedor Slack ou benchmark. A compilação Python não comprova compatibilidade de todas as versões de provedores. A captura do ambiente antigo é uma evidência histórica distinta desses testes.
