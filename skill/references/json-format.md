# Regras Técnicas — JSON ManyChat (Instagram)

> Módulo de referência técnico. Ler somente ao gerar JSON.

---

## Estrutura Raiz do JSON

```json
{
  "ns": "SUBSTITUIR_PELO_NS_DO_FLUXO_ABERTO",
  "client_id": "uuid-v4-aleatorio",
  "batch": {
    "contents": [...]
  },
  "coordinates": {
    "uuid-do-bloco-1": { "x": 0, "y": 0 },
    "uuid-do-bloco-2": { "x": 1400, "y": 0 }
  }
}
```

Este é o **envelope de importação** que a skill deve entregar.

Um arquivo exportado pelo ManyChat usa outro envelope:

```text
flow.draft_batch.contents
flow.draft_coordinates
```

Exports servem para confirmar estruturas reais, mas não devem ser reutilizados integralmente. Eles podem conter blocos duplicados, itens com `removed: true`, IDs internos legados e grupos desconectados. Extraia apenas o padrão necessário e gere um grafo limpo no envelope de importação.

---

## Tipos de Blocos

### Tipos permitidos

Tipos externos de bloco:

- `instagram`
- `action_group`
- `multi_condition`
- `smart_delay`
- `goto`

Tipos internos em `instagram.messages`:

- `text`
- `delay`
- `question`

> **PROIBIDO:** nunca gerar bloco externo `type: "user_input"`. O parser do ManyChat rejeita esse tipo com `BatchParserUnknownContentTypeError`. Toda captura de resposta deve ser uma mensagem interna `question` dentro de um bloco externo `instagram`.

### 1. Bloco de Mensagem Instagram (`type: "instagram"`)

```json
{
  "type": "instagram",
  "_oid": "uuid-v4-unico",
  "namespace": "SUBSTITUIR_PELO_NS_DO_FLUXO_ABERTO",
  "caption": "Nome do bloco",
  "content_id": null,
  "removed": false,
  "target": null,
  "private_reply": null,
  "one_time_notify_reason_id": null,
  "$fbMessagingType": "INSIDE_24_HOURS",
  "quick_replies": {
    "buttons": [],
    "settings": { "validation_message": null, "skip_button_caption": null, "limit_failed": null, "timeout": null }
  },
  "messages": [...]
}
```

**⚠️ BLOCO 1 (Saudação) — NUNCA incluir delay como primeiro message:**
Fluxos disparados por comentário em post não permitem delay no primeiro bloco.
O primeiro `message` do bloco de saudação deve ser direto — sem `type: "delay"` antes do texto.

Todos os demais blocos podem ter delays normalmente.

**messages — tipos:**

Pergunta de e-mail:

```json
{
  "type": "instagram",
  "_oid": "uuid-bloco-email",
  "namespace": "SUBSTITUIR_PELO_NS_DO_FLUXO_ABERTO",
  "caption": "Coletar e-mail",
  "content_id": null,
  "removed": false,
  "target": { "_content_oid": "uuid-proximo-bloco" },
  "private_reply": null,
  "one_time_notify_reason_id": null,
  "$fbMessagingType": "INSIDE_24_HOURS",
  "quick_replies": {
    "buttons": [],
    "settings": {
      "validation_message": null,
      "skip_button_caption": null,
      "limit_failed": null,
      "timeout": null
    }
  },
  "messages": [
    {
      "_oid": "uuid-pergunta-email",
      "type": "question",
      "content": {
        "text": "Para isso eu vou precisar do seu e-mail. Manda aqui pra mim 👇🏻"
      },
      "answer_method": "input",
      "answer_type": "email",
      "answer_replies": [],
      "adapters": [
        { "type": "save_email_to_system_field" },
        { "type": "set_email_optin" }
      ],
      "button_caption": "",
      "validation_message": "Insira um endereço de e-mail válido, por exemplo: eu@mail.com",
      "limit_failed": 4,
      "question_answer_timeout": {
        "unit": "hours",
        "value": "12"
      },
      "skip_button_caption": "",
      "telegram_share_phone_button_caption": "",
      "success_target": null,
      "timeout_target": null
    }
  ]
}
```

Regras da coleta de e-mail:

- usar `answer_method: "input"` e `answer_type: "email"`;
- incluir **os dois** adapters: `save_email_to_system_field` e `set_email_optin`;
- usar o `target` do bloco externo para continuar após resposta válida;
- não criar `action_group` apenas para "salvar e-mail e avançar";
- não pedir configuração manual quando o objetivo é salvar no campo nativo `email`;
- `validation_message`, `limit_failed` e `question_answer_timeout` ficam na mensagem `question`, não em `quick_replies.settings`.

Pergunta com respostas predefinidas:

```json
{
  "_oid": "uuid-pergunta",
  "type": "question",
  "content": { "text": "Você quer trocar ou manter esse e-mail?" },
  "answer_method": "reply",
  "answer_type": "text",
  "answer_replies": [
    {
      "_oid": "uuid-resposta-1",
      "type": "answer",
      "caption": "Quero trocar",
      "value": "Quero trocar",
      "emoji": null,
      "image": null,
      "is_smart_link": false
    },
    {
      "_oid": "uuid-resposta-2",
      "type": "answer",
      "caption": "Quero manter esse",
      "value": "Quero manter esse",
      "emoji": null,
      "image": null,
      "is_smart_link": false
    }
  ],
  "adapters": [
    {
      "type": "save_answer_to_custom_field",
      "field_id": 123456
    }
  ],
  "validation_message": "Selecione uma das opções abaixo.",
  "limit_failed": 4,
  "question_answer_timeout": {
    "unit": "hours",
    "value": "23"
  },
  "success_target": null,
  "timeout_target": null
}
```

`answer_replies` são respostas da própria pergunta e não substituem botões `keyboard` de navegação. Só use `save_answer_to_custom_field` quando o ID real do campo for conhecido.

Delay (use em todos os blocos EXCETO o primeiro message do bloco de saudação):
```json
{ "_oid": "uuid", "type": "delay", "time": 3, "show_typing": false, "keyboard": [] }
```

Texto simples:
```json
{ "_oid": "uuid", "type": "text", "content": { "text": "Texto aqui" }, "keyboard": [] }
```

Texto com botão de conteúdo (link para bloco):
```json
{
  "_oid": "uuid", "type": "text", "content": { "text": "Texto" },
  "keyboard": [
    { "_oid": "uuid", "type": "content", "caption": "Texto botão", "_content_oid": "uuid-bloco-destino",
      "is_smart_link": false, "target": null, "webview_size": null, "do_not_track": false }
  ]
}
```

Texto com botão de URL:
```json
{
  "_oid": "uuid", "type": "text", "content": { "text": "Texto" },
  "keyboard": [
    { "_oid": "uuid", "type": "url", "caption": "Texto botão", "url": "https://...",
      "webview_size": null, "do_not_track": false }
  ]
}
```

---

### 2. Bloco de Ação (`type: "action_group"`)

```json
{
  "type": "action_group",
  "_oid": "uuid",
  "namespace": "SUBSTITUIR_PELO_NS_DO_FLUXO_ABERTO",
  "caption": "Nome da ação",
  "content_id": null,
  "removed": false,
  "target": { "_content_oid": "uuid-proximo-bloco" },
  "actions": [...]
}
```

**Tipos de ação:**

| type | Uso | Campos adicionais |
|---|---|---|
| `set_instagram_optin` | Opt-in Instagram | nenhum |
| `add_tag` | Adicionar tag | `tag_id: 0` |
| `open_conversation` | Abrir conversa | nenhum |
| `notify_admin` | Notificar admin | ver abaixo |
| `set_custom_field_value` | Custom field | `field_id`, `operation`, `value` |
| `integration_request` | Sheets/ActiveCampaign/etc | `integration`, `action`, `data` |
| `external_request` | Webhook | `method`, `url`, `headers`, `payload` |
| `custom_audience_ig_user` | Público personalizado Meta | ver abaixo |

---

### 3. Bloco de Condição (`type: "multi_condition"`)

```json
{
  "type": "multi_condition",
  "_oid": "uuid",
  "namespace": "SUBSTITUIR_PELO_NS_DO_FLUXO_ABERTO",
  "caption": "Nome",
  "content_id": null,
  "removed": false,
  "conditions": [
    {
      "_oid": "uuid",
      "filter": {
        "groups": [{ "items": [{ "_oid": "uuid", "field": "tag", "operator": "IS", "type": "tag", "value": 0 }], "operator": "AND" }],
        "operator": "AND"
      },
      "target": { "_content_oid": "uuid-se-verdadeiro" }
    }
  ],
  "default_target": { "_content_oid": "uuid-se-falso" },
  "default_target_oid": "uuid"
}
```

Verificar tag: `{ "field": "tag", "operator": "IS", "type": "tag", "value": 0 }`
Verificar custom field vazio: `{ "field": "cuf_XXXXXXX", "operator": "IS_UNKNOWN", "type": "cuf" }`

---

### 4. Smart Delay (`type: "smart_delay"`)

```json
{
  "type": "smart_delay", "_oid": "uuid",
  "namespace": "SUBSTITUIR_PELO_NS_DO_FLUXO_ABERTO",
  "caption": "Atraso Inteligente", "content_id": null, "removed": false,
  "limit_time": null,
  "shift_time": { "unit": "minutes", "value": "20" },
  "target": { "_content_oid": "uuid-proximo-bloco" },
  "wait_until": null
}
```

Unidades: `"minutes"`, `"hours"`, `"days"`

---

### 5. Goto (`type: "goto"`)

```json
{
  "type": "goto", "_oid": "uuid",
  "namespace": "SUBSTITUIR_PELO_NS_DO_FLUXO_ABERTO",
  "caption": "Nome", "content_id": null, "removed": false,
  "content_target": null,
  "target": { "flow_ns": "namespace-do-subfluxo-destino" }
}
```

---

## Padrões de Ação Detalhados

### notify_admin — obrigatório email + telegram

```json
{
  "_oid": "uuid",
  "type": "notify_admin",
  "all_send_by": ["email", "telegram"],
  "options": { "send_link_to_live_chat": true },
  "send_to": [],
  "text": "🚨 {{ig_username}} está com dúvidas aqui. Corre pra ver e responder!"
}
```

Sempre usar `all_send_by: ["email", "telegram"]` — nunca só email.
O texto deve ser chamativo para o admin agir rápido.

---

### custom_audience_ig_user — opcional (perguntar ao usuário)

```json
{
  "_oid": "uuid",
  "type": "custom_audience_ig_user",
  "action": "add",
  "ad_account_id": "ID_DA_CONTA_DE_ANUNCIOS",
  "custom_audience_id": "ID_DO_PUBLICO_PERSONALIZADO",
  "custom_audience_name": "Nome do Público",
  "user_id": 0
}
```

Só incluir se o usuário confirmar que tem público personalizado configurado no Meta Ads.

---

### integration_request — Google Sheets (opcional)

```json
{
  "_oid": "uuid",
  "type": "integration_request",
  "integration": "google_sheets",
  "action": "update_row",
  "data": {
    "spreadsheet": "ID_DA_PLANILHA",
    "sheet": "NomeDaAba",
    "lookup_column": "4",
    "lookup_field": { "field_name": "user_id", "type": "suf" },
    "binding": [
      { "field_name": "1", "value": { "field_id": "SUBSTITUIR_ID_NOME", "type": "cuf" } },
      { "field_name": "2", "value": { "field_name": "email", "type": "suf" } },
      { "field_name": "3", "value": { "field_name": "phone", "type": "suf" } },
      { "field_name": "4", "value": { "field_name": "user_id", "type": "suf" } },
      { "field_name": "5", "value": { "field_id": "SUBSTITUIR_ID_IGUNERNAME", "type": "cuf" } }
    ],
    "identity": [],
    "mapping": []
  }
}
```

Só incluir se o usuário confirmar que quer salvar em planilha.

---

### external_request — Webhook (opcional)

```json
{
  "_oid": "uuid",
  "type": "external_request",
  "async": false,
  "method": "post",
  "url": "https://url-do-webhook.com/endpoint",
  "content_type": "application/json",
  "headers": {
    "x-api-key": "CHAVE_API_DO_USUARIO"
  },
  "payload": "{\n  \"name\": \"{{cuf_8146798}}\",\n  \"ig_username\": \"{{ig_username}}\",\n  \"utm_source\": \"manychat\",\n  \"utm_medium\": \"SUBSTITUIR_MEDIUM\",\n  \"utm_campaign\": \"SUBSTITUIR_CAMPAIGN\"\n}",
  "mapping": []
}
```

Só incluir se o usuário solicitar integração com CRM ou plataforma externa.
Confirmar com o usuário: URL, headers necessários e estrutura do payload — variam por plataforma.

---

## Bloco "Ações #3" — Ações Obrigatórias de Tracking

Todo fluxo deve ter um bloco de ações de tracking logo após a saudação (antes do primeiro conteúdo).
Este bloco contém ações fixas + opcionais conforme briefing.

**Estrutura completa:**

```json
{
  "type": "action_group",
  "_oid": "uuid-acoes-tracking",
  "namespace": "SUBSTITUIR_PELO_NS_DO_FLUXO_ABERTO",
  "caption": "Ações #3 — Tracking",
  "content_id": null,
  "removed": false,
  "target": { "_content_oid": "uuid-proximo-bloco" },
  "actions": [

    // OBRIGATÓRIO — set_instagram_optin
    { "_oid": "uuid", "type": "set_instagram_optin" },

    // OBRIGATÓRIO — UTM Source (sempre "Direct")
    { "_oid": "uuid", "type": "set_custom_field_value",
      "field_id": "SUBSTITUIR_ID_UTM_SOURCE", "operation": "=", "value": "Direct" },

    // OBRIGATÓRIO — UTM Campaign (nome da campanha — perguntar ao usuário)
    { "_oid": "uuid", "type": "set_custom_field_value",
      "field_id": "SUBSTITUIR_ID_UTM_CAMPAIGN", "operation": "=", "value": "NOME_DA_CAMPANHA" },

    // OBRIGATÓRIO — UTM Medium (gatilho: feed / stories / live / keyword — perguntar ao usuário)
    { "_oid": "uuid", "type": "set_custom_field_value",
      "field_id": "SUBSTITUIR_ID_UTM_MEDIUM", "operation": "=", "value": "Feed" },

    // OBRIGATÓRIO — UTM Content (título do post ou nome do fluxo — perguntar ao usuário)
    { "_oid": "uuid", "type": "set_custom_field_value",
      "field_id": "SUBSTITUIR_ID_UTM_CONTENT", "operation": "=", "value": "TITULO_DO_POST_OU_FLUXO" },

    // OBRIGATÓRIO — Lead Score: +1 ponto por inicialização de fluxo
    { "_oid": "uuid", "type": "set_custom_field_value",
      "field_id": "SUBSTITUIR_ID_LEAD_SCORE", "operation": "+", "value": "{{cuf_SUBSTITUIR_ID_LEAD_SCORE}}+1" },

    // OBRIGATÓRIO — ig_username
    { "_oid": "uuid", "type": "set_custom_field_value",
      "field_id": "SUBSTITUIR_ID_IG_USERNAME", "operation": "=", "value": "{{ig_username}}" },

    // OPCIONAL — Google Sheets (só se usuário confirmar)
    // ver padrão integration_request acima

    // OPCIONAL — Público personalizado Meta (só se usuário confirmar)
    // ver padrão custom_audience_ig_user acima
  ]
}
```

**IDs dos custom fields são únicos por conta ManyChat.**
Usar placeholder `SUBSTITUIR_ID_XXXX` — o usuário mapeia os IDs corretos após importar.
Se o usuário já souber os IDs antes de gerar o JSON, perguntar e já inserir corretos.

**Campos obrigatórios a perguntar no briefing:**
- utm_campaign: nome da campanha (ex: "Workshop CP - T02")
- utm_medium: gatilho do fluxo — feed / stories / live / keyword
- utm_content: título do post (fluxos de conteúdo) ou nome do fluxo (fluxos genéricos)

**Lead Score — regras:**
- Inicialização de fluxo: +1 ponto (sempre no bloco de tracking)
- Cadastro ou compra confirmada: +20 pontos (no bloco de confirmação de inscrição/compra)

---

## Bloco de Condição de Origem — "Ações pontuais do lançamento"

Usar quando o fluxo faz parte de uma campanha com múltiplos posts e é importante rastrear qual conteúdo trouxe o lead.

**Estrutura:**

```
[Ações #3 — Tracking]
        ↓
[Condição: campo de origem já está preenchido?]
  └── IS_UNKNOWN → [Ações pontuais: salva origem + update planilha de origem]
  └── JÁ PREENCHIDO → pula direto para o próximo bloco
        ↓
[Goto: subfluxo de apelido]
        ↓
[Conteúdo do fluxo...]
```

Condição de verificação:
```json
{ "field": "cuf_SUBSTITUIR_ID_ORIGEM", "operator": "IS_UNKNOWN", "type": "cuf" }
```

Ação de origem (só executada uma vez por campanha):
```json
{
  "_oid": "uuid", "type": "set_custom_field_value",
  "field_id": "SUBSTITUIR_ID_ORIGEM", "operation": "=",
  "value": "TITULO_DO_POST_OU_FLUXO"
}
```

---

## Subfluxo "Adicionar apelido"

Todo fluxo deve chamar o subfluxo de apelido via `goto` após o bloco de tracking.
O subfluxo verifica se `cuf_8146798` está vazio e, se sim, solicita o apelido ao usuário.

**Goto para o subfluxo:**
```json
{
  "type": "goto",
  "_oid": "uuid-goto-apelido",
  "namespace": "SUBSTITUIR_PELO_NS_DO_FLUXO_ABERTO",
  "caption": "adicionar apelido",
  "content_id": null,
  "removed": false,
  "content_target": null,
  "target": { "flow_ns": "SUBSTITUIR_NS_SUBFLUXO_APELIDO" }
}
```

O usuário precisará preencher `flow_ns` com o namespace do subfluxo de apelido na conta dele.
Link para copiar o subfluxo com 1 clique:
`https://app.manychat.com/flowPlayerPage?share_hash=399907_7e6ebf5937f44a2ea2d1f2b625a2297fc594b5b5`

---

## Posicionamento da Condição de Aluno/Inscrito

A condição de aluno **não vai no início do fluxo** — vai imediatamente antes do pitch.

**Exceção:** fluxos cujo único objetivo é o pitch (sem entrega de isca ou conteúdo antes).
Nesses casos, a condição pode ir no início para evitar que alunos percam tempo.

**Fluxo com isca/conteúdo + pitch:**
```
[Saudação] → [Ações #3] → [Condição origem] → [Goto apelido]
        ↓
[Conteúdo / isca prometida no post]  ← todos recebem, inclusive alunos
        ↓
[Condição: já é aluno/inscrito?]     ← só aqui, antes do pitch
  └── SIM → mensagem personalizada para aluno + encerra
  └── NÃO → pitch
```

**Fluxo 100% pitch (sem isca):**
```
[Saudação] → [Ações #3] → [Condição: já é aluno?]  ← pode ir no início
  └── SIM → mensagem de já inscrito
  └── NÃO → pitch
```

---

## ⚠️ Regras Críticas de Conexão

### Regra 1 — Bloco de ação vem DEPOIS do bloco que o chama

O botão de um bloco de mensagem aponta para o action_group, que aí sim aponta para a mensagem seguinte.

❌ action_group com `target` apontando para o bloco anterior
✅ botão do bloco de mensagem → action_group → próxima mensagem

### Regra 2 — Bloco de mensagem com `target` avança automaticamente

Quando um bloco `instagram` tem `"target": { "_content_oid": "..." }`, avança sozinho ao terminar.
Usar quando o bloco de mensagem precisa chamar um action_group (notify_admin, open_conversation) automaticamente.

```json
// Bloco de dúvida: avança automaticamente para as ações
{ "type": "instagram", "target": { "_content_oid": "bloco-acoes-duvida" }, ... }

// Bloco de ações: encerra
{ "type": "action_group", "target": null, ... }
```

### Regra 3 — Máximo 3 botões por bloco, cada destino com 1 botão

Quando há 3 destinos (sim / dúvida / não quero), cada botão aponta para um bloco diferente.
Nunca repetir `_content_oid` para "compensar" destino ausente — isso deixa o fallback desconectado.

### Regra 4 — multi_condition com placeholder de ID gera bloco quebrado

Quando o `field_id` da condição é um placeholder (`SUBSTITUIR_ID_ORIGEM`) e não foi fornecido pelo usuário, o ManyChat importa o bloco com `conditions: []`, `default_target: null` e `default_target_oid: null`. O resultado é um bloco de condição sem nenhum caminho conectado — impossível de corrigir sem recriar manualmente.

**Regra:** Se o `field_id` de uma condição não for conhecido, **omitir o bloco de condição inteiro** e substituir por comentário no roteiro orientando o usuário a criá-lo manualmente após importar. Nunca gerar `multi_condition` com `field_id` placeholder.

```json
// ❌ ERRADO — gera bloco quebrado ao importar
{
  "type": "multi_condition",
  "conditions": [{
    "filter": { "groups": [{ "items": [{ "field": "cuf_SUBSTITUIR_ID_ORIGEM", ... }] }] },
    "target": { "_content_oid": "bloco-04" }
  }],
  "default_target": { "_content_oid": "bloco-05" }
}

// ✅ CORRETO — omitir e orientar o usuário
// [ATENÇÃO: Criar manualmente o bloco de condição de origem após importar.
//  Verificar se cuf_ORIGEM está vazio → SIM: bloco-04 | NÃO: bloco-05]
```

Se o usuário fornecer o ID do campo, aí sim gerar normalmente com o ID real.

---

### Regra 5 — Goto: `content_target: null` MAS nunca colocar o próximo bloco imediatamente após no array

O bloco `goto` usa `target.flow_ns` para chamar um subfluxo externo. O campo `content_target` deve ser `null`.

**PORÉM:** O ManyChat ao importar preenche automaticamente `content_target` com o `_oid` do próximo bloco no array `contents`. Isso faz o goto se conectar ao bloco seguinte — causando loop ou conexão indesejada.

**Solução:** O bloco `goto` deve ser o **último elemento do array `contents`**. O bloco seguinte na lógica do fluxo (ex: B06 entrega da aula) deve vir antes do goto no array, nunca depois.

Reorganizar a ordem no array para que blocos que vêm "após" o goto na lógica do fluxo apareçam antes dele no JSON:

```json
// ❌ ERRADO — B06 imediatamente após goto no array → ManyChat conecta automaticamente
"contents": [
  { "_oid": "B05-goto", "type": "goto", "content_target": null },
  { "_oid": "B06-entrega", "type": "instagram" }   // ← ManyChat liga B05 a B06 automaticamente
]

// ✅ CORRETO — goto como último elemento do array
"contents": [
  { "_oid": "B06-entrega", "type": "instagram" },   // ← vem antes no array
  { "_oid": "B05-goto", "type": "goto", "content_target": null }  // ← último no array
]
```

Nas `coordinates`, posicionar B05 antes de B06 no canvas para manter a lógica visual correta.

---

### Regra 6 — Bloco instagram com botões deve ter `target: null`

Quando um bloco `instagram` tem botões no `keyboard`, o avanço acontece **exclusivamente pelos botões**. O campo `target` deve ser `null`.

Se `target` estiver preenchido simultaneamente com botões no `keyboard`, o ManyChat cria uma conexão automática paralela aos botões — gerando ligação dupla e comportamento imprevisível no canvas.

```json
// ❌ ERRADO — target preenchido + botões = conexão duplicada
{
  "type": "instagram",
  "target": { "_content_oid": "bloco-11-pitch" },
  "messages": [{ "keyboard": [{ "_content_oid": "bloco-12" }] }]
}

// ✅ CORRETO — bloco com botões sempre com target null
{
  "type": "instagram",
  "target": null,
  "messages": [{ "keyboard": [{ "_content_oid": "bloco-12" }] }]
}
```

`target` preenchido só é correto em blocos **sem botões** que precisam avançar automaticamente (ex: bloco de dúvida que avança para notify_admin).

---

### Regra 7 — Bloco sem botão em nenhuma mensagem recebe `target` automático do ManyChat

Quando um bloco `instagram` não tem nenhum botão em nenhuma das suas mensagens, o ManyChat ao importar adiciona automaticamente `target` apontando para o próximo bloco no array.

**Consequência:** Se o pitch (B11) for um bloco sem botões e o CTA (B12) for um bloco separado logo após no array, o ManyChat liga B11 → B12 automaticamente via `target`. Isso funciona, mas é frágil — qualquer reordenação quebra a conexão.

**Solução preferida:** O **botão do CTA deve estar dentro do mesmo bloco do pitch**, como última mensagem. Não criar bloco separado só para os botões do CTA.

```json
// ❌ PROBLEMÁTICO — pitch sem botão + CTA em bloco separado logo após
{ "_oid": "B11-pitch", "target": null, "messages": [
    { "type": "text", "content": {...}, "keyboard": [] },  // sem botão
    { "type": "text", "content": {...}, "keyboard": [] }   // sem botão — ManyChat adiciona target para B12
]}
{ "_oid": "B12-cta", "messages": [{ "keyboard": [botões...] }] }

// ✅ CORRETO — botões do CTA na última mensagem do bloco de pitch
{ "_oid": "B11-pitch", "target": null, "messages": [
    { "type": "text", "content": {...}, "keyboard": [] },
    { "type": "text", "content": {...}, "keyboard": [
        { "type": "content", "caption": "Libera o link Sun! 🤩", "_content_oid": "B13-acoes-tag" },
        { "type": "content", "caption": "Fiquei com dúvidas", "_content_oid": "B17-duvida" },
        { "type": "content", "caption": "Melhor não Sun 🙁", "_content_oid": "B19-nao-quer" }
    ]}
]}
```

---

## Regras de Smart Delay

**✅ Usar:**
- Após entrega do link → remarketing 20–60min depois ("Já garantiu sua vaga?")
- Looping de engajamento no final (só se usuário fornecer conteúdo complementar no briefing)

**❌ Não usar:**
- Entre blocos sequenciais onde a pessoa acabou de clicar num botão

---

## Regras de UUID

- Cada `_oid` deve ser único em todo o JSON
- Formato v4: `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`
- `ns` raiz e `namespace` de cada bloco: sempre o placeholder
- Botões `content`: `_content_oid` aponta para `_oid` do bloco destino
- Botões `url`: usam `url`, sem `_content_oid`

---

## Regras de Coordenadas

- Espaçamento horizontal entre blocos principais: ~1400px
- Espaçamento vertical entre ramificações: ~800px
- Caminho principal: `y: 0`
- Ramificações: y negativo (acima) ou positivo (abaixo)

---

## Campos Especiais

### Private Reply
Só o bloco de saudação: `"private_reply": "private_reply"`
Todos os outros: `"private_reply": null`

### Variáveis
- `{{cuf_8146798}}` — primeiro nome (apelido)
- `{{full_name}}` — nome completo
- `{{ig_username}}` — username do Instagram
- `{{email}}` — email

---

## Checklist antes de entregar o JSON

- [ ] Bloco de saudação sem delay como primeiro message
- [ ] Bloco "Ações #3" com UTMs + lead score logo após a saudação
- [ ] utm_campaign, utm_medium, utm_content preenchidos (ou placeholders claros)
- [ ] Lead score com +1 ponto na inicialização
- [ ] Lead score com +20 pontos nos blocos de compra/inscrição confirmada
- [ ] Condição de origem incluída (se fluxo de campanha)
- [ ] Goto para subfluxo de apelido incluído
- [ ] Condição de aluno/inscrito ANTES do pitch (não no início, salvo exceção)
- [ ] notify_admin com `all_send_by: ["email", "telegram"]`
- [ ] Google Sheets incluído apenas se usuário confirmou
- [ ] Público personalizado Meta incluído apenas se usuário confirmou
- [ ] Webhook incluído apenas se usuário solicitou
- [ ] Bloco de ação aponta para PRÓXIMO bloco (não o anterior)
- [ ] Bloco de mensagem COM botões tem `target: null` (nunca target + botões simultaneamente)
- [ ] Bloco de mensagem SEM botões que avança automaticamente tem `target` preenchido
- [ ] Máximo 3 botões por bloco, cada destino com 1 botão
- [ ] Nenhum fallback desconectado
- [ ] Nenhum `multi_condition` com `field_id` placeholder — omitir se ID desconhecido
- [ ] Quando B03 omitido: B02 aponta para B05 (nunca para `_oid` inexistente)
- [ ] Bloco `goto` é o último elemento do array `contents`
- [ ] Botões do CTA estão na última mensagem do bloco de pitch (não em bloco separado)
- [ ] Nenhum bloco sem botões seguido imediatamente de outro bloco no array (causa target automático indesejado)
- [ ] Smart Delay apenas em remarketing ou looping (nunca entre blocos sequenciais)
- [ ] Nenhum bloco externo usa `type: "user_input"`
- [ ] Toda captura de resposta usa mensagem interna `type: "question"` em bloco `instagram`
- [ ] Toda pergunta de e-mail usa `answer_method: "input"` e `answer_type: "email"`
- [ ] Toda pergunta de e-mail inclui `save_email_to_system_field` e `set_email_optin`
- [ ] Nenhum bloco de ação foi criado apenas para salvar o e-mail nativo
- [ ] Tipos externos e internos pertencem às listas permitidas
- [ ] Todos os `_oid` são UUIDs v4 únicos
- [ ] `ns` raiz e todos os `namespace` usam o placeholder
- [ ] `coordinates` inclui todos os `_oid`
- [ ] Nenhum bloco tem `removed: true`
- [ ] Toda referência `_content_oid` aponta para um bloco ativo existente
- [ ] Não há blocos duplicados ou desconectados por engano
- [ ] O JSON foi validado pelo `scripts/validate-manychat-json.ps1` incluído nesta skill

### Validação automática obrigatória

Antes de entregar o arquivo, executar:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File CAMINHO_DA_SKILL/scripts/validate-manychat-json.ps1 -Path CAMINHO_DO_JSON
```

O resultado deve terminar em `VALID`. Avisos de blocos desconectados devem ser investigados; só podem permanecer quando o bloco for intencionalmente um ponto de entrada independente. Se houver qualquer `ERROR`, corrigir o JSON e validar novamente antes da entrega.
