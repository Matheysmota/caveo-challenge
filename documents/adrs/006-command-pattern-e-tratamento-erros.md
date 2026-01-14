# ADR 006: Padrão de Comandos (Command Pattern) e Tratamento de Erros

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 13-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | arquitetura, state-management, command, error-handling |

## Contexto e Problema
A interface do usuário (UI) frequentemente precisa lidar com o ciclo de vida de operações assíncronas: exibir estado de carregamento, tratar erros e desabilitar botões enquanto uma ação ocorre. Implementar essa lógica de forma imperativa ("toggleando" booleanos `isLoading` e `hasError` em cada Controller) leva a código repetitivo, propenso a falhas e inconsistências de UX.

Além disso, exceções não tratadas nas camadas inferiores (Repository/Data) podem subir silenciosamente e quebrar a aplicação (crash) ou deixar a UI em estado inconsistente se não houver uma estratégia clara de captura.

## Alternativas Consideradas

### 1. Métodos Imperativos em Controllers
A UI chama métodos `void` e observa variáveis booleanas soltas.
*   **Pros:** Simples de entender inicialmente.
*   **Cons:** Boilerplate massivo (repetir `try-catch`, `isLoading=true/false` em todo método). Difícil reutilizar a lógica do botão "desabilitado".

### 2. Command Pattern (Opção Escolhida)
Encapsular ações em objetos que possuem estado próprio (`isExecuting`, `result`, `error`).
*   **Pros:** Separação clara entre "o que fazer" e "como a UI reage". Gestão automática de loading/error. Facilidade para desabilitar widgets (`canExecute`).
*   **Cons:** Curva de aprendizado inicial para quem não conhece o padrão.

## Decisão
1.  **Adoção do Command Pattern:**
    *   As ações do usuário (ex: `carregarProdutos`, `atualizarLista`) serão encapsuladas em objetos `Command`.
    *   Usaremos estritamente a biblioteca **`flutter_command`** (encapsulada em `shared/libraries/command_export.dart`) como implementação do padrão.
    *   **ViewModel (Notifier):** Atuará como "Host" para esses comandos. Ela instancia e expõe os comandos para a View.

2.  **Fluxo de Execução:**
    *   A View (Widget) faz bind direto no Command.
    *   Ex: `onPressed: viewModel.myCommand.execute`.
    *   O Command interage com o **Domain Layer** (UseCases/Repositories).

3.  **Tratamento de Erros (Result Pattern):**
    *   A camada de Domínio e Repositório **NÃO deve lançar exceções** (exceto para erros irrecuperáveis de programação).
    *   Adotaremos o **Result Pattern** utilizando a biblioteca **`result_dart`** (encapsulada em `result_export.dart`).
    *   Os Repositórios sempre retornarão `Result<Success, Failure>`. O Command integrará nativamente com esse retorno, transitando para estado de erro caso receba um `Failure`.

4.  **Injeção de Dependência:**
    *   Utilizaremos o framework **Riverpod** não apenas para gestão de estado, mas como container de **Injeção de Dependência (DI)**.
    *   Repositórios e Services serão providos globalmente via `Provider` e injetados nos ViewModels.

## Consequências
*   **Código de UI Limpo:** Widgets tornam-se reativos e declarativos, apenas "escutando" o estado do comando.
*   **Segurança:** O uso do Result Pattern força o desenvolvedor a considerar o caminho infeliz (erro) em tempo de compilação.
*   **Desacoplamento:** A regra de negócio não sabe que existe um botão "Loading", ela apenas retorna um resultado. O Command traduz isso para a UI.
