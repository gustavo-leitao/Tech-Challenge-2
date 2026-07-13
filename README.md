# \# Tech Challenge – Fase 2: Pipeline de Dados para Análise da Alfabetização no Brasil

# 

# \## 1. Contexto

# 

# Este projeto implementa um pipeline de dados híbrido (batch + streaming simulado) seguindo a

# \*\*Arquitetura Medalhão (Bronze/Silver/Gold)\*\*, utilizando dados públicos do \*\*Indicador Criança

# Alfabetizada (Inep)\*\*, disponibilizados via \*\*Base dos Dados\*\* em BigQuery público, cobrindo o

# período de 2023-2024.

# 

# O objetivo é analisar a evolução da alfabetização no 2º ano do Ensino Fundamental no Brasil,

# comparando taxas observadas com metas oficiais, por UF, Município e rede de ensino.

# 

# \## 2. Arquitetura

# 

# !\[Estrutura das camadas Bronze/Silver/Gold no BigQuery](docs/images/bigquery\_camadas.png)

# 

# \- \*\*Bronze\*\*: ingestão bruta das 7 entidades da Base dos Dados via `CREATE TABLE AS SELECT`

# &#x20; no BigQuery, com carimbo de data de ingestão.

# \- \*\*Silver\*\*: limpeza, padronização e integração das entidades (UF+metas, Município+metas,

# &#x20; Brasil, Alunos), com quarentena explícita de registros inválidos.

# \- \*\*Gold\*\*: views analíticas prontas para consumo (taxa vs. meta por UF, evolução temporal

# &#x20; nacional, desempenho de alunos por rede).

# 

# \## 3. Tecnologias e Justificativa (Rastreabilidade)

# 

# | Ferramenta | Onde foi ensinada | Uso no projeto |

# |---|---|---|

# | Arquitetura Medalhão | ETL Pipelines Aula 1 | Estrutura geral do pipeline |

# | BigQuery | ETL Pipelines Aula 3 | Bronze, Silver e Gold (data warehouse serverless) |

# | Pub/Sub + Dataflow | ETL Pipelines Aula 3 | Streaming simulado (arquitetura prevista) |

# | SQL analítico (GROUP BY, CASE, JOIN) | Bancos Relacionais Aula 2 | Integração Silver e views Gold |

# | Quarentena de dados inválidos | ETL Pipelines Aula 1 | Tabela `alunos\_quarentena` |

# | FinOps | ETL Pipelines Aula 4 | Seção 6 |

# 

# \## 4. Fonte de Dados

# 

# Exclusivamente \*\*Base dos Dados\*\* (dataset `br\_inep\_avaliacao\_alfabetizacao`), sem enriquecimento

# externo. Entidades utilizadas: `uf`, `municipio`, `alunos`, `meta\_alfabetizacao\_brasil`,

# `meta\_alfabetizacao\_uf`, `meta\_alfabetizacao\_municipio`, `dicionario`.

# 

# \## 5. Limitações Conhecidas da Fonte

# 

# \- \*\*DF e RR ausentes\*\* na tabela `uf` — limitação identificada na fonte, não resolvida na origem;

# &#x20; documentada aqui para transparência analítica.

# \- Colunas `proporcao\_aluno\_nivel\_0` a `\_8` majoritariamente nulas em `uf`/`municipio` — característica

# &#x20; da fonte, não preenchidas artificialmente.

# 

# \## 6. FinOps

# 

# \_(a completar com print real do Billing do GCP)\_

# 

# \## 7. Streaming (Simulado)

# 

# A camada de streaming foi projetada com Pub/Sub + Dataflow (citados em ETL Pipelines Aula 3),

# simulando a chegada periódica de novas medições — a fonte real é estática (atualização anual/bianual),

# portanto o streaming aqui é uma simulação declarada, não um requisito funcional da fonte de dados.

# 

# \## 8. Como Reproduzir

# 

# Os scripts SQL de cada camada estão em `/bronze`, `/silver` e `/gold`. Basta rodar na ordem

# (Bronze → Silver → Gold) no BigQuery, com um projeto GCP próprio.

# 

# \## 9. Vídeo Executivo

# 

# \_(link a adicionar após gravação)\_

