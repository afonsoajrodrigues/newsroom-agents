---
name: lada-request
description: Draft an access-to-information request to a Portuguese public entity under Lei 26/2016 (LADA), with the legal basis, deadlines and the CADA complaint path.
argument-hint: <entity> <documents wanted, one line>
disable-model-invocation: true
---

Draft a formal request in Portuguese to **$0** for the documents described as: **$ARGUMENTS**.

Follow this structure exactly and fill every placeholder from what the reporter gave; ask one question only if the documents are not identifiable enough for the entity to locate them.

```
Assunto: Pedido de acesso a documentos administrativos (Lei n.º 26/2016, de 22 de agosto)

Exmo(a). Senhor(a) [Responsável pelo acesso / Presidente / Diretor(a)] de <ENTIDADE>,

<NOME>, jornalista, portador(a) do cartão de cidadão n.º <NÚMERO>, com contacto <EMAIL/TELEFONE>, vem, ao abrigo do artigo 5.º e seguintes da Lei n.º 26/2016, de 22 de agosto (LADA), requerer o acesso aos seguintes documentos administrativos:

1. <descrição precisa, com datas, referências, números de processo ou contrato se conhecidos>
2. ...

Solicita-se que os documentos sejam disponibilizados em formato eletrónico (preferencialmente no formato original ou em PDF pesquisável), por correio eletrónico, nos termos do artigo 13.º.

Recorda-se que, nos termos do artigo 15.º, a entidade dispõe de 10 dias para comunicar a data, local e modo de consulta, para emitir a reprodução, ou para comunicar as razões, fundamentadas de facto e de direito, de eventual recusa. Nos termos do artigo 6.º, não é exigível a indicação dos motivos do pedido. Caso alguma parte do documento contenha dados pessoais de terceiros, requer-se o acesso parcial com expurgo dessa informação (artigo 6.º, n.º 8).

Com os melhores cumprimentos,
<NOME>
<ÓRGÃO DE COMUNICAÇÃO SOCIAL>
<DATA>
```

After the letter, add a short checklist for the reporter:
- Send by email to the entity's official address and keep the sent copy; note the date in `contacts.md`.
- Deadline: 10 working days from receipt. If refused, partially answered, or silent, file a complaint with CADA (https://www.cada.pt) within 20 days. CADA issues a non-binding opinion; after it, the entity has 10 days to decide.
- If the entity claims the document is not "administrative" (e.g. it is in a judicial file), note that judicial files fall outside LADA and the route is the court or the Ministério Público press office.
- Log the request in `evidence-log.md` as a pending source.
