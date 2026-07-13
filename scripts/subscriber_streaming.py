"""
Consumidor do streaming simulado - grava mensagens do Pub/Sub em uma tabela Bronze dedicada.
"""
import json
from google.cloud import bigquery, pubsub_v1
from concurrent.futures import TimeoutError

PROJECT_ID = "techchallenge2-afabetizacao"
SUBSCRIPTION_ID = "sub-streaming-alfabetizacao"
TABLE_ID = "techchallenge2-afabetizacao.bronze.uf_streaming"

bq_client = bigquery.Client(project=PROJECT_ID)
subscriber = pubsub_v1.SubscriberClient()
subscription_path = subscriber.subscription_path(PROJECT_ID, SUBSCRIPTION_ID)

def callback(message):
    dado = json.loads(message.data.decode("utf-8"))
    dado["data_processamento_streaming"] = bigquery.ScalarQueryParameter(None, "TIMESTAMP", None)  # placeholder, ajustado abaixo

    row_to_insert = {
        "ano": dado["ano"],
        "sigla_uf": dado["sigla_uf"],
        "serie": dado["serie"],
        "rede": dado["rede"],
        "taxa_alfabetizacao": dado["taxa_alfabetizacao"],
        "media_portugues": dado["media_portugues"],
        "evento": dado["evento"],
    }

    errors = bq_client.insert_rows_json(TABLE_ID, [row_to_insert])
    if errors:
        print(f"Erro ao inserir: {errors}")
    else:
        print(f"Inserido no BigQuery: {row_to_insert['sigla_uf']}")

    message.ack()

streaming_pull_future = subscriber.subscribe(subscription_path, callback=callback)
print(f"Escutando mensagens em {subscription_path}...\n(Ctrl+C para parar)")

with subscriber:
    try:
        streaming_pull_future.result(timeout=30)  # escuta por 30s e encerra (simulação controlada)
    except TimeoutError:
        streaming_pull_future.cancel()
        streaming_pull_future.result()
        print("Encerrado apos 30s (simulacao concluida).")