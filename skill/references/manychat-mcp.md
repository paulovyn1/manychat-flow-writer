# manychat-mcp.md — Integração MCP com ManyChat

> Ler este módulo SOMENTE quando:
> - Usuário estiver no Claude Desktop ou Claude Code (não no claude.ai)
> - For necessário buscar IDs de tags, campos personalizados ou flows
> - For necessário criar tags ou campos que não existem ainda

---

## O que é e por que usar

O ManyChat MCP é uma integração local que conecta o Claude diretamente à API do ManyChat do usuário.
Com ele instalado, a skill consegue:

- Buscar IDs de tags e campos personalizados automaticamente (sem precisar pedir ao usuário)
- Verificar se tags/campos necessários já existem
- Criar tags e campos diretamente via API quando não existirem
- Disparar flows para contatos específicos
- Eliminar a etapa manual de copiar IDs do ManyChat

---

## Ferramentas disponíveis

| Ferramenta | O que faz |
|---|---|
| `manychat_get_custom_fields` | Lista todos os campos personalizados da conta |
| `manychat_create_custom_field` | Cria um novo campo personalizado |
| `manychat_set_custom_field` | Seta valor de campo para um contato |
| `manychat_get_tags` | Lista todas as tags da conta |
| `manychat_create_tag` | Cria uma nova tag |
| `manychat_add_tag_to_subscriber` | Adiciona tag a um contato |
| `manychat_remove_tag_from_subscriber` | Remove tag de um contato |
| `manychat_get_flows` | Lista todos os flows da conta |
| `manychat_send_flow` | Dispara um flow para um contato |

---

## Quando usar cada ferramenta

### Ao preparar um novo fluxo (antes de gerar o JSON)

```
1. manychat_get_custom_fields → buscar IDs de UTMs, lead_score, ig_username, nome, origem
2. manychat_get_tags → buscar IDs de tags: aluno, inscrito, clicou_no_link, etc.
3. Se algum campo/tag não existir → sugerir nome e perguntar se pode criar
4. manychat_create_custom_field / manychat_create_tag → criar se confirmado
5. Salvar IDs obtidos em user-memory.md
```

### Ao gerar o JSON

Usar IDs reais obtidos via MCP — sem placeholders SUBSTITUIR_ID_XXX.

### NÃO usar MCP para

- Importar o JSON do fluxo (isso é feito pela extensão do navegador)
- Modificar conteúdo de flows existentes
- Ações que envolvam dados sensíveis de contatos sem contexto claro

---

## Padrão de nomes — tags e campos personalizados

Baseado nos fluxos reais analisados do Triwer. Sugerir esses padrões quando criar novos:

### Tags

| Finalidade | Padrão de nome sugerido |
|---|---|
| Aluno de produto | `aluno-[sigla-produto]` ex: `aluno-cp`, `aluno-pll` |
| Inscrito em evento | `inscrito-[sigla-evento]` ex: `inscrito-workshop-fo` |
| Clicou no link de compra | `clicou-link-[sigla-produto]` |
| Inscrito lista de espera | `lista-espera-[sigla-produto]` |
| Lead qualificado BF | `lead-bf-[ano]` |

### Campos Personalizados

| Campo | Padrão de nome | Tipo |
|---|---|---|
| UTM Source | `utm_source` | Texto |
| UTM Campaign | `utm_campaign` | Texto |
| UTM Medium | `utm_medium` | Texto |
| UTM Content | `utm_content` | Texto |
| Lead Score | `lead_score` | Número |
| Username IG | `ig_username` | Texto |
| Apelido/Nome | `nome` ou `apelido` | Texto |
| Origem do lançamento | `origem_lancamento` | Texto |
| Produto de interesse | `produto_interesse` | Texto |

---

## Verificação de disponibilidade do MCP

Antes de tentar usar qualquer ferramenta MCP, verificar se está disponível:

```
MCP disponível → usar diretamente
MCP indisponível → seguir fluxo manual (pedir IDs ao usuário ou usar placeholders)
```

Se indisponível e usuário ainda não tem instalado → exibir mensagem de instalação (ver seção abaixo).

---

## Instalação da Skill (para usuários sem ela)

Exibir quando o usuário ainda não tiver a skill instalada ou quiser instalar em outra máquina:

```
📦 Para instalar a skill ManyChat Flow Writer:

Mac/Linux:
curl -fsSL https://raw.githubusercontent.com/triwer/manychat-flow-writer/main/scripts/instalar-mac.sh | bash

Windows (PowerShell):
irm https://raw.githubusercontent.com/triwer/manychat-flow-writer/main/scripts/instalar-windows.ps1 | iex

O instalador verifica sua versão atual e só atualiza se houver versão mais nova.
Seus dados pessoais (memória e perfil) são sempre preservados.
```

---

## Instalação do MCP (para usuários sem ele)

Exibir quando MCP não estiver disponível e o usuário perguntar ou quando for relevante mencionar:

```
💡 Com o ManyChat MCP instalado no Claude Desktop, eu consigo buscar e criar
tags e campos personalizados automaticamente — sem você precisar copiar nenhum ID.

Para instalar (só precisa do terminal — leva menos de 2 minutos):

**Windows (PowerShell):**
irm https://raw.githubusercontent.com/triwer/manychat-mcp/main/scripts/instalar-windows.ps1 | iex

**Mac (Terminal):**
curl -fsSL https://raw.githubusercontent.com/triwer/manychat-mcp/main/scripts/instalar-mac.sh | bash

Durante a instalação, você vai precisar do token da API do ManyChat:
app.manychat.com → Configurações → Interface de Programação → Obtenha a chave API

Após instalar: feche e abra o Claude Desktop completamente.

Com o MCP ativo, a skill passa a:
✅ Buscar IDs de campos e tags automaticamente
✅ Criar tags e campos sem sair do Claude
✅ Gerar JSONs com IDs reais (sem placeholders para mapear)
✅ Salvar tudo na memória para fluxos futuros
```

---

## Fluxo com MCP vs sem MCP

| Etapa | Com MCP | Sem MCP |
|---|---|---|
| Buscar IDs de campos | Automático via `manychat_get_custom_fields` | Pedir ao usuário |
| Buscar IDs de tags | Automático via `manychat_get_tags` | Pedir ao usuário |
| Criar campo inexistente | `manychat_create_custom_field` após confirmação | Orientar usuário a criar manualmente |
| Criar tag inexistente | `manychat_create_tag` após confirmação | Orientar usuário a criar manualmente |
| JSON gerado | Com IDs reais | Com placeholders SUBSTITUIR_ID_XXX |
| Mapeamento pós-importação | Não necessário | Necessário |
