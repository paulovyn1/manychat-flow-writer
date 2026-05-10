# Padrões de Fluxo de Venda — ManyChat Triwer

> Baseado na análise de 5 fluxos reais de venda (2023–2024) que geraram vendas rastreadas
> do curso Vendas Automáticas (R$197) e do SDS. Todos via Instagram direct.

---

## Framework Base — Estrutura Universal dos Fluxos de Venda

Todo fluxo de venda segue essa sequência. Cada etapa tem um papel específico e não pode ser pulada.

```
1. GATILHO         → Comentário com keyword no post
2. SAUDAÇÃO        → Sun se apresenta + botão único "Continuar"
3. OPTIN/AÇÕES     → set_instagram_optin + tags + custom fields
4. CONDIÇÃO ALUNO  → Verifica se já é aluno (tag)
   ├── SIM → Caminho aluno: elogio + próximo conteúdo (NUNCA pitch)
   └── NÃO → Segue para aquecimento
5. AQUECIMENTO     → Entrega valor / cria contraste / ativa dor
6. PERMISSÃO       → "Posso te dizer/mostrar?" antes de revelar
7. SUN COMO DEMO   → O próprio Sun demonstra o produto ao vivo
8. PROVA SOCIAL    → Depoimentos e/ou resultados (imagens/cards)
9. SMART DELAY     → 20–30 min antes do pitch (deixa digerir)
10. PITCH          → Benefícios + âncora de preço + urgência
11. CTA TRIPLO     → Link / Dúvida / Não quero
    ├── LINK       → Entrega link + tag de clique
    ├── DÚVIDA     → Coleta dúvida + notify_admin + abre conversa
    └── NÃO QUERO  → Fallback empático + próximo conteúdo
```

---

## Padrões de Copy — Regras confirmadas em 4+ fluxos

### 1. Saudação — sempre igual na estrutura, variável no contexto

Formato fixo:
```
"Oeee Estrategista! 🤩🤩🤩 Aqui é o Sun, o assistente robô [adjetivo divertido] 🥳🥳

[Confirmação do que a pessoa fez — "Vi que você comentou / Vi seu comentário"]
[O que você vai entregar agora — conectado diretamente ao tema do post]

[Instrução simples de como avançar]"

[Botão único: "👉🏻 Continuar👈🏻"]
```

Exemplos de adjetivos usados: "mais Topzeira do insta", "mais engajado do Instagram", "mais top das galáxias"

**Regra:** A saudação nunca entrega o conteúdo. Só confirma o comentário e pede para clicar.

---

### 2. Permissão antes de revelar — padrão em todos os fluxos

Nunca entrega direto. Sempre pede permissão antes de cada revelação importante:

- *"Posso te dizer o que é?"*
- *"Posso revelar pra você quanto custa?"*
- *"Posso te liberar o link com esse desconto?"*
- *"Eu tenho uma última coisa pra revelar pra você. Posso dizer o que é?"*

**Por que funciona:** Cada pergunta de permissão gera um clique que reengaja o usuário e aumenta o investimento emocional na conversa.

---

### 3. Botões com variações para o mesmo destino

Nunca um botão único quando há possibilidade de usar 2–3. As variações simulam respostas humanas diferentes para o mesmo sentimento:

```
"Só se for agora! 😱"
"Conta logooo! 🤯"
"Cuidaa, falaaa! 🤑"
→ Todos apontam para o mesmo bloco
```

**Por que funciona:** Parece conversa natural, não formulário. O usuário escolhe a resposta que mais combina com ele.

---

### 4. Sun como demonstração viva do produto

Em todos os fluxos de venda do Vendas Automáticas, o Sun descreve as próprias capacidades como features do produto que está vendendo:

- *"Você pode ter um Gêmeo do Sun trabalhando pra você também"*
- *"Talvez não tão simpático como eu, né?"*
- *"Um irmão meu que você pode chamar como quiser e colocar para vender pra você 24h por dia"*
- *"Eu chamo pelo nome, faço perguntas estratégicas, mudo o caminho dependendo de quem você é"*

**Regra:** O produto é demonstrado enquanto a conversa acontece. A prova é a experiência em si.

---

### 5. Condição de aluno — obrigatória em todos os fluxos

Sempre verificar se o contato já tem a tag de aluno/comprador. O caminho do aluno:

```
"Eu sei que você já faz parte da turma do [produto] 😂😂

Na estratégia da Chefia, agora seria o momento de fazer o pitch de vendas para quem ainda não é aluno.
Mas você já sabe como funciona né? 😅

Então cuida! Não perde tempo e vai agora aplicar isso nos seus próximos conteúdos. 😎😎

Eu quero ter seu depoimento aqui no direct para mostrar pra todo mundo o resultado que essa estratégia é capaz de trazer. 🚀🚀🔥🔥

[Botão: link para próximo conteúdo]"
```

**Regra:** Aluno nunca recebe pitch. Recebe elogio + CTA para próximo conteúdo.

---

### 6. Fallback de dúvida — sempre abre conversa E notifica admin

```
Mensagem: "Puxa vida [Nome]! 😅 Por essa eu não esperava não.
Mas tudo bem, me fala qual a sua dúvida que eu vou chamar a Chefia aqui para te ajudar."

Ações no bloco seguinte:
- notify_admin: "{{full_name}} está com dúvidas sobre o [produto]"
- assign_conversation (para humano assumir)
- open_conversation
```

**Regra:** Dúvida = lead quente. Sempre notificar humano imediatamente.

---

### 7. Fallback de "não quero" — nunca abandona

```
"Mai rapaz tu vai perder essa oportunidade... 😅😅
Mas tudo bem né 😁😁

Se você quiser aproveita para ver [conteúdo relacionado à dor]..."
[Botão: link para post do feed]

[10s delay]
"Nos vemos no próximo conteúdo 🔥"
```

**Regra:** Mesmo quem recusa recebe valor e uma saída digna. Mantém o relacionamento.

---

### 8. Segmentação por dor (quando aplicável)

Alguns fluxos segmentam logo no início para personalizar o conteúdo entregue:

```
"Então me fala, qual sua maior dificuldade hoje? 🤔

1️⃣ [Dor A]
2️⃣ [Dor B]"

→ Opção 1 → conteúdo alinhado com Dor A
→ Opção 2 → conteúdo alinhado com Dor B
```

**Quando usar:** Quando o produto resolve problemas diferentes para perfis diferentes. Não usar se o produto tem uma promessa única e direta.

---

## Padrões Técnicos — Delays e Ritmo

| Situação | Delay recomendado |
|---|---|
| Entre mensagens curtas (1 linha) | 1–2s |
| Entre mensagens médias (2–3 linhas) | 3–4s |
| Após mensagem longa ou lista | 5–8s |
| Após envio de imagem/card | 7–10s |
| Após lista de benefícios densa | 14–15s |
| Smart Delay (antes do pitch) | 20–30 min |

**Regra geral:** O delay deve dar tempo suficiente para a pessoa ler, mas não tanto que ela esqueça que estava conversando.

---

## Padrões de Ações (action_group) — Quando e o quê tagar

| Momento | Ação |
|---|---|
| Logo após saudação | set_instagram_optin |
| Logo após saudação | set_custom_field: ig_username |
| Logo após saudação (2024+) | update_row em planilha (nome, email, user_id) |
| Entrada no fluxo | set_custom_field: origem ("Organico", "Impulsionado") |
| Quando clica em "liberar link" | add_tag: comprador_interessado |
| Quando clica no link de compra | add_tag: clicou_link_[produto] |
| Fallback dúvida | notify_admin + assign_conversation |

---

## Padrão de Pitch — Estrutura do Bloco de Oferta

```
1. Âncora de valor separado: "⛔ Se comprado separadamente: R$ X"
2. Preço com desconto: "Mas falando comigo a coisa é diferente 😅"
3. Oferta: "Você pode garantir agora por [preço] com 60% de desconto"
4. Bônus com âncora: "🎁 [Bônus] — Se comprar separado: R$ X / Pra você: GRÁTIS"
5. Urgência leve: "Em breve o preço vai subir" ou "antes que o preço suba"
6. CTA com permissão: "Posso liberar o link com esse desconto pra você?"
```

---

## Coerência Temática — Regra de Ouro

**O tema do post que gerou o comentário deve ser o mesmo tema trabalhado no fluxo.**

Fluxos com alta coerência temática apresentam CTRs consistentemente mais altos do início ao fim. Exemplos:

- Post sobre "conteúdo que expira em 24h" → Fluxo sobre automação que resolve isso ✅
- Post sobre "parar de postar no feed" → Fluxo sobre stories que vendem sem feed ✅
- Post sobre "por que questionam seu preço" → Fluxo sobre copy personalizada via direct ✅

**Na prática:** Ao criar um fluxo, sempre perguntar qual é o post que vai gerar o comentário e garantir que a dor/promessa do post é a dor/promessa trabalhada no fluxo.

---

## Evolução 2023 → 2024

| Elemento | 2023 | 2024 |
|---|---|---|
| Rastreamento | Tags simples | Tags + custom fields + planilha |
| Arquitetura | Fluxo único | Fluxo principal + goto para fluxo base |
| Fallback "não quero" | Neutro | Empático + autocrítica do Sun |
| Segmentação | Por dor via botões | Por dor + por histórico de aluno |
| Smart Delay | 20 min | 20–30 min |

---

## O que NÃO fazer — Baseado nos pontos de abandono

- **Nunca** fazer pitch logo após a saudação — sempre entregar valor antes
- **Nunca** enviar o link sem pedir permissão antes
- **Nunca** fazer pitch para aluno — verificar tag sempre
- **Nunca** usar botão único quando pode usar 2–3 com variações
- **Nunca** mudar o tom do Sun no meio do fluxo
- **Nunca** quebrar uma ideia incompleta entre dois blocos sem delay adequado
- **Nunca** ignorar o fallback — sempre ter saída para quem não quer continuar
