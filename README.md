# ManyChat Flow Writer Skill — Triwer

Skill para o Claude Desktop e Claude Code que cria fluxos de automação ManyChat para Instagram.  
Baseada na análise de fluxos reais do Triwer que geraram vendas e captações rastreadas.

**Versão atual:** 2.1.0

---

## O que essa skill faz

- Cria fluxos completos de venda e captação para ManyChat/Instagram
- Gera roteiro de mensagens (para montar manualmente) ou JSON pronto para importar
- Gera coleta de e-mail nativa com validação e opt-in automático
- Valida tipos, UUIDs, conexões e coordenadas antes da importação
- Escreve na voz do seu personagem ou no seu próprio tom de voz
- Rastreia interações com UTMs e lead score automaticamente
- Integra com o [ManyChat MCP](https://github.com/paulovyn1/manychat-mcp) para buscar e criar tags/campos sem sair do Claude

---

## Instalação

### Mac / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/paulovyn1/manychat-flow-writer/main/scripts/instalar-mac.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/paulovyn1/manychat-flow-writer/main/scripts/instalar-windows.ps1 | iex
```

O instalador:
- Verifica se já há uma versão instalada
- Só atualiza se houver versão mais nova
- Preserva seus dados pessoais (memória e perfil) em atualizações
- Faz backup automático da versão anterior

---

## Atualizar

Rode o mesmo comando de instalação — o script detecta a versão instalada e só baixa se houver atualização.

---

## Requisitos

- **Claude Desktop** ou **Claude Code** instalado
- **Plano pago do Claude** (Pro ou superior)
- Conexão com internet para instalar

---

## Instalação manual

Se preferir instalar sem o script:

1. Crie a pasta: `~/.claude/skills/manychat-flow-writer/references/`
2. Baixe os arquivos da pasta `skill/` deste repositório para essa pasta
3. **Não sobrescreva** `user-memory.md` e `user-profile.md` se já existirem

---

## Estrutura de arquivos

```
~/.claude/skills/manychat-flow-writer/
├── SKILL.md                          ← orquestrador principal
├── VERSION                           ← versão instalada
├── scripts/
│   └── validate-manychat-json.ps1    ← validador preventivo do JSON
└── references/
    ├── user-profile.md               ← seu perfil e onboarding (pessoal)
    ├── user-memory.md                ← seus IDs e dados do ManyChat (pessoal)
    ├── sun-personality.md            ← personalidade do Sun (Triwer)
    ├── patterns-venda.md             ← padrões de fluxos de venda
    ├── patterns-captacao.md          ← padrões de fluxos de captação
    ├── copy-rules.md                 ← regras de copy para direct
    ├── json-format.md                ← regras técnicas de geração de JSON
    └── manychat-mcp.md               ← integração com ManyChat MCP
```

> `user-profile.md` e `user-memory.md` são **seus dados pessoais** — nunca sobrescritos em atualizações.

---

## ManyChat MCP (recomendado)

Com o ManyChat MCP instalado, o Claude busca e cria tags e campos personalizados automaticamente — sem você precisar copiar nenhum ID.

```bash
# Mac
curl -fsSL https://raw.githubusercontent.com/paulovyn1/manychat-mcp/main/scripts/instalar-mac.sh | bash

# Windows
irm https://raw.githubusercontent.com/paulovyn1/manychat-mcp/main/scripts/instalar-windows.ps1 | iex
```

---

## Como usar

Após instalar, abra o Claude Desktop ou Claude Code e peça:

```
cria um fluxo de captação no ManyChat para um post sobre X
```

```
monta um fluxo de venda para o produto Y com keyword Z
```

```
gera o JSON do fluxo para importar no ManyChat
```

Na primeira vez, a skill vai fazer um onboarding rápido para configurar seu perfil e tom de voz.

---

Feito com amor pelo Triwer
