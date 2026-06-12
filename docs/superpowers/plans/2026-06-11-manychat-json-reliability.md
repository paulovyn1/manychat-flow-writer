# ManyChat JSON Reliability Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ensinar a skill a gerar coleta de e-mail nativa e impedir a entrega de grafos ManyChat estruturalmente inválidos.

**Architecture:** A referência técnica continuará sendo a fonte de padrões de geração. Um validador PowerShell independente aplicará as regras mecânicas aos dois envelopes JSON encontrados, enquanto `SKILL.md` exigirá sua execução antes da entrega.

**Tech Stack:** Markdown, JSON, PowerShell 5+.

---

### Task 1: Criar fixtures e contrato do validador

**Files:**
- Create: `tests/fixtures/valid-email-question.json`
- Create: `tests/fixtures/invalid-user-input.json`
- Create: `tests/fixtures/invalid-email-adapters.json`
- Create: `tests/fixtures/invalid-reference.json`
- Create: `tests/fixtures/invalid-duplicate-oid.json`
- Create: `tests/fixtures/valid-flow-export.json`
- Create: `tests/fixtures/warning-disconnected.json`
- Create: `tests/fixtures/invalid-removed.json`
- Create: `tests/validate-manychat-json.Tests.ps1`

- [ ] **Step 1: Escrever testes que executam o validador para cada fixture**

Os testes devem chamar:

```powershell
& "$PSScriptRoot\..\skill\scripts\validate-manychat-json.ps1" -Path $fixture
```

e verificar códigos `0` para válidos, `1` para inválidos e mensagens específicas no output.

- [ ] **Step 2: Executar os testes e confirmar RED**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests/validate-manychat-json.Tests.ps1
```

Expected: FAIL porque `skill/scripts/validate-manychat-json.ps1` ainda não existe.

### Task 2: Implementar o validador estrutural

**Files:**
- Create: `skill/scripts/validate-manychat-json.ps1`
- Test: `tests/validate-manychat-json.Tests.ps1`

- [ ] **Step 1: Normalizar envelopes**

Extrair `contents` e `coordinates` de:

```text
batch.contents + coordinates
flow.draft_batch.contents + flow.draft_coordinates
```

- [ ] **Step 2: Validar tipos, UUIDs e resíduos**

Permitir blocos `instagram`, `action_group`, `multi_condition`, `smart_delay` e `goto`; permitir mensagens `text`, `delay` e `question`. Rejeitar tipos desconhecidos, `_oid` inválido/duplicado e `removed: true`.

- [ ] **Step 3: Validar referências e coordenadas**

Percorrer `target._content_oid`, `content_target._content_oid`, `default_target._content_oid`, destinos de condições e teclados `content`. Toda referência interna deve apontar para bloco ativo e todo bloco ativo deve ter coordenada.

- [ ] **Step 4: Validar perguntas de e-mail**

Para `answer_type: "email"`, exigir:

```json
"answer_method": "input",
"adapters": [
  { "type": "save_email_to_system_field" },
  { "type": "set_email_optin" }
]
```

- [ ] **Step 5: Validar invariantes do canvas**

Rejeitar `instagram` com botões de conteúdo e `target` simultaneamente. No envelope importável, exigir que `goto` seja o último item. Emitir aviso para blocos ativos sem entrada, exceto o primeiro bloco.

- [ ] **Step 6: Executar os testes e confirmar GREEN**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests/validate-manychat-json.Tests.ps1
```

Expected: todos os cenários passam.

### Task 3: Documentar o formato canônico

**Files:**
- Modify: `skill/references/json-format.md`
- Test: `tests/validate-manychat-json.Tests.ps1`

- [ ] **Step 1: Adicionar tipos permitidos e proibição de `user_input`**

Documentar que captura de entrada é uma mensagem `question` dentro de um bloco `instagram`.

- [ ] **Step 2: Adicionar exemplo completo de coleta de e-mail**

Incluir `answer_method`, `answer_type`, adapters, validação, tentativas, timeout e `target`.

- [ ] **Step 3: Adicionar pergunta de múltipla escolha**

Documentar `answer_method: "reply"`, `answer_type: "text"` e `answer_replies`, sem confundir respostas com botões `keyboard`.

- [ ] **Step 4: Documentar os envelopes**

Manter `batch.contents` como formato de entrega e explicar que `flow.draft_batch` é formato de export usado como referência, não como modelo limpo.

- [ ] **Step 5: Expandir checklist**

Adicionar tipos, adapters, resíduos, referências, coordenadas, duplicidade e conectividade.

### Task 4: Tornar a validação obrigatória na skill

**Files:**
- Modify: `skill/SKILL.md`
- Modify: `skill/VERSION`
- Modify: `README.md`

- [ ] **Step 1: Atualizar regras obrigatórias de JSON**

Exigir coleta automática de e-mail com `question` e proibir `user_input`.

- [ ] **Step 2: Adicionar etapa de validação**

Antes da entrega, orientar a salvar o JSON e executar:

```powershell
powershell -ExecutionPolicy Bypass -File skill/scripts/validate-manychat-json.ps1 -Path CAMINHO_DO_JSON
```

Nenhum JSON com erros deve ser entregue.

- [ ] **Step 3: Atualizar versão e README**

Incrementar a versão para `2.1.0` e registrar coleta nativa e validação preventiva.

### Task 5: Verificação final

**Files:**
- Test: `tests/validate-manychat-json.Tests.ps1`
- Verify: `skill/SKILL.md`
- Verify: `skill/references/json-format.md`

- [ ] **Step 1: Rodar todos os testes**

```powershell
powershell -ExecutionPolicy Bypass -File tests/validate-manychat-json.Tests.ps1
```

- [ ] **Step 2: Validar fixtures e amostras reais**

O fixture canônico e o envelope de export devem passar. A versão original com `user_input` deve falhar. A v3 deve reportar que as perguntas de e-mail não estão no formato nativo.

- [ ] **Step 3: Revisar documentação**

Confirmar que não há recomendações contraditórias para configurar e-mail manualmente, nem uso de `user_input`.

- [ ] **Step 4: Inspecionar diff**

```powershell
git diff --check
git diff --stat
```

Expected: sem erros de whitespace e somente arquivos do escopo alterados.
