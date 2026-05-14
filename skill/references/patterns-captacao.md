# Padrões de Fluxo de Captação — ManyChat Triwer

Baseado na análise de 6 fluxos de captação + 1 subfluxo de pitch reutilizável (2022–2025)
+ análise de 9 fluxos de isca com dados de acionamento e taxa de botão (2022–2025).

---

## Framework Base — Fluxo de Captação

```
BLOCO 1 — Saudação (private_reply)
BLOCO 2 — Ações (set_optin + tags + custom fields + planilha [+ Meta Ads opcional])
BLOCO 3 — Condição: já está inscrito/na lista?
  └── SIM → lembrete de data/grupo + encerra
  └── NÃO → sequência principal
BLOCO 4 — Aquecimento (dor do problema OU história de fracasso OU contraste)
BLOCO 5 — Conteúdo educativo com permissão entre blocos
BLOCO 6 — Cliffhanger ou transição para pitch ("antes de encerrar...")
BLOCO 7 — Permissão para fazer o pitch ("Posso te contar sobre uma oportunidade?")
BLOCO 8 — goto → subfluxo de pitch (se existir) OU pitch inline
BLOCO 9 — CTA:
  ├── SIM → inscrição/link + tag + planilha + confirmação
  ├── DÚVIDA → coleta + notify_admin + open_conversation
  └── NÃO → fallback empático ou dramático
```

---

## Diferenças entre Captação e Venda

| Elemento | Venda | Captação |
|---|---|---|
| CTA final | Link de compra | Inscrição/lista/grupo VIP/link de venda (híbrido) |
| Smart Delay | Sempre (20–30 min) | Raramente — fluxo é mais linear |
| Prova social | Resultados financeiros | Desejo gerado, transformação, volume de inscritos |
| Âncora de preço | Produto vs bônus vs mentoria | Mentoria vs produto (quando ticket alto) |
| Segmentação | Aluno vs não-aluno | Inscrito vs não inscrito + nível (opcional) |
| Conteúdo | Aquecimento curto + prova | Educativo denso — ferramenta, passo a passo, checklist |
| Subfluxo | Raramente | Frequente — pitch compartilhado entre múltiplos posts |

---

## Padrões Confirmados

### 1. Promessa específica na saudação = CTR mais alto

| Saudação | CTR |
|---|---|
| "estratégia responsável por 70% das vendas para você copiar" | 92% 🔥 |
| "checklist da Chefia para direcionar comunicação para o produto" | 90% 🔥 |
| "passo a passo para atrair pessoas prontas para comprar" | 79% |
| "3 Pilares de antecipação" | 77% |
| "como a Chefia cria narrativas envolventes" | 70% ⚠️ |

**Regra:** resultado específico + número > conceito abstrato.

**Botões que funcionam:**
- `"👉🏻Continuar👈🏻"` — simples e direcional
- `"👉🏻Manda Sun👈🏻"` — pessoal, identidade do Sun
- `"Liberar Acesso 🔐"` — sugere exclusividade
- Evitar: `"Fabrica🔐"` e similares sem contexto

---

### 2. Coerência temática > segmentação

Fluxo linear de 2022 com promessa específica superou fluxos segmentados de 2025.
Segmentação ajuda quando o produto resolve problemas diferentes para perfis diferentes.
Quando a dor é única e clara, fluxo linear pode performar igual ou melhor.

---

### 3. CRM obrigatório

Todo fluxo de captação registra no mínimo:
- `set_instagram_optin`
- `ig_username`
- Tag do fluxo/campanha
- Custom field de origem
- Planilha Google Sheets (update_row por user_id)

Avançado (adicionar quando disponível):
- `custom_audience_user` → Meta Ads
- `fire_custom_event` → rastreamento de conversão
- Custom field de produto de interesse (multi-produto)

---

### 4. Tipos de conteúdo educativo

**Passo a passo numerado** → melhor consistência de CTRs (95–98%)
- Passos acionáveis, não conceituais
- Permissão entre cada passo: "Posso falar o próximo passo?"

**Checklist com cliffhanger** → melhor para gerar desejo pelo produto
- Entrega 2 blocos, interrompe: "Os demais só alunos do [produto] terão acesso"

**Demonstração ao vivo da ferramenta** → maior profundidade, mais qualificado
- Aplica o método do produto ao próprio lançamento

**História de fracasso + virada** → aquecimento por identificação
- Fracasso → diagnóstico → criação da ferramenta → resultado com número

**Quiz com feedback personalizado** → engajamento no meio do funil
- 3 opções, cada uma com retorno diferente, todas convergem para o mesmo bloco

---

### 5. Fallbacks de captação

**Empático:** "Tudo bem, quando estiver pronto é só falar" + próximo conteúdo

**Dramático-humorístico (funciona melhor em captação):**
- "coração partido 💔 onde eu falhei?"
- "Tenho um caderninho de Rebeldes e vou anotar teu nome nele"
- "tu gosta de sofrer viu / me dá mais uma chance que vou me esforçar 3x mais"

---

### 6. Subfluxo de pitch reutilizável

Usar quando múltiplos posts levam para o mesmo produto/evento.

**Estrutura obrigatória:**
```
BLOCO 1 — Condição: já tem tag de inscrito?
  └── SIM → encerra silenciosamente (sem mensagem)
  └── NÃO → continua

BLOCO 2 — Transição contextual (OBRIGATÓRIO)
  "Agora que você X, to liberado pra te contar Y, posso?"
  ← Sem isso o Sun parece responder uma pergunta aleatória

BLOCO 3 — Diferenciação ("não é como as iguais")
BLOCO 4 — Qualificação de interesse (quiz → salva em custom field)
BLOCO 5 — CTA com permissão
BLOCO 6 — Fallback com lore do Sun

AÇÕES na confirmação: add_tag + set_custom_field status + planilha
```

---

### 7. Tipos de isca e como estruturar o fluxo para cada uma

A isca define a arquitetura do BLOCO 5 (conteúdo). Cada tipo tem regras específicas.
A skill `cta-triwer` define qual isca usar — aqui está como construir o fluxo para cada tipo.

**Tipo 1 — Isca de Acesso (texto direto no MC)**
Entrega: script, checklist ou lista como texto na segunda mensagem após o botão.
```
Saudação → botão
  ↓
Entrega imediata na msg 2 (texto estruturado)
  ↓
Aquecimento por identificação (pergunta de dor com botão)
  ↓
Prova social (depoimento ou screenshot)
  ↓
Transição natural para produto
```
Taxa de botão esperada: 83–91%. Funciona quando a isca é específica e pessoal ("o mesmo script que eu uso").

**Tipo 2 — Isca Episódica (conteúdo em partes)**
Entrega: conteúdo dividido em 2-4 partes, cada uma exigindo clique para avançar.
```
Saudação → botão
  ↓
Introdução + antecipa bônus no final
  ↓
Parte 1 → pergunta de identificação → botão para Parte 2
  ↓
Parte 2 → pergunta de identificação → botão para Parte 3
  ↓
[Parte 3 opcional]
  ↓
Transição para produto
```
Taxa de botão esperada: 59–81% na entrada, 91%+ de retenção dentro. Filtro natural — quem chega até o final está comprometido.
**Regra:** anunciar o bônus antes de começar. Quem entra quer tanto o conteúdo quanto o bônus prometido.

**Tipo 3 — Isca com Link Externo (vídeo-aula ou página)**
Entrega: aperitivo em imagem ou texto + link para página/vídeo externo.
```
Saudação → botão
  ↓
Aperitivo (imagem do framework ou resumo em texto)
  ↓
"A Chefia fez um vídeo de X min explicando cada passo — liberou de graça por 24h"
Botão: "✅ Acessar a aula" → link externo com UTM
  ↓
Smart Delay: 30–45 min
  ↓
Remarketing ("Já acessou o conteúdo?")
```
Taxa de clique no link: 84% de quem chega até ele. Usar urgência real ("disponível por 24h") para aumentar clique imediato.

**Tipo 4 — Isca de Diagnóstico (quiz)**
Entrega: diagnóstico personalizado baseado nas respostas do usuário.
```
Saudação → botão
  ↓
Pergunta 1 com botões (salvar em custom field + planilha)
  ↓
Pergunta 2 com botões
  ↓
Pergunta 3 com botões [máx. 5 perguntas no total]
  ↓
Resultado personalizado baseado nas respostas (condicional por campo)
  ↓
"O próximo passo natural para quem está no seu momento é..."
  ↓
Transição para produto
```
Taxa de botão: 61% na entrada — menor que outros tipos. Mas quem entra tem retenção quase total e qualidade de lead superior.
**Regra:** cada resposta deve salvar em campo customizado. Os dados coletados servem para segmentação futura.

**Tipo 5 — Isca Experiencial (o fluxo demonstra o que ensina)**
Entrega: o próprio fluxo aplica o método enquanto o explica. A revelação acontece no final.
```
Saudação → botão
  ↓
O fluxo APLICA etapa 1 do método (sem nomear)
  ↓
O fluxo APLICA etapa 2 do método
  ↓
O fluxo APLICA etapa 3 do método
  ↓
REVELAÇÃO: "as perguntas que eu fiz pra você eram exatamente a estratégia"
  ↓
"Quer aprender a montar isso para a sua audiência?"
  ↓
Transição para produto
```
É o tipo mais complexo. Requer planejamento editorial antes de escrever uma linha. Impacto de autoridade máximo quando executado bem.

---

### 8. Extra pós-entrega — padrão obrigatório, não opcional

Em todos os 9 fluxos analisados, a isca não foi o ponto final — foi a porta de entrada. O fluxo sempre entregou mais do que foi prometido no post.

**Sequência obrigatória após entregar qualquer isca:**

```
1. Entrega imediata — nunca demorar
2. Aquecimento por identificação — "você também sente isso?" com botão
3. Prova social — depoimento ou screenshot de resultado real
4. Transição natural — "foi assim que ela foi de X para Y"
5. Oferta — como "próximo passo" de quem recebeu a isca
6. Saída elegante — para quem recusou: sem insistência
```

**O que não fazer:**
- ❌ Entregar a isca e encerrar o fluxo
- ❌ Ir direto para o produto sem aquecimento pós-entrega
- ❌ Prova social genérica — sempre específica (nome ou contexto + número ou resultado)

---

### 9. Mecanismos de retenção — easter egg e lembrete

**Easter egg (recompensa oculta por persistência)**
Inserir no final de fluxos episódicos ou de diagnóstico para quem completou tudo:
```
Smart Delay: 0s após último bloco de conteúdo
  ↓
"Uhuuu! Pois aqui está o seu link easter egg exclusivo com o DESCONTÃO 🥳"
Botão: link com desconto especial → tag: resgatou_easter_egg
```
Não anunciar no início. O easter egg só funciona porque não foi prometido.
Dado de referência: fluxo TRM — quem chegou até o final recebeu sem saber que existia.

**Lembrete voluntário (reativação de quem não converteu)**
Inserir quando a pessoa recusou a oferta mas não saiu do fluxo:
```
"Quer que eu te lembre amanhã sobre [produto/evento]?"
Botão SIM → Smart Delay: 20–24h → mensagem de lembrete com link
Botão NÃO → saída elegante ("Tudo bem, qualquer coisa é só me chamar")
```
Dado de referência: fluxo SDS — 73% dos que recusaram disseram sim para o lembrete.
Isso cria uma segunda janela de conversão sem pressão no primeiro contato.

---

### 10. Fallbacks de captação

**Empático:** "Tudo bem, quando estiver pronto é só falar" + próximo conteúdo

**Dramático-humorístico (funciona melhor em captação):**
- "coração partido 💔 onde eu falhei?"
- "Tenho um caderninho de Rebeldes e vou anotar teu nome nele"
- "tu gosta de sofrer viu / me dá mais uma chance que vou me esforçar 3x mais"

---

## O que NÃO fazer

- ❌ Botão de saudação genérico sem contexto do que a pessoa vai receber
- ❌ Subfluxo sem bloco de transição contextual
- ❌ Conteúdo conceitual/abstrato sem aplicação prática
- ❌ Pitch sem condição de deduplicação
- ❌ CTA sem registrar origem (impossível rastrear qual post converteu)
- ❌ Keyword genérica em todos os posts (reduz qualificação)
- ❌ Encerrar o fluxo após entregar a isca sem aquecimento pós-entrega
- ❌ Anunciar o easter egg antes do final — elimina o efeito surpresa

---

## Métricas de Referência

| Bloco | Esperado | Alerta |
|---|---|---|
| Saudação | 75–92% | < 70% |
| Aquecimento / conteúdo bloco 1 | 85–98% | < 80% |
| Conteúdo intermediário | 83–98% | < 75% |
| Transição para pitch | 82–95% | < 75% |
| CTA de inscrição | 80–98% | < 70% |

**Referência por tipo de isca (taxa de botão na saudação):**

| Tipo de isca | Taxa esperada | Observação |
|---|---|---|
| Acesso (texto direto) | 83–91% | Quanto mais específica a promessa, maior a taxa |
| Episódica (partes) | 59–81% | Menor entrada, maior retenção |
| Link externo | 75–84% | Taxa de clique no link é o indicador principal |
| Diagnóstico (quiz) | 61% | Menor taxa, maior qualidade de lead |
| Experiencial | 79–83% | Depende muito da narrativa do post |

---

## Fluxos Analisados

| Fluxo | Ano | CTR saudação | Destaque |
|---|---|---|---|
| PLD — 3 Pilares | 2025 | 77% | Segmentação dupla por nível |
| Crônica AAP | 2025 | 70% | História de fracasso |
| Checklist PPC | 2023 | 90% | Cliffhanger + Meta Ads |
| Produto Paquera ASV | 2024 | 79% | Quiz + âncora R$12k vs R$497 |
| Plano 50K K1S | 2022 | 92% | Passo a passo + promessa com número |
| Era Lançamentos BTN | 2023 | 75% | Meta-demonstração da ferramenta |
| BF23 Inscrição (subfluxo) | 2023 | 47%* | Deduplicação × 25 fluxos |
| OFVL (Script oferta) | 2024 | 86% | Acesso + método pessoal — 374 entradas |
| A007 (7 Pilares) | 2024 | 79% | Episódico — 124 entradas |
| F7D (Mapa 7 dias) | 2024 | 79% | Link externo + gatilho desbloqueado — 200 entradas |
| DESEJO (Funil) | 2024 | 75% | Acesso + resultado com faixa — 176 entradas |
| Quiz SI | 2024 | 61% | Diagnóstico — 111 entradas, retenção total |
| GDP (3 Níveis) | 2024 | 59% | Episódico + metáfora atravessa o fluxo — 176 entradas |
| 1BF (Checklist BF) | 2023 | 83% | Experiencial — fluxo aplica o método — 116 entradas |
| TRM (Trampolim) | 2024 | 81% | Acesso + easter egg — 245 entradas |
| Lista SDS | 2022 | 91% | Objeção quebrada no post + código como frase de intenção — 715 entradas |

*CTR baixo por ausência de bloco de transição — confirmado em nota interna do criador.
