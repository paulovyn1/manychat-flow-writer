# Confiabilidade do JSON ManyChat

## Objetivo

Atualizar a skill `manychat-flow-writer` para gerar JSON importável sem repetir os erros encontrados no fluxo `fluxo_script_aumento_valor_v3.json`, usando o export manualmente corrigido apenas como evidência do formato real do ManyChat.

## Diagnóstico

O tipo de bloco `user_input` não é aceito pelo parser do ManyChat. Coleta de respostas deve permanecer dentro de um bloco `instagram`, usando uma mensagem interna `question`.

Para coleta de e-mail, o formato canônico é:

- bloco externo `type: "instagram"`;
- mensagem interna `type: "question"`;
- `answer_method: "input"`;
- `answer_type: "email"`;
- adapters `save_email_to_system_field` e `set_email_optin`;
- mensagem de validação de e-mail, limite de tentativas e timeout;
- continuação pelo `target` do bloco após uma resposta válida.

Os blocos artificiais `action_group` usados apenas para "salvar e-mail e avançar" não são necessários.

O export corrigido contém resíduos de edição e não deve ser copiado integralmente: há bloco duplicado, bloco com `removed: true` e grupos desconectados. Apenas estruturas confirmadas e coerentes entram na documentação.

## Mudanças

### Referência técnica

`skill/references/json-format.md` receberá:

1. Tipos externos e internos permitidos.
2. Proibição explícita de bloco externo `user_input`.
3. Exemplo canônico completo para coleta de e-mail.
4. Exemplo de pergunta com respostas predefinidas.
5. Regras para `question`, adapters, validação, timeout e continuação.
6. Distinção entre o envelope importável e o export completo `flow.draft_batch`.
7. Validação de integridade do grafo antes da entrega.

### Orquestrador

`skill/SKILL.md` passará a exigir:

- uso de `question` para qualquer captura de resposta;
- coleta automática de e-mail no campo nativo;
- validação estrutural antes de entregar JSON;
- correção de erros encontrados, em vez de entregar JSON com avisos de configuração manual quando o formato é conhecido.

### Validador

Será criado `skill/scripts/validate-manychat-json.ps1`, distribuído junto com a skill e responsável por aceitar:

- JSON importável com `batch.contents` e `coordinates`;
- export do ManyChat com `flow.draft_batch.contents` e `flow.draft_coordinates`.

O validador reportará como erro:

- tipo externo ou interno desconhecido;
- `user_input`;
- `_oid` ausente, inválido ou duplicado;
- referência interna para bloco inexistente;
- coordenada ausente;
- bloco com `removed: true`;
- coleta de e-mail sem os adapters obrigatórios;
- bloco `instagram` com botões e `target` simultaneamente;
- `goto` fora do final do array importável.

Também reportará blocos ativos desconectados como aviso, pois alguns podem ser pontos de entrada intencionais.

## Testes

Fixtures mínimas cobrirão:

- coleta de e-mail válida;
- rejeição de `user_input`;
- rejeição de adapter ausente;
- rejeição de destino inexistente;
- rejeição de UUID duplicado;
- aceitação dos dois envelopes suportados;
- aviso para bloco desconectado;
- rejeição de resíduos `removed: true`.

O JSON v3 deve falhar por modelar a coleta como texto comum sem os adapters; um fixture saneado baseado no padrão corrigido deve passar.

## Fora de Escopo

- Alterar a extensão Chrome.
- Importar integralmente `Sem T_tulo.json` como modelo.
- Inferir IDs de campos personalizados específicos da conta.
- Corrigir automaticamente exports históricos do ManyChat.
