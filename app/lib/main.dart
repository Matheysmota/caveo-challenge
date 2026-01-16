import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import 'app/app_widget.dart';

/// Application entry point.
///
/// Uses **non-blocking initialization** to render the first frame immediately.
/// Async dependencies (LocalCacheSource) are loaded via FutureProvider while
/// the splash screen is already visible.
///
/// ## Initialization Flow
///
/// 1. Ensure Flutter bindings are initialized
/// 2. Create SyncStore synchronously
/// 3. Start app immediately (splash screen visible)
/// 4. LocalCacheSource initializes in background via FutureProvider
/// 5. Theme loads from cache after LocalCacheSource is ready
///
/// ## Why Non-Blocking?
///
/// Blocking `main()` with awaits delays the first frame, causing users to
/// see a blank screen. By using FutureProvider, the splash screen renders
/// instantly while infrastructure initializes in the background.
///
/// ## Sync Store Architecture
///
/// The SyncStore is created in main.dart and provided via ProviderScope.
/// Individual features register their syncers via their DI modules
/// using [SyncStoreRegistrar] to ensure proper initialization order.
///
/// See ADR 011 for detailed architecture decisions.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final syncStore = SyncStoreImpl();

  runApp(
    ProviderScope(
      overrides: [
        syncStoreProvider.overrideWithValue(syncStore),
      ],
      child: const AppWidget(),
    ),
  );
}

/// Provider for the global SyncStore instance.
///
/// This provider is overridden in main.dart with the actual instance.
/// Features register their syncers when their repositories are first accessed.
///
/// Example usage:
/// ```dart
/// final syncStore = ref.watch(syncStoreProvider);
/// syncStore.watch<List<Product>>(SyncStoreKey.products).listen(...);
/// ```
final syncStoreProvider = Provider<SyncStore>((ref) {
  throw UnimplementedError(
    'syncStoreProvider must be overridden in ProviderScope',
  );
});
