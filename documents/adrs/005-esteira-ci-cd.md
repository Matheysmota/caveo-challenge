# ADR 005: Esteira de Integração Contínua (CI/CD) e Quality Gates

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 13-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | devops, ci-cd, qualidade, testes, coverage |

## Contexto e Problema
Manter a qualidade, estabilidade e conformidade arquitetural de um projeto de software torna-se exponencialmente difícil à medida que o time cresce. Processos manuais de revisão de código (Code Review) são fundamentais, mas falíveis para detectar regressões sutis, violações de arquitetura (ex: imports proibidos) ou queda na cobertura de testes.

Precisamos de um sistema automatizado que atue como "porteiro" (Quality Gate), impedindo que códigos que não atendam aos padrões mínimos de qualidade sejam fundidos (merged) na branch principal (`main`).

## Decisão
Decidimos implementar uma esteira de **Integração Contínua (CI)** robusta utilizando **GitHub Actions**. O pipeline será acionado a cada **Pull Request** direcionado à `main` e consistirá nos seguintes estágios bloqueantes:

### 1. Lint e Formatação (Sanity Check)
*   **Ação:** Executar `flutter analyze` e `dart format --output=none --set-exit-if-changed .`.
*   **Objetivo:** Garantir que o código siga estritamente as regras de lint do Dart e o estilo de formatação padrão do projeto antes de prosseguir.
*   **Política:** Zero warnings permitidos.

### 2. Governança de Arquitetura (Compliance)
*   **Ação:** Executar script customizado `scripts/check_imports.sh`.
*   **Objetivo:** Verificar violações da **ADR 003**. O script falhará se detectar imports diretos de pacotes externos fora da camada `shared/libraries` ou `infrastructure/driver`.
*   **Exceção:** Pacotes listados na **Allowlist** (ex: `design_system`, `flutter`).

### 3. Testes e Cobertura (Quality Assurance)
*   **Ação:** Executar testes unitários e de widget.
*   **Regra de Cobertura:** Utilizaremos ferramenta para analisar o diff do PR (ex: `coverage` gem ou scripts customizados).
*   **Critério de Aceite:** A cobertura de código dos **arquivos modificados ou criados** no PR deve ser **> 80%**. Não exigiremos 80% do projeto legado inteiro de imediato, mas garantimos que "código novo é código testado" (Boy Scout Rule).

### 4. Build de Verificação (Build Health)
*   **Ação:** Executar `flutter build apk --debug --no-pub` (ou target similar).
*   **Objetivo:** Garantir que o projeto compila corretamente e que não há dependências quebradas ou conflitos de recursos que passariam despercebidos apenas com análise estática.

### Status Badge
O arquivo `README.md` conterá uma "Health Check Badge" vinculada ao status do workflow da `main`, proporcionando visibilidade imediata sobre a saúde do projeto.

## Consequências
*   **Segurança no Merge:** Redução drástica da chance de quebrar a build na `main`.
*   **Cultura de Testes:** A obrigatoriedade de 80% de coverage no diff força os desenvolvedores a escreverem testes junto com a feature, mudando a mentalidade de "testar depois" para "testar durante".
*   **Feedback Rápido:** O desenvolvedor descobre erros de arquitetura minutos após o push, sem esperar pelo code review humano.
*   **Custo de CI:** O pipeline consome minutos de build; otimizações (caching de dependências) serão necessárias para não impactar o lead time.
