# 🔧 Shared Package

> Core utilities, abstractions and governed library exports for the Caveo Flutter Challenge.

## Overview

The `shared` package provides:

- **Drivers:** Abstractions for infrastructure concerns (network, cache, connectivity, sync)
- **Libraries:** Governed re-exports of external packages
- **Utils:** Common utilities and extensions

## Features

### Drivers

| Driver | Description | ADR |
|--------|-------------|-----|
| `ApiDataSourceDelegate` | HTTP abstraction | [ADR 004](../../documents/adrs/004-camada-de-abstracao-rede.md) |
| `LocalCacheSource` | Typed cache with TTL | [ADR 007](../../documents/adrs/007-abstracao-cache-local.md) |
| `ConnectivityObserver` | Network status monitoring | [ADR 010](../../documents/adrs/010-connectivity-observer.md) |
| `SyncStore` | Initial data synchronization | [ADR 011](../../documents/adrs/011-sync-store.md) |

### Libraries (Governed Exports)

All external libraries are re-exported via barrel files:

```dart
// ✅ Correct - use governed exports
import 'package:shared/libraries/result_export/result_export.dart';
import 'package:shared/libraries/riverpod_export/riverpod_export.dart';

// ❌ Wrong - direct imports forbidden
import 'package:result_dart/result_dart.dart';
```

## Usage

### SyncStore

```dart
import 'package:shared/shared.dart';

// Create store
final syncStore = SyncStoreImpl();

// Register syncer
syncStore.registerSyncer<List<Product>>(
  SyncStoreKey.products,
  fetcher: () => repository.getProducts(),
);

// Watch state
syncStore.watch<List<Product>>(SyncStoreKey.products).listen((state) {
  switch (state) {
    case SyncStateSuccess(:final data):
      print('Got ${data.length} products');
    case SyncStateError(:final failure):
      print('Error: ${failure.message}');
    case SyncStateLoading():
      print('Loading...');
    case SyncStateIdle():
      print('Not synced yet');
  }
});

// Trigger sync
await syncStore.sync<List<Product>>(SyncStoreKey.products);
```

### LocalCacheSource

```dart
import 'package:shared/shared.dart';

final cache = await SharedPreferencesLocalCacheSource.create();

// Save with TTL
await cache.setModel(
  LocalStorageKey.products,
  productListCache,
  ttl: LocalStorageTTL.withExpiration(Duration(hours: 1)),
);

// Retrieve (returns null if expired)
final cached = await cache.getModel(
  LocalStorageKey.products,
  ProductListCache.fromMap,
);
```

## Package Structure

```
lib/
├── drivers/              # Public interfaces
│   ├── connectivity/
│   ├── env/
│   ├── local_cache/
│   ├── network/
│   └── sync_store/
├── libraries/            # Governed exports
│   ├── equatable_export/
│   ├── go_router_export/
│   ├── result_export/
│   └── riverpod_export/
├── src/                  # Private implementations
│   └── drivers/
├── utils/                # Extensions and helpers
└── shared.dart           # Main barrel
```

## Architecture

See [ADR 003](../../documents/adrs/003-abstracao-e-governanca-bibliotecas.md) for governance rules.
