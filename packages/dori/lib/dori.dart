/// 🐠 Dori Design System
/// D.O.R.I. — Design Oriented Reusable Interface
///
/// "We forget, it remembers."
///
/// This is the main barrel of the Dori Design System.
/// Import this file to access all components.
///
/// ```dart
/// import 'package:dori/dori.dart';
/// ```
///
/// ## Basic Usage
/// ```dart
/// // Access tokens via context
/// final dori = context.dori;
///
/// // Colors (reactive to theme)
/// dori.colors.brand.pure
/// dori.colors.surface.one
/// dori.colors.content.one
/// dori.colors.feedback.success
///
/// // Spacing (flat scale)
/// dori.spacing.xs  // 16dp
/// dori.spacing.sm  // 24dp
///
/// // Radius
/// dori.radius.lg  // BorderRadius.circular(16)
///
/// // Typography
/// dori.typography.title5
/// dori.typography.description
/// ```
///
/// ## Theme Control
/// ```dart
/// // In MaterialApp
/// MaterialApp(
///   theme: DoriTheme.light,
///   darkTheme: DoriTheme.dark,
///   themeMode: themeMode,
/// );
///
/// // Toggle theme
/// context.dori.setTheme(DoriThemeMode.dark);
/// context.dori.setTheme(context.dori.themeMode.inverse);
/// ```
library;

// Tokens
export 'src/tokens/dori_tokens.barrel.dart';

// Theme
export 'src/theme/dori_theme.barrel.dart';

// Atoms
export 'src/atoms/dori_atoms.barrel.dart';

// TODO: Export molecules, organisms when implemented
// export 'src/molecules/dori_molecules.barrel.dart';
// export 'src/organisms/dori_organisms.barrel.dart';
// export 'src/animations/dori_animations.barrel.dart';
