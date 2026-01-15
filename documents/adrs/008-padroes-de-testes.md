# ADR 008: Estratégia e Padrões de Testes Automatizados

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 13-01-2026 |
| **Atualizado** | 15-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | quality, testing, unit-tests, mocktail |

## Contexto e Problema
A garantia de qualidade em software é inegociável, mas em projetos com escopo fechado e prazos curtos (como desafios técnicos), é necessário equilibrar a profundidade dos testes com a velocidade de entrega. Precisamos definir quais camadas serão testadas, qual a granularidade desses testes e quais ferramentas/padrões utilizaremos para manter a consistência.

Sem essa definição, corre-se o risco de investir tempo excessivo em testes frágeis (como de integração complexos) ou, pior, entregar um código sem nenhuma garantia de funcionamento além do "caminho feliz" manual.

## Decisão

### 1. Escopo: Testes Unitários Exclusivamente
Decidimos focar 100% dos esforços de automação em **Testes Unitários**.
*   **O que será testado:** 
    *   **Domain:** Entidades (`fromMap`, regras de validação) e UseCases.
    *   **Presentation:** ViewModels (checagem de estado e efeitos colaterais dos Commands) e Widgets de Página principais (smoke tests, renderização de estados).
    *   **Infrastructure:** Implementações de Repositories, DataSources e Drivers (LocalCacheSource, ConnectivityObserver).
    *   **Shared/Core:** Utilitários e helpers.
*   **O que NÃO será testado:**
    *   Testes de Integração (drivers reais) e E2E (End-to-End).
    *   **Motivo:** A complexidade de setup e tempo de execução desses testes não se justifica dado o escopo restrito do desafio técnico e o prazo de entrega. A arquitetura desacoplada (ADRs 002 e 004) já garante robustez suficiente.

### 2. Ferramentas e Bibliotecas

#### mocktail
Utilizaremos a biblioteca `mocktail` para mocking, **encapsulada** em `packages/shared/lib/libraries/mocktail_export.dart`.

```dart
// packages/shared/lib/libraries/mocktail_export.dart
export 'package:mocktail/mocktail.dart';
```

**Uso nos testes:**
```dart
// ✅ CORRETO
import 'package:shared/libraries/mocktail_export.dart';

// ❌ ERRADO (viola governança)
import 'package:mocktail/mocktail.dart';
```

*Por que mocktail:*
- API mais simples que `mockito`
- Null-safety friendly
- Sem necessidade de code-generation
- Suporte a `any()`, `when()`, `verify()` sem annotations

### 3. Padrão de Estrutura: AAA (Arrange, Act, Assert)
Adotaremos exclusivamente o padrão **AAA** para o corpo dos testes.
*   **Arrange:** Prepara o cenário (mocks, instâncias, dados).
*   **Act:** Executa métodos ou ações sob teste.
*   **Assert:** Verifica os resultados e chamadas de verificação.

```dart
test('should return cached data when cache is valid', () async {
  // Arrange
  final mockCache = MockLocalCacheSource();
  final repository = ProductRepository(mockCache);
  when(() => mockCache.getModel(any(), any()))
      .thenAnswer((_) async => mockResponse);
  
  // Act
  final result = await repository.getProducts();
  
  // Assert
  expect(result.isSuccess, isTrue);
  verify(() => mockCache.getModel(LocalStorageKey.products, any())).called(1);
});
```

*Justificativa:* Preferimos AAA ao Gherkin (Given-When-Then) pela objetividade e redução de verbosidade.

### 4. Nomenclatura
Os títulos dos testes devem ser descritivos e seguir o formato:
`should [comportamento esperado] when [condição/cenário]`
*   *Exemplo:* `test('should return Success when repository call succeeds', ...)`

### 5. Qualidade dos Testes: Cenários Críticos e Corner Cases

**Os testes devem ser robustos e focar em cenários que realmente importam:**

#### Cenários Obrigatórios por Camada

| Camada | Cenários Críticos |
|--------|-------------------|
| **Entities** | `fromMap` com campos nulos, tipos inválidos, campos extras |
| **UseCases** | Sucesso, Failure do repository, exceções inesperadas |
| **ViewModels** | Estados inicial/loading/success/error, transições de estado, Commands múltiplos |
| **LocalCacheSource** | Cache hit, cache miss, TTL expirado, dados corrompidos |
| **ConnectivityObserver** | Online → Offline, Offline → Online, status inicial |

#### Corner Cases que DEVEM ser testados

```dart
group('LocalCacheSource', () {
  // ✅ Happy path
  test('should return data when cache exists and is valid', ...);
  
  // ✅ Cache miss
  test('should return null when key does not exist', ...);
  
  // ✅ TTL expirado
  test('should return null when data is expired', ...);
  
  // ✅ Dados corrompidos
  test('should return null when stored JSON is malformed', ...);
  
  // ✅ Tipo incorreto
  test('should handle type mismatch gracefully', ...);
  
  // ✅ Chave limpa após expiração
  test('should delete expired data from storage', ...);
});
```

#### Anti-patterns a Evitar

| ❌ Anti-pattern | ✅ Correto |
|-----------------|------------|
| Testar apenas happy path | Testar edge cases e error paths |
| Mocks que retornam sempre sucesso | Variar retornos dos mocks |
| Testes que dependem de ordem | Testes isolados e independentes |
| Assertions genéricas (`expect(result, isNotNull)`) | Assertions específicas (`expect(result.data.length, equals(3))`) |
| Ignorar verificação de chamadas | `verify()` para garantir interações |

### 6. Estrutura de Arquivos de Teste

```
test/
├── features/
│   └── product/
│       ├── domain/
│       │   └── entities/
│       │       └── product_test.dart
│       ├── infrastructure/
│       │   └── repositories/
│       │       └── product_repository_test.dart
│       └── presentation/
│           └── view_models/
│               └── product_list_view_model_test.dart
├── shared/
│   └── drivers/
│       ├── local_cache/
│       │   └── shared_preferences_local_cache_source_test.dart
│       └── connectivity/
│           └── connectivity_plus_observer_test.dart
└── helpers/
    ├── mocks.dart          # Definições de Mocks compartilhadas
    └── fixtures.dart       # Dados de teste reutilizáveis
```

## Consequências

### Positivas
*   **Desenvolvimento Ágil:** Testes unitários rodam em milissegundos, permitindo TDD e feedback loop rápido.
*   **Manutenibilidade:** Mocks via `mocktail` são fáceis de ler e manter.
*   **Cobertura:** Focamos em cobrir regras de negócio e lógica de estado (ViewModel/Commands), onde moram os bugs mais críticos.
*   **Robustez:** Foco em corner cases previne bugs em produção.
*   **Governança:** `mocktail` é acessado via export controlado, respeitando ADR 003.

### Trade-offs
*   **Sem E2E:** Fluxos completos de navegação não são validados automaticamente.
*   **Tempo adicional:** Escrever testes de corner cases leva mais tempo que apenas happy path.
