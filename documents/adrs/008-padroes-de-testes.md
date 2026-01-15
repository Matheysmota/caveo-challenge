# ADR 008: Estratégia e Padrões de Testes Automatizados

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 13-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | quality, testing, unit-tests, mocktail |

## Contexto e Problema
A garantia de qualidade em software é inegociável, mas em projetos com escopo fechado e prazos curtos (como desafios técnicos), é necessário equilibrar a profundidade dos testes com a velocidade de entrega. Precisamos definir quais camadas serão testadas, qual a granularidade desses testes e quais ferramentas/padrões utilizaremos para manter a consistência.

Sem essa definição, corre-se o risco de investir tempo excessivo em testes frágeis (como de integração complexos) ou, pior, entregar um código sem nenhuma garantia de funcionamento além do "caminho feliz" manual.

## Decisão

### 1. Escopo: Testes Unitários Exclusivamente
Decidimos focar 100% dos esforços de automação em **Testes Unitários**.
*   **O que será testado:** 
    *   **Domain:** Entidades (`fromMap`, regras de validação) e UseCases.
    *   **Presentation:** ViewModels (checagem de estado e efeitos colaterais dos Commands) e Widgets de Página principais (smoke tests, renderização de estados).
    *   **Shared/Core:** Utilitários e helpers.
*   **O que NÃO será testado:**
    *   Testes de Integração (drivers reais) e E2E (End-to-End).
    *   **Motivo:** A complexidade de setup e tempo de execução desses testes não se justifica dado o escopo restrito do desafio técnico e o prazo de entrega. A arquitetura desacoplada (ADRs 002 e 004) já garante robustez suficiente.

### 2. Ferramentas e Bibliotecas
*   **Mocking:** Utilizaremos a biblioteca `mocktail` (encapsulada em `shared/libraries/mocktail_export.dart`).
    *   *Por que:* API mais simples, null-safety friendly e sem necessidade de code-generation (ao contrário do `mockito` clássico).

### 3. Padrão de Estrutura: AAA (Arrange, Act, Assert)
Adotaremos exclusivamente o padrão **AAA** para o corpo dos testes.
*   **Arrange:** Prepara o cenário (mocks, instâncias, dados).
*   **Act:** Executa métodos ou ações sob teste.
*   **Assert:** Verifica os resultados e chamadas de verificação.

*Justificativa:* Preferimos AAA ao Gherkin (Given-When-Then) pela objetividade e redução de verbosidade. Em testes unitários técnicos, a separação visual em três blocos é suficiente para compreensão imediata.

### 4. Nomenclatura
Os títulos dos testes devem ser descritivos e seguir o formato:
`should [comportamento esperado] when [condição/cenário]`
*   *Exemplo:* `test('should return Success when repository call succeeds', ...)`

## Consequências
*   **Desenvolvimento Ágil:** Testes unitários rodam em milissegundos, permitindo TDD e feedback loop rápido.
*   **Manutenibilidade:** Mocks via `mocktail` são fáceis de ler e manter.
*   **Cobertura:** Focamos em cobrir regras de negócio e lógica de estado (ViewModel/Commands), onde moram os bugs mais críticos.
