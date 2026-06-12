---
name: manychat-flow-writer
description: >
  Especialista em criar fluxos de automação ManyChat para Instagram no estilo e padrões do Triwer.
  Use sempre que precisar criar, adaptar ou revisar um fluxo ManyChat — seja de venda, captação,
  remarketing ou qualificação. Entrega em dois formatos: roteiro de mensagens (para montar manualmente)
  ou JSON pronto para importar via extensão Chrome. Baseado na análise de fluxos reais que geraram
  vendas e captações rastreadas. Acionar para: "cria um fluxo de venda", "monta um fluxo de captação",
  "escreve as mensagens do ManyChat", "gera o JSON do fluxo", "como seria o fluxo para esse post".
compatibility: claude.ai, Claude Desktop, Cowork, Claude Code
---

# manychat-flow-writer
**Versão:** 2.1.0 | Histórico completo em `references/user-profile.md`

Esta skill cria fluxos ManyChat com a voz do usuário, a lógica de funil validada em fluxos reais
e as regras técnicas para geração de JSON importável.

## Módulos de referência — ler SOMENTE quando necessário

| Módulo | Ler quando... |
|---|---|
| `references/user-profile.md` | Primeira interação (checar onboarding) OU escrever mensagens (checar personalidade) |
| `references/user-memory.md` | Usuário mencionar IDs/tags/subfluxos OU for gerar JSON |
| `references/manychat-mcp.md` | MCP disponível OU usuário perguntar sobre instalação OU for gerar JSON com IDs |
| `references/sun-personality.md` | Usuário é o Triwer/Sun OU não há personalidade configurada no user-profile |
| `references/patterns-venda.md` | O objetivo for venda direta |
| `references/patterns-captacao.md` | O objetivo for captação, lista, grupo VIP, evento — ou quando precisar definir a estrutura do fluxo por tipo de isca |
| `references/copy-rules.md` | For escrever mensagens (após definir o framework) |
| `references/json-format.md` | O output solicitado for JSON |

**Ordem de leitura — nunca leia tudo de uma vez:**
1. `user-profile.md` → sempre na primeira mensagem de cada conversa (checar onboarding + personalidade)
2. `user-memory.md` → só ao gerar JSON ou quando IDs/tags são mencionados
3. `manychat-mcp.md` → só ao gerar JSON (verificar se MCP está disponível para buscar IDs)
4. `patterns-venda.md` OU `patterns-captacao.md` → só ao criar o fluxo
5. `sun-personality.md` → só se o interlocutor for o Sun (Triwer) ou sem personalidade configurada
6. `copy-rules.md` → ao escrever as mensagens
7. `json-format.md` → só se output for JSON

**Se o output for roteiro (não JSON):** não leia json-format.md, user-memory.md nem manychat-mcp.md.

---

## Início de Conversa — Verificação Obrigatória

**Sempre na primeira mensagem de cada conversa**, ler `references/user-profile.md` e verificar:

```
onboarding_concluido: false → executar onboarding completo (ver user-profile.md)
onboarding_concluido: true  → seguir normalmente com a solicitação do usuário
```

Se onboarding concluído: usar personalidade salva ao escrever mensagens.
Se `skill_personalidade_path` preenchido: ler o arquivo referenciado ao escrever copy.
Se apenas fallback salvo: usar os dados da seção `personalidade_fallback`.

---

## Memória — Atualização Proativa

Sempre que o usuário passar qualquer dado abaixo, ler o arquivo correspondente, atualizar e confirmar:
> "Salvei [dado] na memória. Vou usar automaticamente nos próximos fluxos."

| Dado | Arquivo |
|---|---|
| IDs de custom fields, tags, namespaces, planilha, Meta, webhook | `user-memory.md` |
| Personalidade / documento estilo-forge / preferências de tom | `user-profile.md` |

Ao gerar JSON: ler `user-memory.md`, usar os dados salvos e confirmar antes de escrever:
> "Vou usar os campos [X, Y, Z] da sua memória. Confirma?"

Campos ausentes na memória: perguntar → salvar → seguir.

---

## Etapa 0 — Verificar MCP (só ao gerar JSON)

Antes de solicitar IDs ao usuário, verificar se o ManyChat MCP está disponível:

**MCP disponível:**
1. `manychat_get_custom_fields` → buscar e salvar IDs de UTMs, lead_score, ig_username, nome, origem
2. `manychat_get_tags` → buscar e salvar IDs de tags recorrentes
3. Se campo/tag necessário não existir → sugerir nome (seguir padrão em manychat-mcp.md) → perguntar se pode criar → `manychat_create_custom_field` ou `manychat_create_tag`
4. Confirmar IDs encontrados com o usuário antes de gerar o JSON
5. Salvar em `user-memory.md`

**MCP indisponível:**
- Verificar `user-memory.md` primeiro — dados já salvos de sessões anteriores
- O que ainda faltar: perguntar ao usuário ou usar placeholders SUBSTITUIR_ID_XXX
- Se usuário não tiver MCP instalado e for relevante mencionar: exibir instruções de instalação do módulo manychat-mcp.md

---

## Etapa 1 — Coleta de Informações

Perguntar antes de criar qualquer fluxo:

**1. Objetivo**
- Venda direta / Captação (lista, grupo, evento) / Híbrido (capta e já vende)

**2. O produto ou oferta**
- Nome, preço, principais benefícios (2–3), bônus com âncora de preço separado

**3. O post que vai gerar o trigger**
- Tema do post, dor abordada, keyword para comentar

**4. Contexto**
- Tag de aluno/inscrito existente
- Segmentação necessária?
- Precisa coletar dado (email, produto de interesse)?
- Faz parte de campanha com múltiplos posts? → sugerir subfluxo de pitch

**5. Tracking (obrigatório)**
- utm_campaign: nome da campanha (ex: "Workshop CP - T02")
- utm_medium: de onde vem a interação — feed / stories / live / keyword
- utm_content: título do post (fluxos de conteúdo) ou nome do fluxo (fluxos genéricos)
- IDs dos custom fields de UTMs e lead score: o usuário já sabe? Se sim, coleta antes de gerar o JSON. Se não, usar placeholders SUBSTITUIR_ID_XXX

**6. Integrações opcionais (perguntar uma a uma)**
- Quer salvar dados em Google Planilhas? (se sim: pedir ID da planilha e nome da aba)
- Tem público personalizado no Meta Ads para adicionar os leads? (se sim: pedir ad_account_id e custom_audience_id)
- Quer enviar dados para um CRM ou plataforma via webhook? (se sim: pedir URL, headers e estrutura do payload)

**5. Looping de engajamento (opcional)**
- Tem algum conteúdo relacionado para convidar no final do fluxo?
- Pode ser: link de post do feed, link direto de destaque, link de aula
- Se não tiver: não insere smart delay nem bloco de looping
- Se tiver: insere smart delay após encerramento + bloco de convite pro conteúdo

**6. Output desejado**
- Roteiro de mensagens (montar manualmente)
- JSON para importar via extensão Chrome

---

## Etapa 2 — Verificar Coerência Temática e Apresentação da Isca

Antes de criar, confirmar os dois pontos abaixo. Os dois têm impacto direto no volume de acionamentos e na taxa de botão.

### 2.1 — Coerência temática

> O tema do post que vai gerar o comentário é o mesmo tema que o fluxo vai trabalhar?

Se não houver coerência clara, alertar e sugerir ajuste. Coerência temática é o principal fator de performance — supera segmentação e arquitetura complexa.

### 2.2 — Como a isca está sendo apresentada no post

O volume de acionamentos não é decidido pela isca — é decidido pelo que acontece no post antes do direct. Verificar com o usuário se o post segue estes 4 pontos:

**1. O post mostrou o problema antes de nomear a isca?**
A narrativa deve criar identificação com a dor ou situação antes de oferecer qualquer recurso. Se o post já começa com "comenta X para receber Y", o contexto emocional não foi construído.

**2. A isca foi apresentada como consequência, não como produto?**
Frases que funcionam: "decidi liberar o mesmo [recurso] que eu utilizo", "esse é poderoso demais para caber aqui", "liberado 🔓 meta superada".
Frases que convertem menos: "comenta para receber mais", "acessa o link da bio".

**3. A promessa tem especificidade ou número?**
"O mesmo script que eu uso para gerar desejo em minutos" > "uma ferramenta poderosa".
"Lista de formas de se conectar sem vídeo" > "dicas de conteúdo".

**4. A objeção principal do público foi quebrada antes do código?**
O post que gerou a maior taxa de botão de todos os analisados (91%, 715 entradas) tinha slides dizendo explicitamente "não precisa de mega rotina nem de vídeo" antes de apresentar o código. Quem chegou ao direct já tinha a objeção removida.

Se algum desses pontos estiver ausente: alertar e sugerir como ajustar o post antes de criar o fluxo. O fluxo mais bem estruturado não compensa um post que não preparou o terreno.

---

## Etapa 3 — Criar o Fluxo

→ Leia `references/patterns-venda.md` ou `references/patterns-captacao.md` conforme o objetivo.
→ Leia `references/sun-personality.md` e `references/copy-rules.md` antes de escrever as mensagens.

### Framework — Fluxo de VENDA

```
BLOCO 1 — Saudação (private_reply) — SEM delay como primeiro message
BLOCO 2 — Ações #3: set_optin + UTMs + lead score +1 + ig_username
  [+ Google Sheets se solicitado] [+ público personalizado Meta se solicitado]
BLOCO 3 — Condição de origem (só em campanhas com múltiplos posts)
  └── IS_UNKNOWN → Ações pontuais: salva origem + update planilha de origem
  └── JÁ PREENCHIDO → pula
BLOCO 4 — Goto: subfluxo de apelido
  [opcional: webhook CRM se solicitado]
BLOCO 5 — Conteúdo / aquecimento / entrega de valor
BLOCO 6 — Permissão para revelar ("Posso te dizer?")
BLOCO 7 — Sun como demonstração do produto ao vivo
BLOCO 8 — Prova social (depoimentos/resultados)
BLOCO 9 — Condição: já é aluno? ← AQUI, antes do pitch
  └── SIM → elogio + próximo conteúdo (nunca pitch)
  └── NÃO → pitch
BLOCO 10 — Pitch (benefícios + âncora de preço + urgência)
BLOCO 11 — CTA ("Posso liberar o link?")
  ├── SIM → [action_group: tag clicou + lead score +20] → [bloco entrega do link]
  ├── DÚVIDA → [bloco mensagem dúvida] → [action_group: notify_admin email+telegram + open_conversation]
  └── NÃO → fallback dramático-humorístico
BLOCO 12 — Entrega do link
  → botão URL de compra
  → [Smart Delay 20–60min] → Remarketing ("Já garantiu sua vaga?")
BLOCO 13 — Looping de engajamento (só se usuário fornecer conteúdo complementar)
```

### Framework — Fluxo de CAPTAÇÃO

```
BLOCO 1 — Saudação (private_reply) — SEM delay como primeiro message
  → Promessa específica com resultado ou número
  → Botão: "👉🏻Continuar👈🏻" / "👉🏻Manda Sun👈🏻" / "Liberar Acesso 🔐"
BLOCO 2 — Ações #3: set_optin + UTMs + lead score +1 + ig_username
  [+ Google Sheets se solicitado] [+ público personalizado Meta se solicitado]
BLOCO 3 — Condição de origem (só em campanhas com múltiplos posts)
  └── IS_UNKNOWN → Ações pontuais: salva origem + update planilha de origem
  └── JÁ PREENCHIDO → pula
BLOCO 4 — Goto: subfluxo de apelido
  [opcional: webhook CRM se solicitado]
BLOCO 5 — Conteúdo educativo
  Escolher o mais coerente com o post:
  • Passo a passo numerado (95–98% CTR)
  • Checklist com cliffhanger
  • História de fracasso + virada com número
  • Quiz com feedback personalizado
  • Demonstração ao vivo da ferramenta
BLOCO 6 — Permissão entre blocos de conteúdo
BLOCO 7 — Condição: já está inscrito? ← AQUI, antes do pitch
  └── SIM → lembrete de data/grupo + encerra
  └── NÃO → pitch
BLOCO 8 — Transição para pitch
BLOCO 9 — goto → subfluxo de pitch OU pitch inline
BLOCO 10 — CTA
  ├── SIM → [action_group: tag + lead score +20 + planilha] → confirmação
  ├── DÚVIDA → [bloco mensagem dúvida] → [action_group: notify_admin email+telegram + open_conversation]
  └── NÃO → fallback dramático-humorístico
BLOCO 11 — Looping de engajamento (só se usuário fornecer conteúdo complementar)
```

### Framework — Subfluxo de pitch reutilizável

Usar quando múltiplos posts levam ao mesmo produto/evento.

```
BLOCO 1 — Condição: já tem tag de inscrito?
  └── SIM → encerra silenciosamente (sem mensagem)
  └── NÃO → continua
BLOCO 2 — Transição contextual (OBRIGATÓRIO)
  "Agora que você X, to liberado pra te contar Y, posso?"
  ← Sem isso o Sun parece responder uma pergunta aleatória
BLOCO 3 — Diferenciação ("não é como as iguais")
BLOCO 4 — Qualificação de interesse (quiz salvo em custom field + planilha)
BLOCO 5 — CTA com permissão
BLOCO 6 — Fallback com lore do Sun
AÇÕES confirmação: add_tag inscrito + set_custom_field status + planilha
```

---

## Etapa 4 — Formato do Output

→ Se output for JSON: leia `references/json-format.md` agora.

### Output 1 — Roteiro de Mensagens

```
BLOCO 1 — Saudação
Tipo: Mensagem Instagram (private_reply)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"Oeee Estrategista! 🤩🤩🤩 Aqui é o Sun..."

[Botão] → "👉🏻 Continuar👈🏻" → Bloco 2

BLOCO 2 — Ações
Tipo: Ação
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- set_instagram_optin
- add_tag: [nome da tag]
→ Próximo: Bloco 3
...
```

### Output 2 — JSON para importar

JSON completo no formato patchDraft do ManyChat conforme `references/json-format.md`.

**Regras obrigatórias:**
- Todos os `_oid` são UUIDs v4 únicos
- `ns` e todos os `namespace` usam `SUBSTITUIR_PELO_NS_DO_FLUXO_ABERTO`
- Botões `content` têm `_content_oid` apontando para o `_oid` do bloco destino
- Coordinates: ~1400px de espaçamento horizontal, ~800px vertical por ramificação
- Captura de resposta usa mensagem interna `type: "question"` dentro de bloco `instagram`
- Coleta de e-mail usa `answer_type: "email"` com adapters `save_email_to_system_field` e `set_email_optin`
- Nunca gerar bloco externo `type: "user_input"`
- Antes de entregar, localizar esta skill instalada e executar `scripts/validate-manychat-json.ps1` a partir do diretório dela; corrigir todo `ERROR`

---

## Regras Gerais Inegociáveis

1. **Tom do Sun** — Informal, divertido, consistente do início ao fim
2. **Coerência temática** — O fluxo continua a promessa do post
3. **Permissão antes de revelar** — Sempre pede para clicar, nunca entrega direto
4. **Condição de aluno/inscrito ANTES do pitch** — nunca no início, salvo fluxo 100% pitch
5. **Ações #3 obrigatórias** — UTMs + lead score em todo fluxo
6. **notify_admin** — sempre email + telegram
7. **Fallback de dúvida** — sempre notify_admin + open_conversation
8. **Fallback de não quero** — nunca abandona; dramático-humorístico > empático neutro
9. **Botões com variações** — 2–3 opções para o mesmo destino (simula conversa natural)
10. **Smart delay** — só em remarketing pós-link ou looping de engajamento
11. **Sem delay no primeiro message da saudação** — fluxos de comentário não permitem
12. **Nome do contato** — `{{cuf_8146798}}` em momentos estratégicos, não em toda frase
13. **Subfluxo de apelido** — goto obrigatório em todo fluxo
14. **Subfluxo reutilizável** — sugerir quando houver campanha com múltiplos posts
15. **Coleta de resposta** — sempre `question` dentro de `instagram`; nunca `user_input`
16. **Coleta de e-mail** — salvar automaticamente no campo nativo com os dois adapters obrigatórios
17. **Validação estrutural** — nenhum JSON é entregue sem passar pelo validador

---

## O que NÃO fazer

- ❌ Delay como primeiro message do bloco de saudação
- ❌ Condição de aluno/inscrito no início de fluxo com isca/conteúdo
- ❌ Botão de saudação genérico sem contexto do que a pessoa vai receber
- ❌ notify_admin só por email (sempre email + telegram)
- ❌ Subfluxo sem bloco de transição contextual
- ❌ Conteúdo conceitual/abstrato sem aplicação prática
- ❌ Pitch sem condição de deduplicação
- ❌ CTA sem tracking de origem
- ❌ Bloco de ação apontando para o bloco anterior
- ❌ Mais de 3 botões por bloco ou 2 botões pro mesmo destino quando há 3 caminhos
- ❌ Smart delay entre blocos sequenciais onde a pessoa acabou de clicar
- ❌ Google Sheets / público personalizado / webhook sem confirmação do usuário
- ❌ Bloco externo `type: "user_input"`
- ❌ Pergunta de e-mail como texto comum com orientação para configurar manualmente
- ❌ `action_group` criado apenas para salvar e-mail no campo nativo
- ❌ Entregar JSON com tipos desconhecidos, referências quebradas, UUIDs duplicados ou `removed: true`

---

## Status dos Módulos

| Módulo | Status | Base |
|---|---|---|
| sun-personality.md | ✅ | 5 fluxos de venda + 6 de captação |
| patterns-venda.md | ✅ | 5 fluxos de venda (2022–2024) |
| patterns-captacao.md | ✅ | 6 fluxos + 1 subfluxo (2022–2025) |
| copy-rules.md | ✅ | 11 fluxos analisados |
| json-format.md | ✅ | Extraído dos JSONs reais |
