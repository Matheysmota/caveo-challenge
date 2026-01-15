# ADR 005: Esteira de Integração Contínua (CI/CD) e Quality Gates

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 13-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | devops, ci-cd, qualidade, testes, coverage |

## Contexto e Problema
Manter a qualidade, estabilidade e conformidade arquitetural de um projeto de software torna-se exponencialmente difícil à medida que o time cresce. Processos manuais de revisão de código (Code Review) são fundamentais, mas falíveis para detectar regressões sutis, violações de arquitetura (ex: imports proibidos) ou queda na cobertura de testes.
Precisamos de um sistema automatizado que atue como "porteiro" (Quality Gate), impedindo que códigos que não atendam aos padrões mínimos de qualidade sejam fundidos (merged) nas branches críticas (`main` e `develop`).

## Decisão
Decidimos implementar uma esteira de **Integração Contínua (CI)** robusta utilizando **GitHub Actions**. O pipeline será acionado a cada **Pull Request** e consistirá nos seguintes estágios bloqueantes:

### 1. Lint e Formatação (Sanity Check)
*   **Ação:** Executar `flutter analyze` e `dart format --output=none --set-exit-if-changed .`.
*   **Objetivo:** Garantir que o código siga estritamente as regras de lint do Dart e o estilo de formatação padrão do projeto antes de prosseguir.
*   **Política:** Zero warnings permitidos.

### 2. Governança de Arquitetura (Compliance)
*   **Ação:** Executar script customizado `scripts/check_imports.sh`.
*   **Objetivo:** Verificar violações da **ADR 003**. O script validará imports em todos os packages do monorepo (`app`, `shared`, `dori`), cada um com sua própria allowlist de dependências permitidas.
*   **Escopo:** O script analisa todos os arquivos `.dart` em `*/lib/` de cada package.
*   **Exceção:** Pacotes listados na **Allowlist** específica de cada package (consulte ADR 003 para detalhes).

### 3. Testes e Cobertura (Quality Assurance)
*   **Ação:** Executar testes unitários e de widget.
*   **Regra de Cobertura:** Utilizaremos ferramenta para analisar o diff do PR (ex: `coverage` gem ou scripts customizados).
*   **Critério de Aceite:** A cobertura de código dos **arquivos modificados ou criados** no PR deve ser **> 80%**. Não exigiremos 80% do projeto legado inteiro de imediato, mas garantimos que "código novo é código testado" (Boy Scout Rule).

### 4. Build de Verificação (Build Health)
*   **Ação:** Executar `flutter build apk --debug --no-pub` (ou target similar).
*   **Objetivo:** Garantir que o projeto compila corretamente e que não há dependências quebradas ou conflitos de recursos que passariam despercebidos apenas com análise estática.

### 5. Proteção de Branch (Enforcement)
Para garantir que as políticas acima não sejam contornadas, aplicaremos **Branch Protection Rules** estritas no repositório:
*   **Target Branches:** `main` e `develop`.
*   **Require Pull Request reviews:** Obrigatório. Ninguém commita direto.
*   **Require status checks to pass:** O job de CI definido acima **deve passar** para que o botão de "Merge" seja habilitado.
*   **Include administrators:** Regras aplicam-se a todos, inclusive administradores.

### Status Badge
O arquivo `README.md` conterá uma "Health Check Badge" vinculada ao status do workflow da `main`, proporcionando visibilidade imediata sobre a saúde do projeto.

## Consequências
*   **Segurança no Merge:** Redução drástica da chance de quebrar a build na `main`.
*   **Cultura de Testes:** A obrigatoriedade de 80% de coverage no diff força os desenvolvedores a escreverem testes junto com a feature, mudando a mentalidade de "testar depois" para "testar durante".
*   **Feedback Rápido:** O desenvolvedor descobre erros de arquitetura minutos após o push, sem esperar pelo code review humano.
*   **Custo de CI:** O pipeline consome minutos de build; otimizações (caching de dependências) serão necessárias para não impactar o lead time.
