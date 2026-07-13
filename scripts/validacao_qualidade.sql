-- ============================================================
-- VALIDACAO DE QUALIDADE DE DADOS - Tech Challenge Fase 2
-- ============================================================

-- 1. DUPLICIDADE - Bronze UF (chave esperada: ano + sigla_uf + serie + rede)
SELECT ano, sigla_uf, serie, rede, COUNT(*) AS ocorrencias
FROM `techchallenge2-afabetizacao.bronze.uf`
GROUP BY ano, sigla_uf, serie, rede
HAVING COUNT(*) > 1;

-- 2. DUPLICIDADE - Bronze Municipio (chave esperada: ano + id_municipio + serie + rede)
SELECT ano, id_municipio, serie, rede, COUNT(*) AS ocorrencias
FROM `techchallenge2-afabetizacao.bronze.municipio`
GROUP BY ano, id_municipio, serie, rede
HAVING COUNT(*) > 1;

-- 3. DUPLICIDADE - Bronze Alunos (chave esperada: id_aluno + ano)
SELECT id_aluno, ano, COUNT(*) AS ocorrencias
FROM `techchallenge2-afabetizacao.bronze.alunos`
GROUP BY id_aluno, ano
HAVING COUNT(*) > 1;

-- 4. VALORES AUSENTES - Silver UF (campos criticos para analise)
SELECT
  COUNTIF(taxa_alfabetizacao IS NULL) AS nulos_taxa,
  COUNTIF(sigla_uf IS NULL) AS nulos_sigla_uf,
  COUNTIF(meta_alfabetizacao_2024 IS NULL) AS nulos_meta_2024,
  COUNT(*) AS total_linhas
FROM `techchallenge2-afabetizacao.silver.uf`;

-- 5. VALORES AUSENTES - Silver Municipio
SELECT
  COUNTIF(taxa_alfabetizacao IS NULL) AS nulos_taxa,
  COUNTIF(id_municipio IS NULL) AS nulos_id_municipio,
  COUNTIF(meta_alfabetizacao_2024 IS NULL) AS nulos_meta_2024,
  COUNT(*) AS total_linhas
FROM `techchallenge2-afabetizacao.silver.municipio`;

-- 6. VALIDACAO DE CHAVES - UFs esperadas (27) vs UFs presentes na Bronze
SELECT COUNT(DISTINCT sigla_uf) AS total_ufs_presentes
FROM `techchallenge2-afabetizacao.bronze.uf`;
-- Esperado: 27. Se vier 25, confirma o gap conhecido de DF/RR (ja documentado no README).

-- 7. CONSISTENCIA ENTRE TABELAS - sigla_uf da tabela uf existe em meta_alfabetizacao_uf?
SELECT DISTINCT u.sigla_uf
FROM `techchallenge2-afabetizacao.bronze.uf` u
LEFT JOIN `techchallenge2-afabetizacao.bronze.meta_alfabetizacao_uf` m
  ON u.sigla_uf = m.sigla_uf AND u.ano = m.ano
WHERE m.sigla_uf IS NULL;
-- Esperado: vazio. Se retornar linhas, ha UF sem meta correspondente (quebra de consistencia).

-- 8. CONSISTENCIA ENTRE TABELAS - id_municipio da tabela municipio existe em meta_alfabetizacao_municipio?
SELECT DISTINCT mu.id_municipio
FROM `techchallenge2-afabetizacao.bronze.municipio` mu
LEFT JOIN `techchallenge2-afabetizacao.bronze.meta_alfabetizacao_municipio` me
  ON mu.id_municipio = me.id_municipio AND mu.ano = me.ano
WHERE me.id_municipio IS NULL
LIMIT 20;
-- Esperado: idealmente vazio ou pequena lista. Municipios sem meta viram nota de limitacao no README.

-- 9. VALIDACAO CRUZADA - contagem Bronze vs Silver (confirma que o JOIN nao duplicou linhas)
SELECT
  (SELECT COUNT(*) FROM `techchallenge2-afabetizacao.bronze.uf`) AS bronze_uf,
  (SELECT COUNT(*) FROM `techchallenge2-afabetizacao.silver.uf`) AS silver_uf,
  (SELECT COUNT(*) FROM `techchallenge2-afabetizacao.bronze.municipio`) AS bronze_municipio,
  (SELECT COUNT(*) FROM `techchallenge2-afabetizacao.silver.municipio`) AS silver_municipio;
-- Esperado: silver_uf = bronze_uf, silver_municipio = bronze_municipio (LEFT JOIN nao deve duplicar).