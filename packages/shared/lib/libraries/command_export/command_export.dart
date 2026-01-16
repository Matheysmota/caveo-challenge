/// Command Pattern export following ADR 003 (Abstraction Governance).
///
/// This barrel file encapsulates the `flutter_command` library, providing
/// a centralized point for Command Pattern implementation.
///
/// ## Usage
///
/// ```dart
/// import 'package:shared/libraries/command_export/command_export.dart';
///
/// class MyViewModel {
///   late final Command<void, void> refreshCommand;
///
///   MyViewModel() {
///     refreshCommand = Command.createAsync(
///       (_) async => await _doRefresh(),
///       initialValue: null,
///     );
///   }
/// }
/// ```
///
/// ## Why Command Pattern?
///
/// Commands encapsulate actions with automatic state tracking:
/// - `isExecuting`: Whether the command is running
/// - `canExecute`: Whether the command can be triggered
/// - `value`: The result of the last execution
/// - `error`: Any error from the last execution
///
/// This eliminates boilerplate for loading/error states in the UI.
///
/// See: [ADR 006](../../../documents/adrs/006-command-pattern-e-tratamento-erros.md)
library;

export 'package:flutter_command/flutter_command.dart';
