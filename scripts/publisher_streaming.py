"""
Simulador de ingestao streaming - Tech Challenge Fase 2
Publica registros da tabela 'uf' como se fossem novas medições chegando em tempo real.
Rastreabilidade: Pub/Sub citado em ETL Pipelines Aula 3.
"""
import json
import time
from google.cloud import bigquery, pubsub_v1

PROJECT_ID = "techchallenge2-afabetizacao"
TOPIC_ID = "streaming-indicador-alfabetizacao"

bq_client = bigquery.Client(project=PROJECT_ID)
publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(PROJECT_ID, TOPIC_ID)

query = """
    SELECT ano, sigla_uf, serie, rede, taxa_alfabetizacao, media_portugues
    FROM `techchallenge2-afabetizacao.bronze.uf`
    LIMIT 10
"""

rows = bq_client.query(query).result()

for row in rows:
    mensagem = {
        "ano": row.ano,
        "sigla_uf": row.sigla_uf,
        "serie": row.serie,
        "rede": row.rede,
        "taxa_alfabetizacao": row.taxa_alfabetizacao,
        "media_portugues": row.media_portugues,
        "evento": "atualizacao_indicador_simulada"
    }
    data = json.dumps(mensagem).encode("utf-8")
    future = publisher.publish(topic_path, data)
    print(f"Publicado: {mensagem['sigla_uf']} - message_id: {future.result()}")
    time.sleep(1)  # simula chegada espacada de eventos

print("Simulacao de streaming concluida.")