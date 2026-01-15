/// Dori Design System — Atoms
///
/// Atomic components that are the building blocks of the design system.
/// Atoms are the smallest, most primitive UI elements.
///
/// ## Available Atoms
///
/// - [DoriIconData] — Enum of allowed icons
/// - [DoriIcon] — Icon with restricted icon set
/// - [DoriIconButton] — Circular icon button
/// - [DoriText] — Text with typography tokens
/// - [DoriBadge] — Badge for status, labels, or counts
///
/// {@category Atoms}
library;

// Icon (ordered by dependency hierarchy)
export 'icon/dori_icon_data.dart';
export 'icon/dori_icon.dart';
export 'icon_button/dori_icon_button.dart';

// Text
export 'text/dori_text.dart';

// Badge
export 'badge/dori_badge.dart';
