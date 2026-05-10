# user-memory.md — Memória do Usuário

> Ler este arquivo SOMENTE quando for gerar JSON ou quando o usuário mencionar IDs, tags, subfluxos ou campos personalizados.
> Atualizar proativamente sempre que o usuário fornecer novos IDs, nomes de tags, namespaces ou preferências.

---

## Como atualizar este arquivo

Sempre que o usuário passar qualquer informação abaixo, atualizar a seção correspondente E confirmar:
> "Salvei [dado] na memória. Posso usar esses valores nos próximos fluxos automaticamente."

Informações que disparam atualização:
- IDs de custom fields (UTMs, lead score, ig_username, nome, origem, etc.)
- IDs ou nomes de tags recorrentes (aluno, inscrito, clicou no link, etc.)
- Namespace de subfluxos reutilizáveis (apelido, pitch, BF, etc.)
- ID de planilha Google e nome de abas
- ad_account_id e custom_audience_id do Meta
- URL de webhook + headers padrão

---

## Onde encontrar IDs no ManyChat

### IDs de Custom Fields (Campos Personalizados)
1. Acessar: **Settings → Custom Fields**
2. Passar o mouse sobre o campo → aparece o ID no rodapé do navegador
   OU abrir o campo para editar → o ID aparece na URL: `.../custom_fields/XXXXXXX`

### IDs de Tags
1. Acessar: **Audience → Tags**
2. Clicar na tag → o ID aparece na URL: `.../tags/XXXXXXX`
   OU exportar a lista de contatos com aquela tag e verificar no CSV

### Namespace de Subfluxos
1. Abrir o subfluxo no ManyChat
2. O namespace está na URL: `app.manychat.com/.../NAMESPACE_AQUI`
   Formato: `content20220707160314_847177`

### ID de Planilha Google Sheets
URL da planilha: `docs.google.com/spreadsheets/d/ID_AQUI/edit`
O ID é a string entre `/d/` e `/edit`

### ad_account_id e custom_audience_id (Meta Ads)
1. Acessar: **Meta Ads Manager → Públicos**
2. Passar o mouse sobre o público → ID aparece no tooltip
   OU verificar na URL ao abrir o público

---

## Dados do Usuário

> Preencher abaixo conforme o usuário for fornecendo. Deixar em branco se ainda não informado.

### Custom Fields — UTMs e Tracking

| Campo | ID | Observação |
|---|---|---|
| utm_source | — | Sempre "Direct" |
| utm_campaign | — | |
| utm_medium | — | |
| utm_content | — | |
| lead_score | — | +1 por fluxo, +20 por compra/inscrição |
| ig_username | — | |
| nome (apelido) | — | Normalmente cuf_8146798 no Triwer |
| origem_lançamento | — | Campo registrado 1x por campanha |

### Custom Fields — Outros

| Campo | ID | Observação |
|---|---|---|
| | | |

### Tags Recorrentes

| Tag | ID | Uso |
|---|---|---|
| aluno | — | Verificar se já é aluno antes do pitch |
| inscrito | — | Verificar se já está inscrito |
| clicou_no_link | — | Rastrear quem clicou no CTA |
| | | |

### Subfluxos Reutilizáveis

| Subfluxo | Namespace (flow_ns) | Link de cópia |
|---|---|---|
| Adicionar apelido | — | https://app.manychat.com/flowPlayerPage?share_hash=399907_7e6ebf5937f44a2ea2d1f2b625a2297fc594b5b5 |
| | | |

### Google Sheets

| Planilha | ID | Abas usadas |
|---|---|---|
| | | |

### Meta Ads

| Campo | Valor |
|---|---|
| ad_account_id | — |
| custom_audience_id | — |
| custom_audience_name | — |

### Webhooks / CRM

| Plataforma | URL | Headers | Payload padrão |
|---|---|---|---|
| | | | |

---

## Preferências do Usuário

> Registrar padrões de uso identificados (nome padrão de campanha, aba padrão da planilha, etc.)

| Preferência | Valor |
|---|---|
| | |
