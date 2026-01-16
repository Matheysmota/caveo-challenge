# ADR 002: Estrutura de Pastas e Modularização do Projeto

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito (Revisado) |
| **Data** | 14-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | arquitetura, estrutura, modularização, monorepo |

## Contexto e Problema

Precisamos definir a organização fundamental do código fonte do projeto Flutter. A estrutura de pastas dita como os módulos se comunicam e como a aplicação escala.

O documento de requisitos do challenge (`documents/requirements-challenge.md`) sugere uma estrutura baseada em camadas técnicas (*Package by Layer*):

```
lib/
├── app/
├── application/
├── domain/
├── infrastructure/
├── presentation/
└── shared/
```

Essa abordagem é válida para projetos pequenos, mas apresenta limitações:
1.  **Raiz do repositório poluída:** Mistura arquivos de configuração do Flutter com documentação e scripts.
2.  **Baixa coesão de domínio:** Arquivos de funcionalidades distintas residem lado a lado.
3.  **Dificuldade de modularização:** Código compartilhável (`shared`) fica acoplado ao app.

## Alternativas Consideradas

### 1. Package by Layer Puro (Estrutura do Requirements)
Manter tudo em `lib/` com camadas globais.
*   **Pros:** Simplicidade, alinhamento literal com o documento de requisitos.
*   **Cons:** Não escala, `shared` não é reutilizável, raiz do repositório desorganizada.

### 2. Package by Feature (Features como Packages Externos)
Cada feature (`splash`, `product`) seria um package separado em `/packages/features/`.
*   **Pros:** Máxima modularização, build times otimizados.
*   **Cons:** Over-engineering para o escopo do challenge (2 telas), complexidade de setup.

### 3. Estrutura Híbrida (Monorepo Modularizado) - **Opção Escolhida**
Combinar o melhor das abordagens:
*   **App Shell** em `/app/` — projeto Flutter que orquestra o app.
*   **Features internas** em `/app/lib/features/` — cada feature encapsula suas camadas (Clean Architecture vertical).
*   **Packages externos** em `/packages/` — apenas código genuinamente cross-cutting (`shared`, `dori`).

## Decisão

Adotamos a **Estrutura Híbrida (Opção 3)**, que respeita a essência do requisito (Clean Architecture com camadas) enquanto aplica boas práticas de modularização.

### Estrutura Final do Repositório

```
/ (root)
├── app/                          # App Shell (Projeto Flutter principal)
│   ├── lib/
│   │   ├── main.dart             # Ponto de entrada (bootstrap)
│   │   ├── app/                  # Configuração do App
│   │   │   ├── app_widget.dart   # MaterialApp, Theme, Router
│   │   │   ├── di/               # Dependency Injection (Providers Riverpod)
│   │   │   └── router/           # Definição de rotas (GoRouter)
│   │   └── features/             # Features do App (Package by Feature interno)
│   │       ├── splash/
│   │       │   └── presentation/
│   │       │       ├── view_models/  # Estados e ViewModels (Riverpod Notifiers)
│   │       │       └── widgets/      # Widgets específicos da feature
│   │       └── products/
│   │           ├── domain/           # Entities, Repository Interfaces
│   │           ├── infrastructure/   # Repository Impl, Data Sources, Models
│   │           └── presentation/
│   │               ├── view_models/  # Estados e ViewModels (Riverpod Notifiers)
│   │               └── widgets/      # Widgets específicos da feature
│   ├── test/                     # Testes do App
│   └── pubspec.yaml              # Dependências (inclui packages locais)
│
├── packages/                     # Módulos isolados e reutilizáveis
│   ├── shared/                   # Núcleo compartilhado
│   │   ├── lib/
│   │   │   ├── drivers/          # Abstrações de infraestrutura
│   │   │   ├── libraries/        # Exports de libs externas (Governança ADR 003)
│   │   │   ├── utils/            # Utilitários (formatters, extensions)
│   │   │   └── shared.dart       # Barrel file
│   │   └── pubspec.yaml
│   └── dori/                     # 🐠 Design System Dori
│       ├── lib/
│       │   ├── tokens/           # Cores, tipografia, espaçamentos
│       │   ├── atoms/            # Widgets primitivos
│       │   ├── molecules/        # Widgets compostos
│       │   └── dori.dart
│       └── pubspec.yaml
│
├── documents/                    # Documentação e ADRs
│   ├── adrs/
│   └── functional-specs.md
│
└── scripts/                      # Automação e CI
```

### Justificativas da Estrutura

| Diretório | Justificativa |
|-----------|---------------|
| `/app/` | Isola o projeto Flutter da raiz, mantendo-a limpa para docs e scripts. |
| `/app/lib/app/` | Configurações globais do app (rotas, tema, DI bootstrap). Não é "core" exportável. |
| `/app/lib/features/` | Cada feature é autocontida com suas camadas. Facilita navegação e ownership. |
| `/packages/shared/` | Código agnóstico de feature: Result, Command, exports de libs. Pode ser usado em outros apps. |
| `/packages/dori/` | 🐠 Design System Dori. UI agnóstica de lógica. Tokens e componentes reutilizáveis. |

### Regras de Dependência

```
┌─────────────────────────────────────────────────────────┐
│                         app/                            │
│  ┌─────────────────────────────────────────────────┐   │
│  │              features/product/                   │   │
│  │  presentation → application → domain            │   │
│  │       │              │            │             │   │
│  │       └──────────────┴────────────┘             │   │
│  │                      │                          │   │
│  │              infrastructure                      │   │
│  └─────────────────────────────────────────────────┘   │
│                         │                              │
│                         ▼                              │
│              ┌─────────────────────┐                   │
│              │  packages/shared    │                   │
│              │  packages/dori      │                   │
│              └─────────────────────┘                   │
└─────────────────────────────────────────────────────────┘
```

*   **Features** dependem de `shared` e `dori`.
*   **Shared** não depende de nenhum outro package do projeto.
*   **Dori** pode depender apenas de `shared` (para utils).
*   **Features não podem depender de outras features** (isolamento).

## Consequências

*   **Positivo:** Raiz do repositório limpa e profissional.
*   **Positivo:** Features isoladas facilitam manutenção e testes.
*   **Positivo:** `shared` e `dori` são reutilizáveis em outros projetos.
*   **Positivo:** Respeita a essência do requisito (Clean Arch com camadas) sem ser literal.
*   **Trade-off:** Requer gerenciamento de `pubspec.yaml` em múltiplos diretórios.
*   **Mitigação:** Usamos `path` dependencies para desenvolvimento local, simplificando o workflow.

## Referências

- [System Design](../system_design.md) — Visão consolidada da arquitetura
- [ADR 003](003-abstracao-e-governanca-bibliotecas.md) — Governança de dependências entre packages
