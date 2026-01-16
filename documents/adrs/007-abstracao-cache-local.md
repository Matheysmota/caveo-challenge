# ADR 007: Abstração de Cache Local e Políticas de Expiração

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 13-01-2026 |
| **Atualizado** | 15-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | cache, offline-first, performance, security |

## Contexto e Problema
Para atender aos requisitos funcionais de modo offline e economizar requisições de rede (conforme `functional-specs.md`), precisamos de uma estratégia de persistência local. Depender diretamente de implementações como `SharedPreferences`, `Hive` ou `Sqflite` gera acoplamento e dificulta a aplicação de políticas de negócio uniformes, como a invalidação de dados obsoletos (TTL - Time To Live).

Além disso, é crucial diferenciar o armazenamento de dados comuns (cache de JSON, configurações de UI) de dados sensíveis (tokens, PII), embora o escopo inicial trate apenas de dados públicos (produtos).

## Alternativas Consideradas

### 1. Uso Direto de Bibliotecas (ex: SharedPreferences / Hive)
Acessar `SharedPreferences.getInstance()` diretamente nos Repositórios.
*   **Pros:** Simplicidade imediata.
*   **Cons:** Lógica de expiração (TTL) fica espalhada ou inexistente. Dificuldade de migrar para bancos mais performáticos (ex: ISAR) se o volume de dados crescer.

### 2. Camada Abstrata com Gestão de TTL - **Opção Escolhida**
Criar um contrato de serviço (`LocalCacheSource`) que encapsula não apenas a leitura/escrita, mas também a validade do dado.

## Decisão

### 1. Interface de Cache Genérica (LocalCacheSource)

Criaremos uma interface abstrata em `packages/shared/lib/drivers/local_cache/`:

```dart
abstract class LocalCacheSource {
  /// Persists a model with optional TTL policy.
  /// 
  /// [key] - Unique identifier from [LocalStorageKey] enum.
  /// [model] - Object that implements toMap() for serialization.
  /// [ttl] - Expiration policy. Defaults to [LocalStorageTTL.withoutExpiration].
  Future<void> setModel<T extends Serializable>(
    LocalStorageKey key,
    T model, {
    LocalStorageTTL ttl = const LocalStorageTTL.withoutExpiration(),
  });

  /// Retrieves a cached model if exists and is not expired.
  /// 
  /// Returns [LocalStorageDataResponse<T>] with data and metadata, 
  /// or null if cache miss (not found or expired).
  Future<LocalStorageDataResponse<T>?> getModel<T>(
    LocalStorageKey key,
    T Function(Map<String, dynamic>) fromMap,
  );

  /// Removes a specific entry from cache.
  Future<void> delete(LocalStorageKey key);

  /// Clears all cached data.
  Future<void> clear();
}
```

### 2. Tipos de Suporte

#### LocalStorageKey (Centralização de Chaves)

```dart
/// Centralized enum of all cache keys.
/// Prevents magic strings and enables refactoring safety.
enum LocalStorageKey {
  products,
  themeMode,
  // Add new keys here as needed
  ;
  
  String get value => 'local_storage_$name';
}
```

#### LocalStorageTTL (Política de Expiração)

```dart
/// Represents the Time-To-Live policy for cached data.
class LocalStorageTTL {
  final Duration? duration;
  
  const LocalStorageTTL._(this.duration);
  
  /// Data never expires. Must be manually invalidated.
  const LocalStorageTTL.withoutExpiration() : this._(null);
  
  /// Data expires after the specified duration.
  const LocalStorageTTL.withExpiration(Duration duration) : this._(duration);
  
  bool get expires => duration != null;
}
```

#### LocalStorageDataResponse (Resposta com Metadados)

```dart
/// Wrapper for cached data with metadata.
/// Only returned when data exists AND is not expired.
class LocalStorageDataResponse<T> {
  final T data;
  final DateTime storedAt;
  
  const LocalStorageDataResponse({
    required this.data,
    required this.storedAt,
  });
}
```

### 3. Política de Invalidação (TTL)

*   A implementação armazena metadados junto com o dado (timestamp da gravação + duração do TTL).
*   No método `getModel(key)`, verifica se `DateTime.now() > storedAt + ttl.duration`.
*   **Se expirado:** O método deve limpar o dado internamente e retornar `null` (cache miss), obrigando o repositório a buscar da API.
*   **Default:** Dados **não expiram** por padrão (`LocalStorageTTL.withoutExpiration()`).

### 4. Estrutura de Arquivos

```
packages/shared/
├── lib/
│   ├── drivers/
│   │   └── local_cache/
│   │       ├── local_cache_source.dart           # Interface (PÚBLICO)
│   │       ├── local_storage_key.dart            # Enum de chaves (PÚBLICO)
│   │       ├── local_storage_ttl.dart            # TTL policy (PÚBLICO)
│   │       ├── local_storage_data_response.dart  # Response wrapper (PÚBLICO)
│   │       └── local_cache_export.dart           # Barrel export
│   │
│   ├── src/
│   │   └── drivers/
│   │       └── local_cache/
│   │           └── shared_preferences_local_cache_source.dart  # Impl (PRIVADO)
│   │
│   └── shared.dart
│
└── pubspec.yaml  # shared_preferences como dependência interna
```

### 5. Encapsulamento da Implementação

*   A biblioteca `shared_preferences` é dependência **interna** do package `/shared`.
*   A implementação concreta (`SharedPreferencesLocalCacheSource`) fica em `/src/` (privado).
*   **NÃO exportar** `shared_preferences` em `/libraries/`.
*   Outros packages (como `/app`) só conhecem a interface `LocalCacheSource`.
*   A DI (Riverpod) injeta a implementação concreta no ponto de configuração.

### 6. Segurança de Dados

*   Para o escopo deste desafio (lista de produtos públicos e imagens), usaremos `SharedPreferences` visando performance e simplicidade.
*   **Ressalva Importante:** Esta camada **NÃO deve ser usada para persistir dados sensíveis** (Senhas, Access Tokens, PII).
*   **Evolução Futura:** Caso o projeto evolua para armazenar dados sensíveis, a implementação concreta deve ser substituída por solução segura (ex: `FlutterSecureStorage`), sem alterar os contratos.

### 7. Serialização e Deserialização

Modelos que precisam ser cacheados devem implementar as interfaces de serialização:

```dart
/// Interface for models that can be serialized to a Map.
/// Used by [LocalCacheSource.setModel].
abstract class Serializable {
  Map<String, dynamic> toMap();
}

/// Interface for models that can be deserialized from a Map.
/// Used by [LocalCacheSource.getModel].
abstract class Deserializable<T> {
  /// Factory method to create an instance from a Map.
  /// 
  /// Note: Dart doesn't support static methods in interfaces,
  /// so this is enforced by convention. Implementations should
  /// provide a static `fromMap` factory or constructor.
  T fromMap(Map<String, dynamic> map);
}
```

**Uso recomendado:**

```dart
class Product implements Serializable {
  final int id;
  final String name;
  
  const Product({required this.id, required this.name});
  
  /// Factory constructor for deserialization
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
  
  @override
  Map<String, dynamic> toMap() => {'id': id, 'name': name};
}

// Uso no Repository:
final response = await cache.getModel(
  LocalStorageKey.products,
  Product.fromMap,  // Passa o factory como função
);
```

> **Nota:** Como Dart não suporta métodos estáticos em interfaces, a interface `Deserializable<T>` serve como **documentação de contrato**. A verificação real acontece em tempo de compilação quando o `fromMap` é passado para `getModel`.

## Consequências

### Positivas
*   **Type-Safety:** `LocalStorageKey` elimina strings mágicas e habilita autocompletar.
*   **Consistência:** TTL garante que dados obsoletos sejam invalidados automaticamente.
*   **Desacoplamento:** Repositórios não sabem se o dado está em SharedPreferences, Hive ou SQLite.
*   **Flexibilidade:** Trocar a implementação requer alterar apenas 1 arquivo de DI.
*   **Governança:** `shared_preferences` não vaza para `/app`, respeitando ADR 003.

### Trade-offs
*   **Overhead inicial:** Configurar a estrutura leva mais tempo que uso direto.
*   **Serialização manual:** Modelos precisam implementar `toMap()`/`fromMap()`.

## Referências

*   [System Design](../system_design.md) — Diagrama de componentes e estratégias de resiliência
*   [functional-specs.md](../functional-specs.md) — Requisitos de modo offline
*   [ADR 003](003-abstracao-e-governanca-bibliotecas.md) — Governança de dependências
