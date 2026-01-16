# 🏗️ System Design — Caveo Flutter Challenge

> Documento de arquitetura que consolida decisões técnicas, fluxos de comunicação entre componentes e trade-offs do sistema.

**Última atualização:** 16-01-2026  
**Status:** Em evolução

---

## 📖 Sumário

1. [Visão Geral](#visão-geral)
2. [Princípios Arquiteturais](#princípios-arquiteturais)
3. [Estrutura do Monorepo](#estrutura-do-monorepo)
4. [Diagrama de Componentes](#diagrama-de-componentes)
5. [Fluxo de Dados](#fluxo-de-dados)
6. [Camadas da Arquitetura](#camadas-da-arquitetura)
7. [Comunicação entre Componentes](#comunicação-entre-componentes)
8. [Estratégias de Resiliência](#estratégias-de-resiliência)
9. [Trade-offs e Decisões](#trade-offs-e-decisões)
10. [Dores e Problemas Conhecidos](#dores-e-problemas-conhecidos)
11. [Referências](#referências)

---

## Visão Geral

O Caveo Flutter Challenge é um aplicativo de catálogo de produtos que demonstra boas práticas de arquitetura Flutter em um cenário realista de e-commerce.

### Requisitos Chave

| Requisito | Solução | ADR |
|-----------|---------|-----|
| Modo offline | Cache local com TTL + fallback automático | [ADR 007](adrs/007-abstracao-cache-local.md) |
| UI consistente | Design System Dori (Atomic Design) | [ADR 009](adrs/009-design-system-dori.md) |
| Testabilidade | Abstrações + Result Pattern + DI via Riverpod | [ADR 006](adrs/006-command-pattern-e-tratamento-erros.md) |
| Governança | CI/CD com validação de imports por package | [ADR 003](adrs/003-abstracao-e-governanca-bibliotecas.md) |
| Desacoplamento de rede | ApiDataSourceDelegate abstraction | [ADR 004](adrs/004-camada-de-abstracao-rede.md) |

### Escopo Funcional

```
┌──────────────┐     ┌─────────────────┐     ┌──────────────────┐
│    Splash    │ ──► │  Product List   │ ──► │ Product Details  │
│   Screen     │     │  (Feed/Grid)    │     │    (Detalhes)    │
└──────────────┘     └─────────────────┘     └──────────────────┘
        │                   │
        ▼                   ▼
  ┌───────────┐      ┌─────────────┐
  │  Error    │      │  Banners    │
  │  Screen   │      │ (Offline/   │
  │           │      │  Stale)     │
  └───────────┘      └─────────────┘
```

> Detalhes completos em [functional-specs.md](functional-specs.md)

---

## Princípios Arquiteturais

### 1. Dependency Rule (Clean Architecture)

> "Dependências sempre apontam para dentro" — Uncle Bob

```
    ┌─────────────────────────────────────┐
    │         PRESENTATION (UI)           │  ← Widgets, ViewModels
    │    ┌───────────────────────────┐    │
    │    │       APPLICATION         │    │  ← UseCases, Commands
    │    │    ┌─────────────────┐    │    │
    │    │    │     DOMAIN      │    │    │  ← Entities, Interfaces
    │    │    └─────────────────┘    │    │
    │    └───────────────────────────┘    │
    └─────────────────────────────────────┘
                      ▲
    ┌─────────────────┴───────────────────┐
    │          INFRASTRUCTURE             │  ← Repositories Impl, Data Sources
    └─────────────────────────────────────┘
```

**Regra:** Camadas internas (Domain) não conhecem camadas externas (UI, Infra).

### 2. Inversion of Control (IoC)

- Repositórios dependem de **interfaces** (`ApiDataSourceDelegate`, `LocalCacheSource`)
- Implementações concretas são injetadas via **Riverpod**
- Facilita testes unitários com mocks simples

> Detalhes em [ADR 004](adrs/004-camada-de-abstracao-rede.md) e [ADR 007](adrs/007-abstracao-cache-local.md)

### 3. Fail-Safe by Design

- **Result Pattern:** Métodos retornam `Result<Success, Failure>`, nunca lançam exceções
- **Graceful Degradation:** Se API falha, usa cache; se cache falha, mostra erro amigável
- **Defensive UI:** Commands gerenciam loading/error automaticamente

> Detalhes em [ADR 006](adrs/006-command-pattern-e-tratamento-erros.md)

### 4. Governance First

- **Allowlists por package:** CI bloqueia imports não autorizados
- **Barrel files:** Bibliotecas externas re-exportadas com `show` explícito
- **Zero tolerance:** Pipeline falha em qualquer violação

> Detalhes em [ADR 003](adrs/003-abstracao-e-governanca-bibliotecas.md) e [ADR 005](adrs/005-esteira-ci-cd.md)

---

## Estrutura do Monorepo

> Detalhes completos em [ADR 002](adrs/002-estrutura-de-pastas-padrao.md)

### Diagrama de Packages

```
caveo-challenge/
├── app/                          # 📱 App Shell (Flutter Project)
│   └── lib/
│       ├── main.dart             # Bootstrap + DI setup
│       ├── app/                  # Configuração global
│       │   ├── app_widget.dart   # MaterialApp + Routing
│       │   ├── di/               # Riverpod providers (DI)
│       │   └── router/           # GoRouter configuration
│       └── features/             # Feature modules (vertical slices)
│           ├── splash/
│           │   └── presentation/
│           │       ├── view_models/  # Estados e ViewModels
│           │       └── widgets/      # Widgets específicos
│           └── products/
│               ├── domain/           # Entities, Repository Interfaces
│               ├── infrastructure/   # Repositories, Data Sources, Models
│               └── presentation/
│                   ├── view_models/  # Estados e ViewModels
│                   └── widgets/      # Widgets específicos
│
├── packages/
│   ├── shared/                   # 🔧 Core utilities + Abstractions
│   │   └── lib/
│   │       ├── drivers/          # Interfaces públicas
│   │       │   ├── local_cache/  # LocalCacheSource
│   │       │   ├── connectivity/ # ConnectivityObserver
│   │       │   ├── network/      # ApiDataSourceDelegate
│   │       │   └── sync_store/   # SyncStore
│   │       ├── libraries/        # Re-exports governados
│   │       ├── src/              # Implementações privadas
│   │       └── utils/            # Extensions, formatters
│   │
│   └── dori/                     # 🐠 Design System
│       └── lib/
│           ├── tokens/           # Colors, Typography, Spacing
│           ├── atoms/            # DoriText, DoriIcon, DoriBadge
│           ├── molecules/        # DoriSearchBar, DoriThemeToggle
│           └── organisms/        # DoriProductCard, DoriAppBar
│
├── documents/                    # 📚 Documentação
│   ├── adrs/                     # Architecture Decision Records
│   ├── functional-specs.md       # Especificações funcionais
│   ├── tokens-spec.md            # Design tokens
│   └── system_design.md          # Este documento
│
└── scripts/                      # 🔨 Automação
    └── check_imports.sh          # Governança de imports
```

### Regras de Dependência entre Packages

```
                    ┌─────────────────────┐
                    │        app/         │
                    │   (Flutter Shell)   │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
              ▼                ▼                ▼
       ┌────────────┐   ┌────────────┐   ┌────────────┐
       │  shared/   │   │   dori/    │   │ (external) │
       │  (Core)    │   │   (UI)     │   │  via libs/ │
       └────────────┘   └─────┬──────┘   └────────────┘
              │               │
              │               │ (dori pode usar shared/utils)
              └───────────────┘
```

| From → To | Permitido? | Justificativa |
|-----------|------------|---------------|
| `app` → `shared` | ✅ | App consome abstrações e utils |
| `app` → `dori` | ✅ | App usa Design System |
| `app` → `package:dio` | ❌ | Violação! Usar via shared/libraries |
| `shared` → `dori` | ❌ | Shared não deve ter dependência de UI |
| `dori` → `shared` | ⚠️ | Apenas utils (não drivers) |
| `feature_a` → `feature_b` | ❌ | Features são isoladas |

---

## Diagrama de Componentes

### Visão Macro (Runtime)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                    APP                                       │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                         PRESENTATION LAYER                            │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │  │
│  │  │  SplashPage │  │ProductList  │  │ProductDetail│  │  ErrorPage  │  │  │
│  │  │             │  │   Page      │  │    Page     │  │             │  │  │
│  │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └─────────────┘  │  │
│  │         │                │                │                          │  │
│  │         └────────────────┼────────────────┘                          │  │
│  │                          ▼                                           │  │
│  │  ┌───────────────────────────────────────────────────────────────┐  │  │
│  │  │                    VIEW MODELS (Notifiers)                    │  │  │
│  │  │  ┌─────────────────────┐  ┌─────────────────────────────┐    │  │  │
│  │  │  │ SplashViewModel     │  │ ProductListViewModel         │    │  │  │
│  │  │  │  • initCommand      │  │  • fetchProductsCommand      │    │  │  │
│  │  │  └─────────┬───────────┘  │  • loadNextPageCommand       │    │  │  │
│  │  │            │              │  • searchCommand             │    │  │  │
│  │  │            │              └─────────────┬─────────────────┘    │  │  │
│  │  └────────────┼────────────────────────────┼──────────────────────┘  │  │
│  │               │                            │                          │  │
│  └───────────────┼────────────────────────────┼──────────────────────────┘  │
│                  │                            │                              │
│  ┌───────────────┼────────────────────────────┼──────────────────────────┐  │
│  │               │      APPLICATION LAYER     │                          │  │
│  │               ▼                            ▼                          │  │
│  │  ┌─────────────────────┐  ┌─────────────────────────────┐            │  │
│  │  │  InitAppUseCase     │  │  GetProductsUseCase          │            │  │
│  │  │  (orchestrates      │  │  (fetch + cache + fallback)  │            │  │
│  │  │   startup flow)     │  └─────────────┬─────────────────┘            │  │
│  │  └─────────┬───────────┘                │                            │  │
│  │            │                            │                            │  │
│  └────────────┼────────────────────────────┼────────────────────────────┘  │
│               │                            │                                │
│  ┌────────────┼────────────────────────────┼────────────────────────────┐  │
│  │            │        DOMAIN LAYER        │                            │  │
│  │            ▼                            ▼                            │  │
│  │  ┌─────────────────────┐  ┌─────────────────────────────┐            │  │
│  │  │   Product Entity    │  │  IProductRepository         │            │  │
│  │  │   (pure model)      │  │  (interface/contract)       │            │  │
│  │  └─────────────────────┘  └─────────────┬─────────────────┘            │  │
│  │                                         │                            │  │
│  └─────────────────────────────────────────┼────────────────────────────┘  │
│                                            │                                │
│  ┌─────────────────────────────────────────┼────────────────────────────┐  │
│  │                INFRASTRUCTURE LAYER     │                            │  │
│  │                                         ▼                            │  │
│  │  ┌─────────────────────────────────────────────────────────────┐    │  │
│  │  │                   ProductRepository                          │    │  │
│  │  │   implements IProductRepository                              │    │  │
│  │  │   depends on: ApiDataSourceDelegate, LocalCacheSource        │    │  │
│  │  └─────────────────────────┬───────────────────┬─────────────────┘    │  │
│  │                            │                   │                      │  │
│  └────────────────────────────┼───────────────────┼──────────────────────┘  │
│                               │                   │                          │
└───────────────────────────────┼───────────────────┼──────────────────────────┘
                                │                   │
┌───────────────────────────────┼───────────────────┼──────────────────────────┐
│                     SHARED PACKAGE                │                          │
│  ┌────────────────────────────┼───────────────────┼──────────────────────┐  │
│  │                 DRIVERS (Abstractions)         │                      │  │
│  │                            ▼                   ▼                      │  │
│  │  ┌─────────────────────────────┐  ┌─────────────────────────────┐    │  │
│  │  │   ApiDataSourceDelegate     │  │    LocalCacheSource         │    │  │
│  │  │   (interface)               │  │    (interface)              │    │  │
│  │  └──────────────┬──────────────┘  └──────────────┬──────────────┘    │  │
│  │                 │                                │                    │  │
│  └─────────────────┼────────────────────────────────┼────────────────────┘  │
│                    │                                │                        │
│  ┌─────────────────┼────────────────────────────────┼────────────────────┐  │
│  │            src/ (Private Implementations)        │                    │  │
│  │                 ▼                                ▼                    │  │
│  │  ┌─────────────────────────────┐  ┌─────────────────────────────┐    │  │
│  │  │ DioApiDataSourceDelegate    │  │ SharedPreferencesLocal      │    │  │
│  │  │ (uses package:dio)          │  │ CacheSource                 │    │  │
│  │  └──────────────┬──────────────┘  │ (uses shared_preferences)   │    │  │
│  │                 │                 └─────────────────────────────┘    │  │
│  └─────────────────┼────────────────────────────────────────────────────┘  │
│                    │                                                        │
│  ┌─────────────────┼────────────────────────────────────────────────────┐  │
│  │   ConnectivityObserver                                               │  │
│  │                 ▼                                                    │  │
│  │  ┌─────────────────────────────┐                                    │  │
│  │  │ ConnectivityPlusObserver    │                                    │  │
│  │  │ (uses connectivity_plus)    │                                    │  │
│  │  └─────────────────────────────┘                                    │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Fluxo de Dados

### Cenário 1: Splash → Inicialização com Sucesso (Online)

```
┌─────────┐     ┌──────────────┐     ┌──────────────┐     ┌───────────────┐
│  User   │     │ SplashPage   │     │ InitUseCase  │     │ ProductRepo   │
└────┬────┘     └──────┬───────┘     └──────┬───────┘     └───────┬───────┘
     │                 │                    │                     │
     │  [App Launch]   │                    │                     │
     │────────────────►│                    │                     │
     │                 │                    │                     │
     │                 │  execute()         │                     │
     │                 │───────────────────►│                     │
     │                 │                    │                     │
     │                 │                    │  getProducts(page:1)│
     │                 │                    │────────────────────►│
     │                 │                    │                     │
     │                 │                    │                     │ ┌────────────┐
     │                 │                    │                     │►│   API      │
     │                 │                    │                     │ │ (FakeStore)│
     │                 │                    │                     │ └─────┬──────┘
     │                 │                    │                     │       │
     │                 │                    │                     │◄──────┘
     │                 │                    │                     │ 200 OK
     │                 │                    │                     │
     │                 │                    │                     │ ┌────────────┐
     │                 │                    │                     │►│LocalCache  │
     │                 │                    │                     │ │(save w/TTL)│
     │                 │                    │                     │ └────────────┘
     │                 │                    │                     │
     │                 │                    │◄────────────────────│
     │                 │                    │   Success([Product])│
     │                 │◄───────────────────│                     │
     │                 │   Result.success   │                     │
     │                 │                    │                     │
     │◄────────────────│                    │                     │
     │  Navigate to    │                    │                     │
     │  ProductList    │                    │                     │
```

### Cenário 2: Splash → Fallback para Cache (API Fail)

```
┌─────────┐     ┌──────────────┐     ┌──────────────┐     ┌───────────────┐
│  User   │     │ SplashPage   │     │ InitUseCase  │     │ ProductRepo   │
└────┬────┘     └──────┬───────┘     └──────┬───────┘     └───────┬───────┘
     │                 │                    │                     │
     │  [App Launch]   │                    │                     │
     │────────────────►│                    │                     │
     │                 │  execute()         │                     │
     │                 │───────────────────►│                     │
     │                 │                    │  getProducts(page:1)│
     │                 │                    │────────────────────►│
     │                 │                    │                     │
     │                 │                    │                     │ ┌────────────┐
     │                 │                    │                     │►│   API      │
     │                 │                    │                     │ │ (timeout)  │
     │                 │                    │                     │ └─────┬──────┘
     │                 │                    │                     │       │
     │                 │                    │                     │◄──────┘
     │                 │                    │                     │ ❌ Error
     │                 │                    │                     │
     │                 │                    │                     │ ┌────────────┐
     │                 │                    │                     │►│LocalCache  │
     │                 │                    │                     │ │ (getModel) │
     │                 │                    │                     │ └─────┬──────┘
     │                 │                    │                     │       │
     │                 │                    │                     │◄──────┘
     │                 │                    │                     │ ✅ Cache Hit
     │                 │                    │                     │ (not expired)
     │                 │                    │◄────────────────────│
     │                 │                    │   Success([Product])│
     │                 │                    │   + isStale: true   │
     │                 │◄───────────────────│                     │
     │                 │   Result.success   │                     │
     │◄────────────────│                    │                     │
     │  Navigate to    │                    │                     │
     │  ProductList    │                    │                     │
     │  (show stale    │                    │                     │
     │   banner)       │                    │                     │
```

### Cenário 3: Error Screen (Sem API + Sem Cache)

```
┌─────────┐     ┌──────────────┐     ┌──────────────┐     ┌───────────────┐
│  User   │     │ SplashPage   │     │ InitUseCase  │     │ ProductRepo   │
└────┬────┘     └──────┬───────┘     └──────┬───────┘     └───────┬───────┘
     │                 │                    │                     │
     │  [App Launch]   │                    │                     │
     │────────────────►│                    │                     │
     │                 │  execute()         │                     │
     │                 │───────────────────►│                     │
     │                 │                    │  getProducts(page:1)│
     │                 │                    │────────────────────►│
     │                 │                    │                     │
     │                 │                    │                     │ API: ❌
     │                 │                    │                     │ Cache: ❌ (miss)
     │                 │                    │                     │
     │                 │                    │◄────────────────────│
     │                 │                    │   Failure(NoData)   │
     │                 │◄───────────────────│                     │
     │                 │   Result.failure   │                     │
     │◄────────────────│                    │                     │
     │  Navigate to    │                    │                     │
     │  ErrorScreen    │                    │                     │
```

---

## Camadas da Arquitetura

### Presentation Layer

**Responsabilidade:** Renderizar UI e capturar interações do usuário.

| Componente | Função |
|------------|--------|
| **Pages** | Widgets de tela completa (Scaffold, AppBar) |
| **Widgets** | Componentes reutilizáveis específicos da feature |
| **ViewModels** | Hospedam Commands, expõem estado para UI |

**Regras:**
- ViewModels **não importam** widgets Flutter (exceto `ChangeNotifier`)
- Pages **não fazem** chamadas diretas a repositórios
- Toda ação do usuário passa por um **Command**

### Application Layer

**Responsabilidade:** Orquestrar casos de uso, coordenar múltiplos repositórios.

| Componente | Função |
|------------|--------|
| **UseCases** | Encapsulam regras de negócio específicas |
| **Commands** | Gerenciam ciclo de vida de operações async |
| **DTOs** | Objetos de transferência entre camadas |

**Regras:**
- UseCases retornam `Result<Success, Failure>`
- UseCases podem chamar **múltiplos repositórios**
- UseCases **não conhecem** UI ou persistência concreta

### Domain Layer

**Responsabilidade:** Definir contratos e modelos de negócio puros.

| Componente | Função |
|------------|--------|
| **Entities** | Modelos imutáveis que representam conceitos de negócio |
| **Repository Interfaces** | Contratos para acesso a dados |
| **Value Objects** | Tipos com validação embutida (ex: `Email`, `Price`) |

**Regras:**
- **Zero dependências** de frameworks ou bibliotecas externas
- Entities são **imutáveis** (usam `Equatable`)
- Interfaces definem **o quê**, não **como**

### Infrastructure Layer

**Responsabilidade:** Implementar contratos com tecnologias concretas.

| Componente | Função |
|------------|--------|
| **Repositories (Impl)** | Implementam interfaces de Domain |
| **Data Sources** | Abstrações para fontes de dados (API, Cache) |
| **Mappers** | Convertem DTOs de API para Entities |

**Regras:**
- Repositories dependem de **interfaces** (`ApiDataSourceDelegate`, `LocalCacheSource`)
- Repositories **nunca** importam `package:dio` ou `package:shared_preferences`
- Tratamento de erros **aqui**, convertendo para `Failure` types

---

## Comunicação entre Componentes

### Injeção de Dependência (Riverpod)

```dart
// providers/product_providers.dart

final localCacheSourceProvider = FutureProvider<LocalCacheSource>((ref) async {
  return SharedPreferencesLocalCacheSource.create();
});

final connectivityObserverProvider = Provider<ConnectivityObserver>((ref) {
  return ConnectivityPlusObserver();
});

final productRepositoryProvider = Provider<IProductRepository>((ref) {
  final api = ref.watch(apiDataSourceProvider);
  final cache = ref.watch(localCacheSourceProvider).value!;
  return ProductRepository(api: api, cache: cache);
});

final productListViewModelProvider = ChangeNotifierProvider((ref) {
  final repository = ref.watch(productRepositoryProvider);
  final connectivity = ref.watch(connectivityObserverProvider);
  return ProductListViewModel(repository, connectivity);
});
```

### Command Pattern

> Detalhes em [ADR 006](adrs/006-command-pattern-e-tratamento-erros.md)

```dart
// product_list_view_model.dart

class ProductListViewModel extends ChangeNotifier {
  late final Command0<List<Product>> fetchProductsCommand;
  late final Command0<void> loadNextPageCommand;
  late final Command1<List<Product>, String> searchCommand;
  
  ProductListViewModel(this._repository, this._connectivity) {
    fetchProductsCommand = Command0(_fetchProducts);
    loadNextPageCommand = Command0(_loadNextPage);
    searchCommand = Command1(_search);
  }
  
  Future<Result<List<Product>>> _fetchProducts() async {
    return _repository.getProducts(page: _currentPage);
  }
}
```

### Result Pattern

> Detalhes em [ADR 006](adrs/006-command-pattern-e-tratamento-erros.md)

```dart
// product_repository.dart

@override
Future<Result<List<Product>, ProductFailure>> getProducts({int page = 1}) async {
  try {
    final response = await _api.get('/products', query: {'page': page});
    final products = _parseProducts(response);
    await _cacheProducts(products);
    return Success(products);
  } on ApiException catch (e) {
    // Fallback para cache
    final cached = await _cache.getModel(LocalStorageKey.products, Product.fromMap);
    if (cached != null) {
      return Success(cached.data, isStale: true);
    }
    return Failure(ProductFailure.network(e.message));
  }
}
```

### SyncStore — Sincronização Inicial

> Detalhes em [ADR 013](adrs/013-sync-store.md)

O SyncStore é uma abstração em `packages/shared` que permite sincronização inicial de dados sem acoplar features:

```
┌─────────────────────────────────────────────────────────────────────┐
│                          main.dart                                  │
│                    (Bootstrap & DI Setup)                           │
│  • Cria SyncStoreImpl                                               │
│  • Fornece via ProviderScope                                        │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               │ provides
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          SyncStore                                  │
│                     (packages/shared)                               │
│  • registerSyncer<T>(key, fetcher)                                  │
│  • sync<T>(key) → Future<SyncState<T>>                              │
│  • watch<T>(key) → Stream<SyncState<T>>                             │
│  • get<T>(key) → SyncState<T>                                       │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
           ┌───────────────────┼───────────────────┐
           │                   │                   │
           ▼                   ▼                   ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│  Products Module │  │   Splash Screen  │  │  Future Features │
│                  │  │                  │  │                  │
│  • Registra      │  │  • watch()       │  │  • Podem usar    │
│    syncer        │  │  • retry via     │  │    mesmo padrão  │
│  • Usa get()     │  │    sync()        │  │                  │
│    para dados    │  │  • Navega após   │  │                  │
│    iniciais      │  │    success       │  │                  │
└──────────────────┘  └──────────────────┘  └──────────────────┘
```

**Estados do Sync:**

```dart
sealed class SyncState<T> {
  SyncStateIdle<T>()      // Estado inicial
  SyncStateLoading<T>()   // Sync em progresso  
  SyncStateSuccess<T>(T data)  // Sucesso com dados
  SyncStateError<T>(NetworkFailure failure, {T? previousData})  // Falha
}
```

**Fluxo de Uso:**

```dart
// 1. Products module registra syncer
syncStore.registerSyncer<List<Product>>(
  SyncStoreKey.products,
  fetcher: () => repository.getProducts(),
);

// 2. Splash observa estado
syncStore.watch<List<Product>>(SyncStoreKey.products).listen((state) {
  switch (state) {
    case SyncStateSuccess(): navigateToHome();
    case SyncStateError(): showRetryButton();
    case _: showLoading();
  }
});

// 3. Splash trigga sync
syncStore.sync<List<Product>>(SyncStoreKey.products);
```

---

## Estratégias de Resiliência

### Cache-First com TTL

> Detalhes em [ADR 007](adrs/007-abstracao-cache-local.md)

```
┌─────────────────────────────────────────────────────────────┐
│                    DECISÃO DE DADOS                         │
│                                                             │
│  1. Cache existe e NÃO expirou?                             │
│     └─► SIM: Retorna cache (fast path)                      │
│     └─► NÃO: Continua...                                    │
│                                                             │
│  2. Está online?                                            │
│     └─► SIM: Busca API                                      │
│         └─► Sucesso: Salva cache, retorna dados             │
│         └─► Falha: Vai para step 3                          │
│     └─► NÃO: Vai para step 3                                │
│                                                             │
│  3. Cache existe (mesmo expirado)?                          │
│     └─► SIM: Retorna cache + flag "stale"                   │
│     └─► NÃO: Retorna Failure (ErrorScreen)                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Banners de Estado

> Detalhes em [functional-specs.md](functional-specs.md)

| Estado | Banner | Dismissível? |
|--------|--------|--------------|
| Offline | "Você está offline" | ❌ |
| Dados Stale | "Dados podem estar desatualizados" | ✅ |
| Ambos | Mostra os dois (offline acima) | Parcial |

### Connectivity Observer

```dart
// Reativo: UI escuta mudanças de conectividade
connectivity.observe().listen((status) {
  _updateOfflineBanner(status == ConnectivityStatus.offline);
});
```

---

## Trade-offs e Decisões

### ✅ Decisões Acertadas

| Decisão | Benefício | ADR |
|---------|-----------|-----|
| Monorepo híbrido | Features isoladas + packages reutilizáveis | [ADR 002](adrs/002-estrutura-de-pastas-padrao.md) |
| Result Pattern | Zero exceptions, erros em compile-time | [ADR 006](adrs/006-command-pattern-e-tratamento-erros.md) |
| Command Pattern | UI reativa, loading/error automático | [ADR 006](adrs/006-command-pattern-e-tratamento-erros.md) |
| Abstrações (Delegate/Source) | Testabilidade, substituição trivial | [ADR 004](adrs/004-camada-de-abstracao-rede.md), [ADR 007](adrs/007-abstracao-cache-local.md) |
| Governança via CI | Previne violações de arquitetura | [ADR 003](adrs/003-abstracao-e-governanca-bibliotecas.md) |
| TTL no cache | Controle de freshness dos dados | [ADR 007](adrs/007-abstracao-cache-local.md) |

### ⚖️ Trade-offs Conscientes

| Trade-off | Custo | Benefício |
|-----------|-------|-----------|
| Camadas extras | +Boilerplate, +arquivos | Testabilidade, manutenibilidade |
| Abstrações | +Indireção, curva de aprendizado | Desacoplamento, substituição fácil |
| Monorepo | Múltiplos pubspec.yaml | Packages reutilizáveis |
| Result everywhere | Sintaxe mais verbosa | Erros nunca ignorados |
| Riverpod | +Complexidade vs setState | DI, reatividade, escopos |

### ❌ O que NÃO fazemos

| Anti-pattern | Por que evitamos |
|--------------|------------------|
| Singleton manual | Dificulta testes; Riverpod gerencia ciclo de vida |
| Import direto de libs | Vendor lock-in; Governança impede |
| Exceções para controle de fluxo | Result Pattern é mais explícito |
| `freezed` para entities | Equatable é mais simples para o escopo |
| BLoC | Over-engineering para o tamanho do projeto |

---

## Status de Implementação

### ✅ Implementado

| Componente | Status | ADR |
|------------|--------|-----|
| `ApiDataSourceDelegate` | ✅ Completo | [ADR 004](adrs/004-camada-de-abstracao-rede.md) |
| `LocalCacheSource` com TTL | ✅ Completo | [ADR 007](adrs/007-abstracao-cache-local.md) |
| `ConnectivityObserver` | ✅ Completo | [ADR 010](adrs/010-connectivity-observer.md) |
| `SyncStore` | ✅ Completo | [ADR 013](adrs/013-sync-store.md) |
| `flutter_command` (Result Pattern) | ✅ Completo | [ADR 006](adrs/006-command-pattern-e-tratamento-erros.md) |
| Design System Dori (Tokens + Atoms) | ✅ Completo | [ADR 009](adrs/009-design-system-dori.md) |
| CI/CD GitHub Actions | ✅ Completo | [ADR 005](adrs/005-esteira-ci-cd.md) |
| Governança de Imports (check_imports.sh) | ✅ Completo | [ADR 003](adrs/003-abstracao-e-governanca-bibliotecas.md) |

### 🟡 Pendentes (Backlog)

| Item | Risco | Prioridade |
|------|-------|------------|
| Fonte Plus Jakarta Sans não incluída | UI não 100% fiel ao design | Média |
| Widgetbook para documentação de componentes | Documentação manual | Baixa |
| Coverage report automatizado na CI | Difícil acompanhar métricas | Média |
| Testes de integração E2E | Cobertura apenas unitária | Baixa |

### 🟢 Melhorias Futuras

| Melhoria | Benefício | Esforço |
|----------|-----------|---------|
| Retry policy com exponential backoff | Resiliência em redes instáveis | Baixo |
| Cache hierárquico (memory → disk) | Performance de leitura | Alto |
| Feature flags via Remote Config | Rollout gradual | Médio |
| Analytics abstraction | Métricas de uso | Médio |

---

## Referências

### ADRs Relacionadas

- [ADR 001 — Documentar Decisões](adrs/001-documentar-decisoes-arquiteturais.md)
- [ADR 002 — Estrutura de Pastas](adrs/002-estrutura-de-pastas-padrao.md)
- [ADR 003 — Governança de Bibliotecas](adrs/003-abstracao-e-governanca-bibliotecas.md)
- [ADR 004 — Camada de Rede](adrs/004-camada-de-abstracao-rede.md)
- [ADR 005 — CI/CD](adrs/005-esteira-ci-cd.md)
- [ADR 006 — Command Pattern](adrs/006-command-pattern-e-tratamento-erros.md)
- [ADR 007 — Cache Local](adrs/007-abstracao-cache-local.md)
- [ADR 008 — Padrões de Testes](adrs/008-padroes-de-testes.md)
- [ADR 009 — Design System Dori](adrs/009-design-system-dori.md)
- [ADR 010 — Connectivity Observer](adrs/010-connectivity-observer.md)
- [ADR 011 — Splash Screen Architecture](adrs/011-splash-screen-architecture.md)
- [ADR 012 — Infinite Scroll Pagination](adrs/012-infinite-scroll-pagination.md)
- [ADR 013 — SyncStore](adrs/013-sync-store.md)

### Documentos de Apoio

- [Functional Specs](functional-specs.md) — Regras de negócio detalhadas
- [Tokens Spec](tokens-spec.md) — Design tokens do Dori

### Inspirações Externas

- [Clean Architecture — Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Atomic Design — Brad Frost](https://bradfrost.com/blog/post/atomic-web-design/)
- [Railway Oriented Programming](https://fsharpforfunandprofit.com/rop/) — Result Pattern
- [Command Pattern — Gang of Four](https://refactoring.guru/design-patterns/command)
- [Architecting Flutter apps](https://docs.flutter.dev/app-architecture)

---

*Este documento é vivo e será atualizado conforme a arquitetura evolui.*
