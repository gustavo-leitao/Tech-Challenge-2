CREATE SCHEMA IF NOT EXISTS `techchallenge2-afabetizacao.bronze`
OPTIONS(location="US");

CREATE OR REPLACE TABLE `techchallenge2-afabetizacao.bronze.uf` AS
SELECT *, CURRENT_TIMESTAMP() AS data_ingestao
FROM `basedosdados.br_inep_avaliacao_alfabetizacao.uf`;

CREATE OR REPLACE TABLE `techchallenge2-afabetizacao.bronze.municipio` AS
SELECT *, CURRENT_TIMESTAMP() AS data_ingestao
FROM `basedosdados.br_inep_avaliacao_alfabetizacao.municipio`;

CREATE OR REPLACE TABLE `techchallenge2-afabetizacao.bronze.alunos` AS
SELECT *, CURRENT_TIMESTAMP() AS data_ingestao
FROM `basedosdados.br_inep_avaliacao_alfabetizacao.alunos`;

CREATE OR REPLACE TABLE `techchallenge2-afabetizacao.bronze.meta_alfabetizacao_brasil` AS
SELECT *, CURRENT_TIMESTAMP() AS data_ingestao
FROM `basedosdados.br_inep_avaliacao_alfabetizacao.meta_alfabetizacao_brasil`;

CREATE OR REPLACE TABLE `techchallenge2-afabetizacao.bronze.meta_alfabetizacao_uf` AS
SELECT *, CURRENT_TIMESTAMP() AS data_ingestao
FROM `basedosdados.br_inep_avaliacao_alfabetizacao.meta_alfabetizacao_uf`;

CREATE OR REPLACE TABLE `techchallenge2-afabetizacao.bronze.meta_alfabetizacao_municipio` AS
SELECT *, CURRENT_TIMESTAMP() AS data_ingestao
FROM `basedosdados.br_inep_avaliacao_alfabetizacao.meta_alfabetizacao_municipio`;

CREATE OR REPLACE TABLE `techchallenge2-afabetizacao.bronze.dicionario` AS
SELECT *, CURRENT_TIMESTAMP() AS data_ingestao
FROM `basedosdados.br_inep_avaliacao_alfabetizacao.dicionario`;