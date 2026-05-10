# user-profile.md — Perfil e Onboarding do Usuário

> Ler este arquivo SOMENTE quando:
> - For a primeira interação do usuário com a skill (verificar `onboarding_concluido`)
> - For escrever mensagens e precisar do tom de voz/personalidade
>
> Atualizar sempre que onboarding for concluído ou personalidade for atualizada.

---

## Status

```
onboarding_concluido: false
personalidade_configurada: false
tipo_interlocutor: —
nome_interlocutor: —
skill_personalidade_path: —
versao_skill: 2.0.0
```

---

## Onboarding — Executar quando `onboarding_concluido: false`

### Passo 1 — Apresentação

Apresentar a skill ao usuário:

> "Olá! Antes de começar a criar fluxos ManyChat, preciso de algumas informações sobre você e sua operação. São poucas perguntas e vou salvar tudo pra não precisar perguntar de novo. Vamos lá?"

---

### Passo 2 — Quem vai interagir nos fluxos

Perguntar:
> "Nos seus fluxos do ManyChat, quem vai interagir com a audiência?
> **A)** Um robô/assistente com nome e personalidade próprios (tipo o Sun do Triwer)
> **B)** Você mesmo, na sua própria voz"

Salvar em `tipo_interlocutor`: `robo` ou `proprio`

Se **A (robô)**:
- Perguntar nome do robô e salvar em `nome_interlocutor`
- Seguir para Passo 3

Se **B (próprio)**:
- Salvar `nome_interlocutor` como o nome do usuário
- Seguir para Passo 3

---

### Passo 3 — Documento de personalidade

Perguntar:
> "Você já tem um documento de personalidade/tom de voz criado com a skill **estilo-forge**?
> **A)** Sim, vou anexar agora
> **B)** Não tenho ainda
> **C)** Não quero fazer isso agora"

**Se A — tem o documento:**
- Solicitar que anexe o arquivo `.md`
- Ao receber: salvar o path em `skill_personalidade_path`
- Confirmar: "Personalidade registrada. Vou usar esse tom em todos os fluxos."
- Ir para Passo 4

**Se B — não tem ainda:**
- Informar:
  > "Recomendo criar esse documento — ele melhora muito a qualidade da copy dos fluxos. Para criar, use a skill **estilo-forge** em uma conversa nova. Ela vai guiar o processo completo de captura do seu tom de voz."
- Perguntar se quer fazer isso antes de continuar ou usar o fallback rápido
- Se quiser fazer depois → usar fallback abaixo e seguir para Passo 4
- Se quiser fazer agora → pausar onboarding e orientar a usar estilo-forge primeiro

**Se C — não quer agora → Fallback rápido:**

Fazer as 4 perguntas abaixo e salvar as respostas em `personalidade_fallback`:

1. "Como você se comunica com sua audiência? (ex: informal e descontraído, direto e objetivo, empático e acolhedor)"
2. "Tem expressões, gírias ou palavras que você usa muito? Me dê alguns exemplos."
3. "Como você NÃO gosta de soar? O que parece falso ou artificial pra você?"
4. "Tem alguma referência de comunicação que você admira? (pode ser uma pessoa, marca, estilo)"

Após coletar, informar:
> "Registrei o básico. Para melhores resultados na copy dos seus fluxos, quando puder, crie seu documento completo de personalidade com a skill **estilo-forge** e me envie para atualizar. Fica em ~/.claude/skills/estilo-[seunome]/SKILL.md"

Salvar `personalidade_configurada: true` com tipo `fallback`

---

### Passo 4 — Dados técnicos do ManyChat

Perguntar:
> "Agora preciso dos seus dados técnicos do ManyChat para não precisar pedir sempre que for gerar um fluxo. Pode passar os IDs dos campos personalizados que usa? Se não souber onde encontrar, é só me dizer que explico."

Coletar e salvar em `user-memory.md`:
- IDs de custom fields: UTMs (source, campaign, medium, content), lead_score, ig_username, nome/apelido, origem_lançamento
- Tags recorrentes: aluno, inscrito, clicou_no_link
- Namespace do subfluxo de apelido (se já tiver)
- Google Sheets: se vai usar, coletar ID da planilha
- Meta Ads: se vai usar públicos personalizados, coletar IDs

Se o usuário não souber os IDs → instruir onde encontrar (ver seção em user-memory.md).

---

### Passo 5 — Finalizar onboarding

Após coletar tudo:
> "Perfeito! Configuração concluída. A partir de agora vou criar todos os fluxos no tom certo e já com seus campos mapeados. Pode me pedir o primeiro fluxo!"

Atualizar no arquivo:
```
onboarding_concluido: true
personalidade_configurada: true
```

---

## Personalidade — Usar ao escrever mensagens

> Preencher após onboarding. Se `skill_personalidade_path` estiver preenchido,
> ler o arquivo referenciado ao invés desta seção.

### Interlocutor
- **Nome:** —
- **Tipo:** — (robô / próprio)

### Tom de voz (fallback — só usar se não houver skill de personalidade)
- **Estilo geral:** —
- **Expressões características:** —
- **O que evitar:** —
- **Referências:** —

---

## Histórico de Versão da Skill

| Versão | Data | Mudanças |
|---|---|---|
| 2.0.0 | 2025-05 | Onboarding, user-profile, user-memory, frameworks de captação e venda completos, regras de JSON corrigidas (conexões, smart delay, delay na saudação, condição de aluno), tracking UTMs + lead score, notify_admin email+telegram, subfluxo de apelido |
| 1.0.0 | 2025-05 | Versão inicial — 5 fluxos de venda analisados, sun-personality, patterns-venda, copy-rules, json-format |
