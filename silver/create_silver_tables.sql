CREATE SCHEMA IF NOT EXISTS `techchallenge2-afabetizacao.silver`
OPTIONS(location="US");

CREATE OR REPLACE TABLE `techchallenge2-afabetizacao.silver.brasil` AS
SELECT
  ano, rede, taxa_alfabetizacao,
  meta_alfabetizacao_2024, meta_alfabetizacao_2025, meta_alfabetizacao_2026,
  meta_alfabetizacao_2027, meta_alfabetizacao_2028, meta_alfabetizacao_2029, meta_alfabetizacao_2030,
  percentual_participacao,
  CURRENT_TIMESTAMP() AS data_processamento
FROM `techchallenge2-afabetizacao.bronze.meta_alfabetizacao_brasil`;

CREATE OR REPLACE TABLE `techchallenge2-afabetizacao.silver.uf` AS
SELECT
  u.ano, u.sigla_uf, u.serie, u.rede,
  u.taxa_alfabetizacao, u.media_portugues,
  m.meta_alfabetizacao_2024, m.meta_alfabetizacao_2025, m.meta_alfabetizacao_2026,
  m.meta_alfabetizacao_2027, m.meta_alfabetizacao_2028, m.meta_alfabetizacao_2029, m.meta_alfabetizacao_2030,
  m.percentual_participacao,
  CURRENT_TIMESTAMP() AS data_processamento
FROM `techchallenge2-afabetizacao.bronze.uf` u
LEFT JOIN `techchallenge2-afabetizacao.bronze.meta_alfabetizacao_uf` m
  ON u.ano = m.ano AND u.sigla_uf = m.sigla_uf AND u.rede = m.rede;

CREATE OR REPLACE TABLE `techchallenge2-afabetizacao.silver.municipio` AS
SELECT
  mu.ano, mu.id_municipio, mu.serie, mu.rede,
  mu.taxa_alfabetizacao, mu.media_portugues,
  me.meta_alfabetizacao_2024, me.meta_alfabetizacao_2025, me.meta_alfabetizacao_2026,
  me.meta_alfabetizacao_2027, me.meta_alfabetizacao_2028, me.meta_alfabetizacao_2029, me.meta_alfabetizacao_2030,
  me.percentual_participacao,
  CURRENT_TIMESTAMP() AS data_processamento
FROM `techchallenge2-afabetizacao.bronze.municipio` mu
LEFT JOIN `techchallenge2-afabetizacao.bronze.meta_alfabetizacao_municipio` me
  ON mu.ano = me.ano AND mu.id_municipio = me.id_municipio AND mu.rede = me.rede;

CREATE OR REPLACE TABLE `techchallenge2-afabetizacao.silver.alunos` AS
SELECT
  ano, id_municipio, id_escola, id_aluno, caderno, serie, rede,
  presenca, preenchimento_caderno, alfabetizado, proficiencia, peso_aluno,
  CURRENT_TIMESTAMP() AS data_processamento
FROM `techchallenge2-afabetizacao.bronze.alunos`
WHERE presenca = '1';

CREATE OR REPLACE TABLE `techchallenge2-afabetizacao.silver.alunos_quarentena` AS
SELECT
  ano, id_municipio, id_escola, id_aluno, caderno, serie, rede,
  presenca, preenchimento_caderno, alfabetizado, proficiencia, peso_aluno,
  'presenca = 0 (aluno ausente na avaliacao)' AS motivo_quarentena,
  CURRENT_TIMESTAMP() AS data_processamento
FROM `techchallenge2-afabetizacao.bronze.alunos`
WHERE presenca = '0';