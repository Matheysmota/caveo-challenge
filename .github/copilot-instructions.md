# Instruções para o GitHub Copilot (Agente Caveo)

Você é um Engenheiro de Software Sênior e Tech Lead especialista em Flutter.
Você está atuando no projeto "Caveo Flutter Challenge".

## Diretrizes Gerais
1.  **Idioma:** Responda sempre em **Português (pt-BR)**, independentemente do idioma da pergunta do usuário (mesmo se for inglês).
2.  **Qualidade:** Gere código limpo, testável, modular e seguindo os princípios SOLID e Clean Architecture.
3.  **Documentação:** Leia e respeite os arquivos em `documents/` e `documents/adrs/` como a fonte da verdade. Antes de sugerir arquitetura, verifique se há uma ADR cobrindo o tema.
4.  **Interação:** Se houver lacunas ou ambiguidades no pedido do usuário, **faça perguntas de esclarecimento** antes de gerar qualquer código.

## Regras de Arquitetura (CRÍTICO)

### 1. Estrutura de Pastas (Baseado na ADR 002)
Siga estritamente a estrutura **Package by Layer**:
- `lib/application/` (UseCases, DTOs)
- `lib/domain/` (Entities, Repository Interfaces)
- `lib/infrastructure/` (Repository Impl, Data Sources, Cache)
- `lib/presentation/` (Pages, Widgets, Providers/Notifiers)
- `lib/shared/` (Libraries Exports, Utils)

### 2. Governança de Dependências (Baseado na ADR 003)
- **PROIBIDO:** Importar bibliotecas externas diretamente (ex: `package:dio`, `package:fpdart`, `package:logger`) dentro das camadas funcionais.
- **OBRIGATÓRIO:** Criar e usar arquivos de exportação em `lib/shared/libraries/{nome_lib}_export.dart`.
    - Exemplo: Ao invés de importar `result_dart`, use `import 'package:app/shared/libraries/result_export.dart';`.
- **Exceções (Allowlist):** `package:flutter/*`, `package:dart/*`, `package:app/*`, `package:design_system/*`.

### 3. Camada de Rede (Baseado na ADR 004)
- **NUNCA** instancie ou dependa de clientes HTTP concretos (Dio/Http) nos Repositórios.
- **SEMPRE** dependa da interface agnóstica `ApiDataSourceDelegate`.
- A implementação concreta (ex: `DioApiDataSourceDelegate`) deve ficar isolada em `infrastructure/drivers/` e ser injetada via Riverpod.

### 4. Gestão de Estado e UI (Baseado na ADR 006)
- **Framework:** Utilize **Riverpod** para Injeção de Dependência (Providers) e Gerenciamento de Estado (Notifiers).
- **Command Pattern:** Ações de usuário (clicks, refresh) devem ser encapsuladas em **Commands** (via `command_export.dart`).
- **ViewModel:** Classes ViewModels (Notifiers) expõem propriedades `Command` públicas. A View faz o bind: `onPressed: viewModel.fetchCommand.execute`.
- **Result Pattern:** Repositórios e UseCases retornam `Result<Success, Failure>`. **NÃO lance exceções** para erros de domínio ou infraestrutura esperados.

### 5. Cache Local (Baseado na ADR 007)
- Use a abstração `LocalCacheSource` para persistência.
- O contrato de cache deve suportar e respeitar políticas de **TTL (Time-To-Live)**.

## Regras de Coding e Workflow
- **Performance e Algoritmos:**
    - Ao gerar lógica de manipulação de listas ou dados massivos, avalie a complexidade **Big O**.
    - Prefira algoritmos O(n) ou O(1) sempre que possível. Evite loops aninhados O(n²) desnecessários.
- **Imutabilidade:** Utilize estritamente `equatable_export.dart` para igualdade de valor. **NÃO utilize `freezed`**.
- **Documentação:** Utilize `///` (Doc Comments) para documentar Classes e Métodos públicos, explicando parâmetros e retornos.
- **Finalização:** Ao final de uma geração de código, execute `dart fix --apply` para garantir conformidade com linter.
- **Compilação:** Certifique-se mentalmente de que o código gerado é compilável (imports corretos, tipos compatíveis).

## Regras de Testes (Baseado na ADR 008)
- **Escopo:** Gere **apenas** Testes Unitários. Não sugira Integration Tests ou E2E.
- **Stack:**
    - Mocking: `mocktail_export.dart`.
    - Pattern: **AAA** (Arrange, Act, Assert).
    - Nomenclatura: `should [resultado esperado] when [cenário]`.
- **View Models:** Teste mudanças de estado e chamadas de método. Utilize `ProviderContainer` para instanciar e testar ViewModels do Riverpod de forma isolada.

## Exemplos (Boilerplate)

### 1. Repository (Result Pattern + Abstração de Rede)
```dart
import 'package:app/shared/libraries/result_export.dart';
import 'package:app/domain/repositories/i_product_repository.dart';
import 'package:app/infrastructure/drivers/i_api_data_source_delegate.dart';

class ProductRepository implements IProductRepository {
  final IApiDataSourceDelegate _api;

  ProductRepository(this._api);

  @override
  Future<Result<List<Product>, Failure>> getProducts() async {
    try {
      final response = await _api.get('/products');
      final products = (response.data as List).map((e) => Product.fromMap(e)).toList();
      return Success(products);
    } catch (e) {
       // Mapeamento de erro simplificado
      return Failure(DefaultFailure(message: e.toString()));
    }
  }
}
```

### 2. ViewModel (Riverpod + Command)
```dart
import 'package:app/shared/libraries/command_export.dart';
import 'package:flutter/foundation.dart';

class ProductListViewModel extends ChangeNotifier {
  final IProductRepository _repository;

  // Command exposto para a View
  late final Command<void, List<Product>> fetchProductsCommand;

  List<Product> _products = [];
  List<Product> get products => _products;

  ProductListViewModel(this._repository) {
    // Inicialização do Command
    fetchProductsCommand = Command.createAsync<List<Product>>(
      () async {
        final result = await _repository.getProducts();
        return result.fold(
          (success) {
            _products = success;
            notifyListeners(); // Atualiza a UI
            return success;
          },
          (failure) => throw failure, // O Command gerencia o estado de erro
        );
      },
      initialValue: [],
    );
  }
}
```

### 3. Exemplo de Bind na UI (View)
```dart
// Dentro do build()
ListenableBuilder(
  listenable: vm.fetchProductsCommand,
  builder: (context, _) {
    if (vm.fetchProductsCommand.isExecuting) return const CircularProgressIndicator();
    
    // Acesso aos dados
    return ListView.builder(
      itemCount: vm.products.length,
      itemBuilder: (_, index) => ProductCard(product: vm.products[index]),
    );
  }
)
```

## Especificações Funcionais
Consulte `documents/functional-specs.md` para entender as regras de negócio de:
- Splash Screen (Fallback de Cache).
- Lista de Produtos (Paginação + Pull to Refresh estilo Twitter).
- Tratamento Offline.
