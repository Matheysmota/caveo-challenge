/// Defines all route paths in the application.
///
/// Using a sealed class provides:
/// - Type safety for route paths
/// - Centralized route management
/// - Helper methods for parameterized routes
///
/// ## Route Structure
///
/// ```
/// /                    → Splash Screen
/// /products            → Product List
/// /products/:id        → Product Details
/// ```
///
/// ## Usage
///
/// ```dart
/// // Navigate to products
/// context.go(AppRoutes.products);
///
/// // Navigate to product details
/// context.go(AppRoutes.productDetailsPath('123'));
/// ```
library;

/// Centralized route path definitions.
///
/// All app routes should be defined here to ensure consistency
/// and prevent typos in route strings.
sealed class AppRoutes {
  AppRoutes._();

  /// Splash screen route (initial route).
  ///
  /// Shows app logo and handles initialization.
  static const String splash = '/';

  /// Products list route.
  ///
  /// Shows the main product feed with search and filtering.
  static const String products = '/products';

  /// Product details route pattern.
  ///
  /// Use [productDetailsPath] to generate the actual path with an ID.
  static const String productDetails = '/products/:id';

  /// Generates the product details path for a specific product.
  ///
  /// ```dart
  /// final path = AppRoutes.productDetailsPath('abc123');
  /// // Returns: '/products/abc123'
  /// context.go(path);
  /// ```
  static String productDetailsPath(String id) => '/products/$id';
}
