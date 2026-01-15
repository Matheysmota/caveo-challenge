# ADR 001: Documentar decisões arquiteturais (ADRs) em Markdown

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 13-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | documentação, processos, arquitetura |

## Contexto e Problema
Projetos de software envolvem uma série de decisões arquiteturais significativas (escolha de frameworks, padrões, estruturas, bibliotecas) que moldam o produto ao longo do tempo. Frequentemente, o contexto e as razões por trás dessas decisões se perdem, levando a:
- Dificuldade para novos membros entenderem o "porquê" de certas escolhas.
- Re-discussão de decisões já tomadas.
- Falta de visibilidade sobre as consequências (trade-offs) aceitas.

Precisamos de um método leve, versionável e próximo ao código para registrar essas decisões.

## Alternativas Consideradas

### 1. Documentação em Wiki/Confluence externo
Manter as decisões em uma ferramenta externa.
*   **Pros:** Fácil edição para não-técnicos.
*   **Cons:** Tende a desatualizar, fica longe do código e do fluxo de trabalho dos desenvolvedores, difícil de versionar junto com a evolução do software.

### 2. Não documentar formalmente
Confiar na memória do time e no histórico de commits.
*   **Pros:** Zero overhead inicial.
*   **Cons:** Altíssimo risco de perda de conhecimento e dívida técnica por falta de alinhamento.

### 3. Architecture Decision Records (ADRs) em Markdown no repositório
Manter documentação estruturada dentro do repositório, próxima ao código.
*   **Pros:** Versionamento junto com o código (Git), Code Review nas decisões, fácil acesso para devs, suporte nativo a Markdown.
*   **Cons:** Requer disciplina para manter atualizado e engenheiro conscientes de que essa é uma responsabilidade de todos.

## Decisão
Adotaremos o uso de **Architecture Decision Records (ADRs)** escritos em **Markdown**, armazenados na pasta `documents/adrs/` do repositório.

Seguiremos um template padrão contendo: Título, Metadados (Status, Data, Decisores), Contexto, Alternativas, Decisão e Consequências.

## Consequências
*   Todas as decisões arquiteturais importantes serão registradas e preservadas.
*   Facilita o onboarding de novos engenheiros.
*   Review de arquitetura torna-se parte do processo de Code Review (PRs).
*   Demonstra maturidade técnica e preocupação com a longevidade do projeto.

## Futuro
Para escalar o processo de decisão e democratizar a arquitetura na companhia, implementaremos um fluxo de **RFC (Request for Comments)**.
Antes de uma ADR ser oficializada e mergeada na `main`, ela nascerá como uma proposta (RFC) aberta para discussão.
Isso permitirá que engenheiros de diferentes times contribuam, identifiquem riscos não mapeados e refinem a solução antes que ela se torne um padrão.
