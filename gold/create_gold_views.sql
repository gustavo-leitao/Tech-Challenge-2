CREATE SCHEMA IF NOT EXISTS `techchallenge2-afabetizacao.gold`
OPTIONS(location="US");

CREATE OR REPLACE VIEW `techchallenge2-afabetizacao.gold.vw_taxa_vs_meta_uf` AS
SELECT
  ano, sigla_uf, rede,
  taxa_alfabetizacao,
  meta_alfabetizacao_2024,
  ROUND(taxa_alfabetizacao - meta_alfabetizacao_2024, 2) AS gap_meta_2024,
  CASE
    WHEN taxa_alfabetizacao >= meta_alfabetizacao_2024 THEN 'Meta atingida'
    ELSE 'Abaixo da meta'
  END AS status_meta
FROM `techchallenge2-afabetizacao.silver.uf`
WHERE rede = '0';

CREATE OR REPLACE VIEW `techchallenge2-afabetizacao.gold.vw_evolucao_brasil` AS
SELECT
  ano, rede, taxa_alfabetizacao,
  meta_alfabetizacao_2024, meta_alfabetizacao_2025, meta_alfabetizacao_2026
FROM `techchallenge2-afabetizacao.silver.brasil`
ORDER BY ano;

CREATE OR REPLACE VIEW `techchallenge2-afabetizacao.gold.vw_desempenho_alunos_rede` AS
SELECT
  ano, rede,
  COUNT(*) AS total_alunos_avaliados,
  SUM(CASE WHEN alfabetizado = '1' THEN 1 ELSE 0 END) AS total_alfabetizados,
  ROUND(SAFE_DIVIDE(SUM(CASE WHEN alfabetizado = '1' THEN 1 ELSE 0 END), COUNT(*)) * 100, 2) AS taxa_alfabetizacao_calculada,
  ROUND(AVG(proficiencia), 2) AS proficiencia_media
FROM `techchallenge2-afabetizacao.silver.alunos`
GROUP BY ano, rede;