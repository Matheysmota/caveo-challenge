# ADR 003: Abstração e Governança de Bibliotecas Externas

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 13-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | dependências, governança, segurança, ci-cd |

## Contexto e Problema
O uso indiscriminado de bibliotecas de terceiros (packages) cria um acoplamento direto entre a lógica de negócio da aplicação e o código externo. Isso gera diversos riscos:
1.  **Vendor Lock-in:** Dificuldade extrema de substituir uma biblioteca descontinuada se ela estiver importada em 500 arquivos espalhados.
2.  **Inconsistência de Versão:** Risco de diferentes módulos dependerem de comportamentos distintos.
3.  **Poluição de API:** Muitas bibliotecas expõem centenas de métodos, mas o projeto deveria utilizar apenas um subconjunto seguro e aprovado.
4.  **Bloatware:** A inclusão de bibliotecas pesadas sem revisão arquitetural impacta o tamanho final do app (bundle size) e a performance.

## Alternativas Consideradas

### 1. Importação Direta (Padrão de Mercado)
Permitir `import 'package:lib_externa/lib.dart';` em qualquer arquivo.
*   **Pros:** Menor atrito inicial, desenvolvimento rápido.
*   **Cons:** Alto acoplamento, refatoração dolorosa, difícil controle de governança.

### 2. Wrapper Classes (Adapter Pattern)
Criar classes próprias que encapsulam totalmente a lib externa (ex: `MyHttp` que usa `Dio` internamente).
*   **Pros:** Desacoplamento total, facilidade de testes (mocking).
*   **Cons:** Alto custo de manutenção (boilerplate) para mapear todas as funcionalidades necessárias. Pode ser "over-engineering" para libs simples de UI.

### 3. Camada de Abstração via Exports (Barrel Files) - **Opção Escolhida**
Criar uma camada intermediária em `shared/libraries/` que re-exporta apenas os símbolos permitidos das bibliotecas.

## Decisão
Decidimos implementar uma política estrita de **Gerenciamento Centralizado de Dependências**.

1.  **Camada de Abstração:**
    *   Toda biblioteca externa deve ser encapsulada em um arquivo dentro de `packages/shared/lib/libraries/`.
    *   O padrão de nomenclatura será: `[nome_lib]_export.dart`.
    *   Este arquivo utilizará o modificador `show` para expor estritamente o necessário.
    *   *Exemplo:* Para uso de paginação, não importaremos `infinite_scroll_pagination` diretamente nas views. Criaremos `packages/shared/lib/libraries/pagination_export.dart` contendo:
        ```dart
        // packages/shared/lib/libraries/pagination_export.dart
        export 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart' 
          show PagingController, PagedChildBuilderDelegate, PagedListView;
        ```

2.  **Governança de Novos Pacotes:**
    *   A inclusão de qualquer nova dependência no `pubspec.yaml` exige a criação de uma **ADR** justificando a escolha e aprovação via processo de RFC.

3.  **Enforcement via CI/CD (Mecanismo de Allowlist):**
    *   Será implementado um script de validação (`check_imports.sh`) no pipeline.
    *   **Regra de Bloqueio:** O script analisará estaticamente todos os arquivos `.dart` dentro de `app/lib/` (exceto arquivos de teste).
    *   Se encontrar qualquer import que comece com `package:` mas NÃO esteja na **Allowlist** (lista de exceções permitidas), o build falhará.
    *   **Allowlist Inicial:**
        *   `package:flutter/*` (Framework)
        *   `package:dart/*` (Linguagem)
        *   `package:shared/*` (Package compartilhado)
        *   `package:design_system/*` (Módulo interno de componentes)
        *   `package:caveo_challenge/*` (Imports internos do próprio app)
    *   Isso garante que módulos internos como o Design System possam ser consumidos livremente, enquanto dependências de terceiros (http, bloc, provider) sejam estritamente controladas.

## Consequências
*   **Manutenibilidade:** Centraliza o controle de dependências. Se precisarmos aplicar um patch ou restringir funcionalidades de uma lib de UI, fazemos em um único lugar. (Nota: Bibliotecas de infraestrutura crítica, como Networking, seguirão um padrão de abstração mais robusto via Interfaces/Delegates para desacoplamento total, a ser definido em ADR específica).
*   **Segurança:** Limitamos a superfície de ataque e o uso indevido de métodos internos de bibliotecas.
*   **Disciplina:** Aumenta ligeiramente a fricção para adicionar novas libs, o que incentiva o time a pensar duas vezes antes de inflar o projeto ("Slow down to speed up").
*   **Padronização:** Garante que todo o time utilize as mesmas versões e configurações base.
