# ADR 013: SyncStore — Padrão de Sincronização Inicial

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 16-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | sync, state-management, splash, domain-isolation |

## Contexto e Problema

O aplicativo precisa sincronizar dados iniciais (ex: produtos) durante a splash screen. Identificamos os seguintes desafios:

1. **Isolamento de Domínio:** A splash screen não deve conhecer detalhes da feature Products. Importar diretamente o `ProductRepository` na splash viola o princípio de isolamento de features.

2. **Dependência Circular:** Se splash depende de products para sincronização, e products precisa da splash para exibir loading, criamos um acoplamento indesejado.

3. **Padrão Service Incorreto:** Uma tentativa inicial usando `ProductSyncService implements SyncDataSource` criou uma camada desnecessária onde o Service apenas delegava para o Repository.

4. **Múltiplas Fontes de Dados:** Futuramente podemos ter outros tipos de dados para sincronizar (configurações, usuário, etc.). A solução precisa ser extensível.

## Decisão

Implementamos o **SyncStore** como uma abstração genérica em `packages/shared` que permite:

1. **Registro de Syncers:** Features registram seus "fetchers" (funções que buscam dados) associados a chaves.
2. **Estado Reativo:** A splash (ou qualquer tela) observa o estado via streams sem conhecer a origem dos dados.
3. **Desacoplamento Total:** Splash não importa nada de products; ambos conhecem apenas o SyncStore.

### Arquitetura

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

### Fluxo de Sincronização

```
1. main.dart
   └── Cria SyncStoreImpl()
   └── Adiciona ao ProviderScope

2. SplashViewModel.build()
   └── Lê productSyncRegistrarProvider (registra syncer se necessário)
   └── syncStore.watch<List<Product>>(SyncStoreKey.products)
   └── syncStore.sync<List<Product>>(SyncStoreKey.products)

3. Stream de Estados:
   SyncStateIdle → SyncStateLoading → SyncStateSuccess/SyncStateError

4. SplashViewModel processa estado final:
   └── Success: Navega para Home
   └── Error: Mostra erro com retry
```

### Estados do Sync

```dart
sealed class SyncState<T> {
  // Estado inicial antes de qualquer sync
  SyncStateIdle<T>()
  
  // Sync em progresso
  SyncStateLoading<T>()
  
  // Sync concluído com sucesso
  SyncStateSuccess<T>(T data)
  
  // Sync falhou (pode incluir dados anteriores)
  SyncStateError<T>(NetworkFailure failure, {T? previousData})
}
```

### Registro de Syncers

O registro acontece de forma lazy através do provider pattern:

```dart
// products_module.dart
final productSyncRegistrarProvider = Provider<void>((ref) {
  final syncStore = ref.watch(syncStoreProvider);
  final repository = ref.watch(productRepositoryProvider);

  if (!syncStore.hasKey(SyncStoreKey.products)) {
    syncStore.registerSyncer<List<Product>>(
      SyncStoreKey.products,
      fetcher: () => repository.getProducts(),
    );
  }
});
```

## Alternativas Consideradas

### 1. SyncDataSource Interface (Rejeitada)

```dart
// ❌ REJEITADO
abstract interface class SyncDataSource {
  Future<Result<void, NetworkFailure>> sync();
}

class ProductSyncService implements SyncDataSource {
  final ProductRepository _repository;
  Future<Result<void, NetworkFailure>> sync() => _repository.getProducts().map((_) {});
}
```

**Problemas:**
- Service apenas delega para Repository (camada desnecessária)
- Splash ainda precisa conhecer que é "products" via override de provider
- Não é extensível para múltiplas fontes de dados

### 2. Event Bus (Considerado)

```dart
// ❌ NÃO ESCOLHIDO
class SyncCompletedEvent {
  final SyncType type;
  final bool success;
}
```

**Problemas:**
- Perda de type safety
- Difícil rastrear quem emitiu/consumiu eventos
- Estado não é facilmente acessível (apenas eventos)

### 3. BLoC por Feature (Considerado)

```dart
// ❌ NÃO ESCOLHIDO
class ProductSyncBloc extends Bloc<SyncEvent, SyncState> { ... }
```

**Problemas:**
- Overhead excessivo para sincronização simples
- Splash ainda precisaria conhecer o BLoC de products
- Não resolve o problema de isolamento

## Consequências

### Positivas

- **Isolamento Total:** Splash não importa nada de products
- **Extensível:** Fácil adicionar novos tipos de sync (usuário, config, etc.)
- **Type Safe:** Cada key tem seu tipo associado
- **Observável:** Stream permite UI reativa
- **Testável:** Mock simples do SyncStore
- **Retry Simples:** Basta chamar `sync()` novamente

### Trade-offs

- **Mais Indireção:** Dados passam por mais uma camada
- **Registro Manual:** Syncers precisam ser registrados explicitamente
- **Chaves Enum:** Novas features precisam adicionar chaves ao enum

### Regras de Uso

1. **Syncers são registrados nos módulos de DI** via providers dedicados
2. **Features não devem chamar `registerSyncer` diretamente** - use o pattern de provider
3. **Splash deve apenas observar e triggerar sync** - não deve conhecer o tipo de dados
4. **SyncStoreKey deve ser estendido** quando novas features precisarem de sync

## Exemplo de Extensão

Para adicionar sync de usuário no futuro:

```dart
// 1. Adicionar key
enum SyncStoreKey {
  products,
  user,  // Nova key
}

// 2. Criar registrar no módulo de usuário
final userSyncRegistrarProvider = Provider<void>((ref) {
  final syncStore = ref.watch(syncStoreProvider);
  final repository = ref.watch(userRepositoryProvider);

  if (!syncStore.hasKey(SyncStoreKey.user)) {
    syncStore.registerSyncer<User>(
      SyncStoreKey.user,
      fetcher: () => repository.getCurrentUser(),
    );
  }
});

// 3. Splash pode observar múltiplos syncs
syncStore.watch<User>(SyncStoreKey.user).listen(...);
```

## Referências

- [ADR 002: Estrutura de Pastas](./002-estrutura-de-pastas-padrao.md) — Isolamento de features
- [ADR 004: Camada de Rede](./004-camada-de-abstracao-rede.md) — NetworkFailure usado no SyncState
- [System Design](../system_design.md) — Visão geral da arquitetura
