/// Interfaces for model serialization and deserialization.
///
/// Models that need to be cached must implement [Serializable] for the
/// [LocalCacheSource.setModel] method to work.
///
/// The [Deserializable] interface serves as documentation for the `fromMap`
/// factory pattern, since Dart doesn't support static methods in interfaces.
library;

/// Interface for models that can be serialized to a Map.
///
/// Used by [LocalCacheSource.setModel] to convert models to JSON-compatible
/// format for storage.
///
/// Example:
/// ```dart
/// class Product implements Serializable {
///   final int id;
///   final String name;
///
///   @override
///   Map<String, dynamic> toMap() => {'id': id, 'name': name};
/// }
/// ```
abstract class Serializable {
  /// Converts this model to a JSON-compatible Map.
  Map<String, dynamic> toMap();
}

/// Interface for models that can be deserialized from a Map.
///
/// Used by [LocalCacheSource.getModel] to reconstruct models from stored data.
///
/// Note: Dart doesn't support static methods in interfaces, so this serves
/// as documentation. Implementations should provide a static `fromMap` factory
/// or constructor that matches the signature:
///
/// ```dart
/// static T fromMap(Map<String, dynamic> map)
/// ```
///
/// Example:
/// ```dart
/// class Product implements Serializable {
///   final int id;
///   final String name;
///
///   const Product({required this.id, required this.name});
///
///   factory Product.fromMap(Map<String, dynamic> map) {
///     return Product(
///       id: map['id'] as int,
///       name: map['name'] as String,
///     );
///   }
///
///   @override
///   Map<String, dynamic> toMap() => {'id': id, 'name': name};
/// }
/// ```
// ignore: one_member_abstracts
abstract class Deserializable<T> {
  /// Creates an instance from a Map.
  ///
  /// This method exists for documentation purposes. In practice,
  /// use a static factory constructor in your implementation.
  T fromMap(Map<String, dynamic> map);
}
