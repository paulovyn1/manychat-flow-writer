# Padrões de Fluxo de Captação — ManyChat Triwer

Baseado na análise de 6 fluxos de captação + 1 subfluxo de pitch reutilizável (2022–2025).

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

## O que NÃO fazer

- ❌ Botão de saudação genérico sem contexto do que a pessoa vai receber
- ❌ Subfluxo sem bloco de transição contextual
- ❌ Conteúdo conceitual/abstrato sem aplicação prática
- ❌ Pitch sem condição de deduplicação
- ❌ CTA sem registrar origem (impossível rastrear qual post converteu)
- ❌ Keyword genérica em todos os posts (reduz qualificação)

---

## Métricas de Referência

| Bloco | Esperado | Alerta |
|---|---|---|
| Saudação | 75–92% | < 70% |
| Aquecimento / conteúdo bloco 1 | 85–98% | < 80% |
| Conteúdo intermediário | 83–98% | < 75% |
| Transição para pitch | 82–95% | < 75% |
| CTA de inscrição | 80–98% | < 70% |

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

*CTR baixo por ausência de bloco de transição — confirmado em nota interna do criador.
