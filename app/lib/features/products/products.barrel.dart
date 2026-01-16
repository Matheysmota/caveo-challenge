/// Products feature barrel.
///
/// Exports all public APIs for the products feature.
/// Use this for imports outside the feature.
library;

// Domain
export 'domain/entities/product.dart';
export 'domain/repositories/product_repository.dart';

// Infrastructure - Data Sources
export 'infrastructure/data_sources/product_local_data_source.dart';
export 'infrastructure/data_sources/product_remote_data_source.dart';

// Infrastructure - Models
export 'infrastructure/models/product_list_cache.dart';

// Infrastructure - Repositories
export 'infrastructure/repositories/product_repository_impl.dart';
