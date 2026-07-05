# Dicionário de Dados — Avaliação da Alfabetização (Inep)

**Fonte**: Base dos Dados — dataset `basedosdados.br_inep_avaliacao_alfabetizacao`
**Cobertura temporal**: 2023–2024
**Última atualização**: 05/07/2026 (Dia 1 do projeto)
**Princípio metodológico**: todo campo documentado aqui foi confirmado diretamente na fonte (tabela `dicionario` do BigQuery ou documentação oficial do Inep). Nenhum significado foi inferido sem confirmação.

---

## 1. Entidades do Dataset

O dataset contém **6 entidades de dados** + 1 tabela auxiliar de metadados:

| Tabela | Descrição | Linhas (confirmado) |
|---|---|---|
| `uf` | Resultados da avaliação por Unidade da Federação | 145 |
| `municipio` | Resultados da avaliação por Município | 23.995 |
| `alunos` | Microdados individuais por aluno avaliado | 3.867.999 |
| `meta_alfabetizacao_brasil` | Metas nacionais de alfabetização (2024–2030) | 3 |
| `meta_alfabetizacao_uf` | Metas de alfabetização por UF (2024–2030) | 81 |
| `meta_alfabetizacao_municipio` | Metas de alfabetização por Município (2024–2030) | 10.704 |
| `dicionario` | Tabela auxiliar — traduz códigos categóricos usados nas demais tabelas | — |

---

## 2. Schema Detalhado por Tabela

### 2.1 `uf`
| Coluna | Tipo | Observação |
|---|---|---|
| `ano` | INT64 | 2023, 2024 |
| `sigla_uf` | STRING | **Apenas 25 UFs presentes — DF e RR ausentes nesta tabela específica** (ver seção 4) |
| `serie` | STRING | Código, único valor observado: `2` |
| `rede` | STRING | Código — ver dicionário específico desta tabela (seção 3.1) |
| `taxa_alfabetizacao` | FLOAT64 | 0–100, sem nulos |
| `media_portugues` | FLOAT64 | Escala Saeb, sem nulos |
| `proporcao_aluno_nivel_0` a `_8` | FLOAT64 | Majoritariamente nulas (característica real da fonte, não erro) |

### 2.2 `municipio`
| Coluna | Tipo | Observação |
|---|---|---|
| `ano` | INT64 | 2023, 2024 |
| `id_municipio` | STRING | Código IBGE de 7 dígitos — requer join com `basedosdados.br_bd_diretorios_brasil.municipio` para obter o nome |
| `serie` | STRING | Mesmo padrão de `uf` |
| `rede` | STRING | Código — ver dicionário específico desta tabela |
| `taxa_alfabetizacao` | FLOAT64 | |
| `media_portugues` | FLOAT64 | |
| `proporcao_aluno_nivel_0` a `_8` | FLOAT64 | Mesma estrutura de `uf`, verificar padrão de nulos antes da Silver |

### 2.3 `alunos` (microdados individuais)
| Coluna | Tipo | Observação |
|---|---|---|
| `ano` | INT64 | |
| `id_municipio` | STRING | Código IBGE |
| `id_escola` | STRING | Identificador da escola |
| `id_aluno` | STRING | Identificador do aluno |
| `caderno` | STRING | Identificador do caderno de prova aplicado |
| `serie` | STRING | |
| `rede` | STRING | Código — **dicionário diferente do usado em `uf`/`municipio`** (ver seção 3.2) |
| `presenca` | STRING | Código binário — ver seção 3.2 |
| `preenchimento_caderno` | STRING | Código binário — ver seção 3.2 |
| `alfabetizado` | STRING | Código binário — ver seção 3.2 |
| `proficiencia` | FLOAT64 | Nota na escala Saeb |
| `peso_aluno` | FLOAT64 | **Peso amostral** — usar em qualquer agregação estatística (média ponderada, não simples) |

⚠️ **Nota de arquitetura**: tabela com ~3,87 milhões de linhas. Decisão adotada: ingestão completa via `EXTRACT DATA` do BigQuery direto para o GCS (Bronze), sem download local nem recorte por ano/UF, já que o volume é irrisório para os limites do BigQuery e evita justificar recortes artificiais no README.

### 2.4 `meta_alfabetizacao_brasil`
| Coluna | Tipo | Observação |
|---|---|---|
| `ano` | INT64 | |
| `rede` | STRING | |
| `taxa_alfabetizacao` | FLOAT64 | |
| `meta_alfabetizacao_2024` a `_2030` | FLOAT64 | Metas anuais plurianuais |
| `percentual_participacao` | FLOAT64 | |

### 2.5 `meta_alfabetizacao_uf`
| Coluna | Tipo | Observação |
|---|---|---|
| `ano` | INT64 | |
| `sigla_uf` | STRING | **Todas as 27 UFs presentes**, incluindo DF e RR (diferente da tabela `uf`) |
| `rede` | STRING | |
| `taxa_alfabetizacao` | FLOAT64 | |
| `meta_alfabetizacao_2024` a `_2030` | FLOAT64 | |
| `percentual_participacao` | FLOAT64 | |

### 2.6 `meta_alfabetizacao_municipio`
| Coluna | Tipo | Observação |
|---|---|---|
| `ano` | INT64 | |
| `id_municipio` | STRING | |
| `rede` | STRING | |
| `taxa_alfabetizacao` | FLOAT64 | |
| `meta_alfabetizacao_2024` a `_2030` | FLOAT64 | |
| `nivel_alfabetizacao` | INT64 | **Campo exclusivo desta tabela** — ver seção 3.3 |
| `percentual_participacao` | FLOAT64 | |

---

## 3. Dicionários de Campos Categóricos

### 3.1 Campo `rede` — tabelas `uf` e `municipio` (valores agregados)
| Código | Descrição |
|---|---|
| 0 | Total (Federal, Estadual, Municipal e Privada) |
| 2 | Estadual |
| 3 | Municipal |
| 5 | Pública (Estadual e Municipal) |

> ⚠️ Nestas tabelas, os códigos 1 (Federal), 4 (Privada) e 6 (Pública Federal+Estadual+Municipal) **não aparecem** — característica real da fonte, provavelmente porque a avaliação é majoritariamente de rede pública.

### 3.2 Campo `rede` — tabela `alunos` (valores individuais, sem agregação)
| Código | Descrição |
|---|---|
| 1 | Federal |
| 2 | Estadual |
| 3 | Municipal |
| 4 | Privada |

> ⚠️ **Importante**: o dicionário de `rede` é diferente por tabela (`id_tabela` na tabela `dicionario`). Não aplicar o mesmo mapeamento entre `uf`/`municipio` e `alunos`.

**Demais campos categóricos da tabela `alunos`:**

| Campo | Código 0 | Código 1 |
|---|---|---|
| `alfabetizado` | Não | Sim |
| `presenca` | Ausente | Presente |
| `preenchimento_caderno` | Prova não preenchida | Prova preenchida |

**Campo `serie`** (todas as tabelas): único valor observado — `2` = "2° ano do Ensino Fundamental".

### 3.3 Campo `nivel_alfabetizacao` — exclusivo de `meta_alfabetizacao_municipio`
Não possui entrada na tabela `dicionario` (não é um código de tradução direta). Confirmado via documentação oficial do Inep: as metas do Compromisso Nacional Criança Alfabetizada foram divididas em **5 níveis de desempenho**, sendo o **nível 5 = acima de 80%** de crianças alfabetizadas (meta final prevista para 2030).

Distribuição observada (2023–2024, `meta_alfabetizacao_municipio`):

| Nível | Ocorrências |
|---|---|
| *(nulo)* | 120 |
| 0 | 1.605 |
| 1 | 1.429 |
| 2 | 1.783 |
| 3 | 1.898 |
| 4 | 1.810 |
| 5 | 2.059 |
| **Total** | **10.704** |

Os 120 registros nulos provavelmente correspondem a municípios sem participação mínima suficiente para classificação (consistente com critérios de participação mínima mencionados pelo Inep para divulgação de resultados municipais). Os limites numéricos exatos de cada faixa (ex: nível 0 = 0–X%) não estão confirmados — apenas o nível 5 tem limite documentado oficialmente (>80%).

---

## 4. Observações Sobre Cobertura Geográfica

- A tabela **`uf`** contém apenas **25 das 27 UFs** — **DF e RR estão ausentes**. Essa ausência é da própria fonte (confirmado via consulta direta ao BigQuery, não é artefato de exportação).
- A tabela **`meta_alfabetizacao_uf`** contém **todas as 27 UFs**, incluindo DF e RR.
- **Conclusão**: a ausência de DF/RR é específica dos **resultados de avaliação** (tabela `uf`), não do dataset como um todo. Metas são definidas para todos os entes federativos independentemente de terem aplicado a avaliação no ciclo.

---

## 5. Tabelas Auxiliares de Apoio (fora do dataset principal)

| Tabela | Uso |
|---|---|
| `basedosdados.br_bd_diretorios_brasil.uf` | Join para obter nome por extenso da UF a partir da sigla |
| `basedosdados.br_bd_diretorios_brasil.municipio` | Join para obter nome do município a partir do `id_municipio` (IBGE) |

---

## 6. Pendências para Investigação Futura (não bloqueantes)

- Limites numéricos exatos de cada faixa de `nivel_alfabetizacao` (0 a 4) — poderia ser inferido cruzando com `taxa_alfabetizacao`, mas não é crítico para o modelo de dados.
- Confirmar se o padrão de nulos em `proporcao_aluno_nivel_*` na tabela `municipio` se repete como na tabela `uf`.
