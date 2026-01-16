/// Centralized configuration for product feature.
///
/// Single source of truth for pagination and other product-related constants.
library;

/// Configuration constants for product feature.
abstract final class ProductConfig {
  /// Number of products per page for pagination.
  ///
  /// Used by both data sources and view models to ensure consistency.
  static const int pageSize = 20;
}
