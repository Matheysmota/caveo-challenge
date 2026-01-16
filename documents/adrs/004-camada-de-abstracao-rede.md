# ADR 004: Abstração da Camada de Rede (Networking)

| Metadado | Valor |
| :--- | :--- |
| **Status** | ✅ Implementado |
| **Data** | 13-01-2026 |
| **Atualizado** | 15-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | arquitetura, networking, desacoplamento, segurança, dio, result-pattern |

## Contexto e Problema

A comunicação com APIs externas é uma parte crítica da aplicação. Ferramentas de mercado como `dio`, `http` ou `retrofit` são excelentes, mas criar uma dependência direta entre a regra de negócio (Repositories/UseCases) e uma biblioteca específica gera um alto acoplamento (Vendor Lock-in).

Se, no futuro, a biblioteca escolhida for descontinuada, sofrer alterações drásticas de licença ou apresentar problemas de performance, a refatoração seria custosa, exigindo alterações em centenas de arquivos de repositório. Além disso, garantir que todas as chamadas sigam os mesmos padrões de segurança, tratamento de erro e retry policies torna-se impossível sem um ponto central de controle.

## Alternativas Consideradas

### 1. Uso Direto de Bibliotecas (ex: Dio/Http)
Injetar a instância do `Dio` diretamente nos Repositórios.
*   **Pros:** Rápido de implementar, aproveita todos os recursos nativos da lib.
*   **Cons:** Acoplamento total. Se o método `.get()` do Dio mudar sua assinatura, quebramos todos os repositórios. Dificuldade de mockar o cliente HTTP em testes unitários sem bibliotecas adicionais (`mock_web_server` ou `mockito` complexos).

### 2. Camada de Abstração via Delegate (ApiDataSourceDelegate) - **Opção Escolhida**
Definir um contrato (Interface/Protocolo) próprio do projeto para operações de rede, desacoplando completamente a implementação da utilização.

## Decisão

Decidimos implementar o padrão **ApiDataSourceDelegate** para toda comunicação HTTP.

---

## Implementação

### Diagrama de Componentes

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            app/lib/features/                                │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                      ProductRepository                                │  │
│  │  ┌─────────────────────────────────────────────────────────────────┐  │  │
│  │  │  final ApiDataSourceDelegate _api;                              │  │  │
│  │  │                                                                 │  │  │
│  │  │  Future<Result<List<Product>, NetworkFailure>> getProducts() { │  │  │
│  │  │    return _api.request(                                        │  │  │
│  │  │      params: RequestParams.get('/products'),                   │  │  │
│  │  │      mapper: Product.fromMap,                                   │  │  │
│  │  │    );                                                           │  │  │
│  │  │  }                                                              │  │  │
│  │  └─────────────────────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼ depends on (interface only)            │
└─────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                     packages/shared/lib/drivers/                            │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │  ApiDataSourceDelegate (Interface Pública)                           │   │
│  │  ├── request<T>(params, mapper) → Result<T, NetworkFailure>          │   │
│  │  │                                                                   │   │
│  │  RequestParams (DTO Imutável)                                        │   │
│  │  ├── endpoint, method, queryParams, body, headers, options           │   │
│  │  ├── RequestParams.get(endpoint, {query, headers})                   │   │
│  │  └── RequestParams.post(endpoint, {body, query, headers})            │   │
│  │                                                                      │   │
│  │  NetworkFailure (Sealed Class)                                       │   │
│  │  ├── HttpFailure(statusCode, message, data)                          │   │
│  │  ├── ConnectionFailure(message)                                      │   │
│  │  ├── TimeoutFailure(message)                                         │   │
│  │  ├── ParseFailure(message, originalError)                            │   │
│  │  └── UnknownNetworkFailure(message, originalError)                   │   │
│  │                                                                      │   │
│  │  EnvConfig (Interface Pública)                                       │   │
│  │  ├── baseUrl, connectTimeout, receiveTimeout                         │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼ implemented by                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │  src/ (Implementações Privadas - NÃO exportar diretamente)           │   │
│  │  ├── ApiDataSourceDelegateImpl                                       │   │
│  │  ├── DioNetworkClient (Singleton Lazy)                               │   │
│  │  ├── NetworkClient (Interface Interna)                               │   │
│  │  ├── NetworkResponse (DTO Interno)                                   │   │
│  │  └── DotEnvConfig (flutter_dotenv)                                   │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼ uses                                   │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │  External Dependencies (Ocultas do App)                              │   │
│  │  ├── package:dio ^5.8.0+1                                            │   │
│  │  └── package:flutter_dotenv ^5.2.1                                   │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Contratos Públicos

#### 1. ApiDataSourceDelegate

```dart
/// Contract for HTTP API data source operations.
///
/// This interface provides a type-safe abstraction for making HTTP requests
/// without exposing the underlying HTTP client implementation (Dio, http, etc.).
///
/// All network errors are encapsulated in [NetworkFailure] types, eliminating
/// the need for try-catch blocks in consuming code.
abstract class ApiDataSourceDelegate {
  /// Performs an HTTP request and maps the response to a typed result.
  ///
  /// - [params]: Request configuration including endpoint, method, and options
  /// - [mapper]: Function to convert response JSON to the desired type [T]
  ///
  /// Returns [Success<T>] with mapped data or [Failure<NetworkFailure>] on error.
  Future<Result<T, NetworkFailure>> request<T>({
    required RequestParams params,
    required T Function(Map<String, dynamic> json) mapper,
  });
}
```

#### 2. RequestParams

```dart
/// Immutable configuration for an HTTP request.
///
/// Use factory constructors for type-safe request creation:
/// - [RequestParams.get] for GET requests
/// - [RequestParams.post] for POST requests
class RequestParams {
  final String endpoint;
  final HttpMethod method;
  final Map<String, dynamic>? queryParams;
  final Map<String, dynamic>? body;
  final Map<String, String>? headers;
  final RequestOptions? options;

  // Factories
  factory RequestParams.get(String endpoint, {...});
  factory RequestParams.post(String endpoint, {required Map<String, dynamic> body, ...});
}
```

#### 3. NetworkFailure (Sealed Class)

```dart
/// Sealed class representing all possible network failure types.
///
/// Pattern matching with `switch` is exhaustive and compile-time checked.
sealed class NetworkFailure {
  String get message;
}

/// HTTP error response (4xx, 5xx status codes).
final class HttpFailure extends NetworkFailure {
  final int statusCode;
  final String message;
  final dynamic data;
}

/// Network connectivity failure (no internet, DNS issues).
final class ConnectionFailure extends NetworkFailure { ... }

/// Request or response timeout.
final class TimeoutFailure extends NetworkFailure { ... }

/// JSON parsing/mapping error.
final class ParseFailure extends NetworkFailure {
  final Object? originalError;
}

/// Unknown or unexpected error.
final class UnknownNetworkFailure extends NetworkFailure {
  final Object? originalError;
}
```

#### 4. EnvConfig

```dart
/// Contract for environment configuration.
///
/// Implementations should load values from secure sources
/// (e.g., .env files, remote config).
abstract class EnvConfig {
  String get baseUrl;
  Duration get connectTimeout;
  Duration get receiveTimeout;
}
```

### Configuração de Ambiente

#### Arquivo `.devEnv`

```env
# Development Environment Configuration
# ⚠️ DO NOT COMMIT PRODUCTION VALUES TO VERSION CONTROL

BASE_URL=https://fakestoreapi.com
CONNECT_TIMEOUT=30000
RECEIVE_TIMEOUT=30000
```

#### Registro no `pubspec.yaml` (app)

```yaml
flutter:
  assets:
    - .devEnv
```

### Uso nos Repositórios

```dart
// app/lib/features/product/infrastructure/repositories/product_repository.dart
import 'package:shared/libraries/result_export.dart';
import 'package:shared/drivers/network/network_export.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../../domain/entities/product.dart';

class ProductRepository implements IProductRepository {
  final ApiDataSourceDelegate _api;

  ProductRepository(this._api);

  @override
  Future<Result<List<Product>, NetworkFailure>> getProducts() async {
    final result = await _api.request<Map<String, dynamic>>(
      params: RequestParams.get('/products'),
      mapper: (json) => json, // Retorna o map com 'data' contendo a lista
    );

    return result.fold(
      (success) {
        final items = (success['data'] as List)
            .map((e) => Product.fromMap(e as Map<String, dynamic>))
            .toList();
        return Success(items);
      },
      (failure) => Failure(failure),
    );
  }
}
```

### Tratamento de Erros

A implementação mapeia automaticamente exceções do Dio para `NetworkFailure`:

| DioExceptionType | NetworkFailure |
|------------------|----------------|
| `connectionTimeout` | `TimeoutFailure` |
| `sendTimeout` | `TimeoutFailure` |
| `receiveTimeout` | `TimeoutFailure` |
| `connectionError` | `ConnectionFailure` |
| `badResponse` (4xx/5xx) | `HttpFailure` |
| `cancel` | `ConnectionFailure` |
| Outros | `UnknownNetworkFailure` |

### Normalização de Respostas

A API pode retornar tanto objetos quanto arrays. A implementação normaliza automaticamente:

```dart
// Array response: [item1, item2] → {'data': [item1, item2]}
// Object response: {key: value} → {key: value} (inalterado)
```

### Injeção de Dependência (Riverpod)

```dart
// app/lib/app/providers/network_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final envReaderProvider = Provider<EnvironmentReader>((ref) {
  return DotEnvReader();
});

final networkConfigProvider = Provider<NetworkConfigProvider>((ref) {
  final reader = ref.watch(envReaderProvider);
  return EnvironmentNetworkConfig(reader);
});

final apiDataSourceProvider = Provider<ApiDataSourceDelegate>((ref) {
  final config = ref.watch(networkConfigProvider);
  final client = DioNetworkClient(config);
  return ApiDataSourceDelegateImpl(client: client, config: config);
});
```

### Inicialização no Bootstrap

```dart
// app/lib/main.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment configuration
  await dotenv.load(fileName: '.devEnv');
  
  runApp(const ProviderScope(child: AppWidget()));
}
```

---

## Governança (CI/CD)

O script `scripts/check_imports.sh` bloqueia imports diretos de bibliotecas de rede:

```bash
# Allowlist (permitidos apenas em packages/shared)
ALLOWED_PACKAGES=(
  "package:dio"
  "package:flutter_dotenv"
  # ...
)

# Blocked in app/lib/
if grep -rn "package:dio" app/lib/; then
  echo "❌ ERRO: Import direto de 'dio' encontrado em app/lib/"
  exit 1
fi
```

---

## Testes

A implementação inclui **121 testes unitários** cobrindo:

- `RequestParams` — Factories, equality, hashCode, copyWith
- `NetworkFailure` — Pattern matching, propriedades, toString
- `Result` — fold, map, mapError, isSuccess, isFailure
- `ApiDataSourceDelegateImpl` — Sucesso, erros HTTP, timeouts, conexão, parsing

### Exemplo de Teste

```dart
test('should return HttpFailure when status code is 404', () async {
  // Arrange
  when(() => mockClient.request(
    method: any(named: 'method'),
    url: any(named: 'url'),
  )).thenThrow(DioException(
    type: DioExceptionType.badResponse,
    response: Response(
      statusCode: 404,
      data: {'error': 'Not Found'},
      requestOptions: RequestOptions(),
    ),
    requestOptions: RequestOptions(),
  ));

  // Act
  final result = await delegate.request(
    params: RequestParams.get('/products'),
    mapper: (json) => json,
  );

  // Assert
  expect(result.isFailure, isTrue);
  result.fold(
    (_) => fail('Expected failure'),
    (failure) {
      expect(failure, isA<HttpFailure>());
      expect((failure as HttpFailure).statusCode, equals(404));
    },
  );
});
```

---

## Evolução Futura

### Interceptors (Não Implementado)

Para funcionalidades avançadas, a arquitetura suporta extensão via Interceptors:

```dart
// Futuro: packages/shared/lib/drivers/network/interceptors/
abstract class NetworkInterceptor {
  Future<RequestParams> onRequest(RequestParams params);
  Future<NetworkResponse> onResponse(NetworkResponse response);
  Future<NetworkFailure> onError(NetworkFailure failure);
}

// Casos de uso:
// - AuthInterceptor: Adiciona Bearer Token automaticamente
// - RefreshTokenInterceptor: Renova token expirado
// - LoggingInterceptor: Log estruturado de requests/responses
// - RetryInterceptor: Retry com backoff exponencial
// - CacheInterceptor: Cache de respostas GET
```

A implementação atual **não inclui interceptors** pois o escopo do desafio é limitado a GET de produtos. O design permite adição futura sem breaking changes.

---

## Consequências

### Positivas
*   **Desacoplamento Real:** O código da aplicação "não sabe" que o Dio existe. Podemos substituir o Dio pelo cliente nativo do Dart ou outra lib em 1 dia, alterando apenas 1 arquivo.
*   **Testabilidade:** Testar repositórios torna-se trivial. Não precisamos mockar o servidor HTTP nem a classe complexa do Dio; apenas criamos um `MockApiDataSourceDelegate` que retorna objetos simples.
*   **Consistência:** Tratamento de erros centralizado com `NetworkFailure` sealed class.
*   **Type-Safety:** Result Pattern elimina exceções não tratadas; `sealed class` garante pattern matching exaustivo.
*   **Segurança:** Previne que desenvolvedores façam chamadas HTTP "soltas" sem passar pelos interceptors de segurança da aplicação.

### Trade-offs
*   **Overhead inicial:** Configuração do Design System leva tempo antes de ver valor.
*   **Curva de aprendizado:** Desenvolvedores precisam entender Result Pattern e NetworkFailure.

---

## Referências

- [System Design](../system_design.md) — Diagrama de componentes mostrando ApiDataSourceDelegate
- [ADR 003](003-abstracao-e-governanca-bibliotecas.md) — Governança que bloqueia imports diretos de libs HTTP
- [ADR 006](006-command-pattern-e-tratamento-erros.md) — Result Pattern e tratamento de erros
- [ADR 007](007-abstracao-cache-local.md) — Abstração similar para cache local
