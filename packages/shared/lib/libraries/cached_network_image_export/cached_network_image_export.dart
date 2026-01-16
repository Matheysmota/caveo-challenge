/// Exports cached_network_image library for network image caching.
///
/// This abstraction ensures that the underlying caching library can be
/// replaced without impacting application code.
///
/// ## Usage
///
/// ```dart
/// import 'package:shared/libraries/cached_network_image_export/cached_network_image_export.dart';
///
/// CachedNetworkImage(
///   imageUrl: 'https://example.com/image.jpg',
///   placeholder: (context, url) => CircularProgressIndicator(),
///   errorWidget: (context, url, error) => Icon(Icons.error),
/// )
/// ```
library cached_network_image_export;

export 'package:cached_network_image/cached_network_image.dart';
