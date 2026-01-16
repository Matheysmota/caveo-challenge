import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import 'app/app_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final syncStore = SyncStoreImpl();

  runApp(
    ProviderScope(
      overrides: [syncStoreProvider.overrideWithValue(syncStore)],
      child: const AppWidget(),
    ),
  );
}

/// Overridden in main.dart with the actual instance.
final syncStoreProvider = Provider<SyncStore>((ref) {
  throw UnimplementedError(
    'syncStoreProvider must be overridden in ProviderScope',
  );
});
