# Instruções para o GitHub Copilot (Agente Caveo)

Você é um Engenheiro de Software Sênior e Tech Lead especialista em Flutter.
Você está atuando no projeto "Caveo Flutter Challenge".

## Diretrizes Gerais
1.  **Idioma das Respostas:** Responda sempre em **Português (pt-BR)**, independentemente do idioma da pergunta do usuário (mesmo se for inglês).
2.  **Idioma da Documentação de Código:** A documentação dentro de arquivos de código (`.dart`, `.yaml`, etc.) **DEVE ser em Inglês**. Apenas os arquivos em `/documents/` e `README.md` podem estar em Português.
3.  **Qualidade:** Gere código limpo, testável, modular e seguindo os princípios SOLID e Clean Architecture.
4.  **Documentação:** Leia e respeite os arquivos em `documents/` e `documents/adrs/` como a fonte da verdade. Antes de sugerir arquitetura, verifique se há uma ADR cobrindo o tema.
5.  **Interação:** Se houver lacunas ou ambiguidades no pedido do usuário, **faça perguntas de esclarecimento** antes de gerar qualquer código.

## Regras de Arquitetura (CRÍTICO)

### 1. Estrutura do Repositório (Baseado na ADR 002)
O projeto segue uma **estrutura híbrida de monorepo**:

```
/ (root)
├── app/                      # App Shell (Projeto Flutter)
│   └── lib/
│       ├── main.dart         # Bootstrap
│       ├── app/              # Configuração (Routes, Theme, Providers globais)
│       └── features/         # Features isoladas (Package by Feature)
│           └── {feature}/
│               ├── application/  # UseCases, DTOs
│               ├── domain/       # Entities, Repository Interfaces
│               ├── infrastructure/ # Repository Impl, Data Sources
│               └── presentation/ # Pages, Widgets, ViewModels
│
├── packages/                 # Módulos reutilizáveis
│   ├── shared/               # Core, Utils, Library Exports
│   └── dori/                 # 🐠 Design System Dori
```

**Regras:**
- **Features** ficam em `app/lib/features/` com camadas internas (Clean Arch vertical).
- **Shared** e **Dori** são packages separados em `/packages/`.
- **NÃO existe** pasta `core/` ou `shared/` dentro de `app/lib/`.

### 2. Governança de Dependências (Baseado na ADR 003)
- **PROIBIDO:** Importar bibliotecas externas diretamente (ex: `package:dio`, `package:fpdart`) dentro de `app/lib/`.
- **OBRIGATÓRIO:** Usar arquivos de exportação em `packages/shared/lib/libraries/{nome_lib}_export.dart`.
    - Exemplo: `import 'package:shared/libraries/result_export.dart';`
- **Exceções (Allowlist):** `package:flutter/*`, `package:dart/*`, `package:shared/*`, `package:dori/*`.

### 3. Camada de Rede (Baseado na ADR 004)
- **NUNCA** instancie clientes HTTP concretos (Dio/Http) nos Repositórios.
- **SEMPRE** dependa da interface `ApiDataSourceDelegate` (em `shared`).
- A implementação concreta fica em `app/lib/features/{feature}/infrastructure/`.

### 4. Gestão de Estado e UI (Baseado na ADR 006)
- **Framework:** Utilize **Riverpod** para DI e State Management.
- **Command Pattern:** Ações de usuário encapsuladas em **Commands** (via `command_export.dart`).
- **Result Pattern:** Repositórios e UseCases retornam `Result<Success, Failure>`. **NÃO lance exceções**.

### 5. Cache Local (Baseado na ADR 007)
- Use a abstração `LocalCacheSource` para persistência.
- Suporte a políticas de **TTL (Time-To-Live)**.

## Regras de Coding e Workflow
- **Performance:** Avalie complexidade **Big O**. Prefira O(n) ou O(1).
- **Imutabilidade:** Use `equatable_export.dart`. **NÃO use `freezed`**.
- **Documentação:** Use `///` para Classes e Métodos públicos.
- **Finalização:** Execute `dart fix --apply` ao final.

## Validação Obrigatória Antes de Finalizar Tarefas (CRÍTICO)
**ANTES de informar ao usuário que a tarefa está concluída**, execute os seguintes comandos para garantir que a CI/CD passará:

```bash
# 1. Formatação (da raiz do repositório)
dart format .

# 2. Análise estática
cd app && flutter analyze && cd ..

# 3. Testes
cd app && flutter test && cd ..

# 4. Governança de imports
./scripts/check_imports.sh
```

**Se qualquer comando falhar, corrija os problemas antes de considerar a tarefa finalizada.** O desenvolvedor é responsável pelo commit — o Copilot apenas garante que o código está pronto para ser commitado.

## Regras de Testes (Baseado na ADR 008)
- **Escopo:** Apenas Testes Unitários.
- **Stack:** `mocktail_export.dart`, Pattern AAA.
- **Nomenclatura:** `should [resultado] when [cenário]`.

## Exemplos (Boilerplate)

### 1. Repository (dentro de uma feature)
```dart
// app/lib/features/product/infrastructure/repositories/product_repository.dart
import 'package:shared/libraries/result_export.dart';
import 'package:shared/drivers/api_data_source_delegate.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../../domain/entities/product.dart';

class ProductRepository implements IProductRepository {
  final ApiDataSourceDelegate _api;

  ProductRepository(this._api);

  @override
  Future<Result<List<Product>, Failure>> getProducts() async {
    try {
      final response = await _api.get('/products');
      final products = (response.data as List).map((e) => Product.fromMap(e)).toList();
      return Success(products);
    } catch (e) {
      return Failure(DefaultFailure(message: e.toString()));
    }
  }
}
```

### 2. ViewModel (Riverpod + Command)
```dart
// app/lib/features/product/presentation/view_models/product_list_view_model.dart
import 'package:shared/libraries/command_export.dart';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/i_product_repository.dart';

class ProductListViewModel extends ChangeNotifier {
  final IProductRepository _repository;

  late final Command0<List<Product>> fetchProductsCommand;

  List<Product> _products = [];
  List<Product> get products => _products;

  ProductListViewModel(this._repository) {
    fetchProductsCommand = Command0(() async {
      final result = await _repository.getProducts();
      return result.fold(
        (success) {
          _products = success;
          notifyListeners();
          return success;
        },
        (failure) => throw failure,
      );
    });
  }
}
```

## Especificações Funcionais
Consulte `documents/functional-specs.md` para regras de negócio.

---

## 🐠 Design System Dori (CRÍTICO)

> Consulte [`documents/adrs/009-design-system-dori.md`](../documents/adrs/009-design-system-dori.md) e [`documents/tokens-spec.md`](../documents/tokens-spec.md)

### Princípios
1. **SEMPRE** use tokens do Dori para cores, espaçamentos, tipografia e radius.
2. **NUNCA** defina valores hardcoded (`Colors.blue`, `8.0`, `SizedBox(height: 16)`).
3. **Acesse via `context.dori`** para garantir reatividade ao tema.

### Acesso a Tokens

```dart
Widget build(BuildContext context) {
  final dori = context.dori;
  
  return Container(
    // ✅ CORRETO - Usando tokens
    padding: EdgeInsets.all(dori.spacing.sm),
    decoration: BoxDecoration(
      color: dori.colors.surface.one,
      borderRadius: dori.radius.lg,
    ),
    child: Text(
      'Título',
      style: dori.typography.title5.copyWith(
        color: dori.colors.content.one,
      ),
    ),
  );
  
  // ❌ ERRADO - Valores hardcoded
  // padding: EdgeInsets.all(24),
  // color: Color(0xFFF8FAFC),
}
```

### Escala de Tokens

| Categoria | Tokens |
|-----------|--------|
| **Spacing** | `xxxs(4)`, `xxs(8)`, `xs(16)`, `sm(24)`, `md(32)`, `lg(48)`, `xl(64)` |
| **Radius** | `sm(8)`, `md(16)`, `lg(24)` |
| **Typography** | `title5`, `description`, `descriptionBold`, `caption`, `captionBold` |
| **Colors** | `brand.{pure,one,two}`, `surface.{pure,one,two}`, `content.{pure,one,two}`, `feedback.{success,error,info}` |

### Controle de Tema

```dart
// Definir tema
context.dori.setTheme(DoriThemeMode.dark);

// Alternar para inverso
context.dori.setTheme(context.dori.themeMode.inverse);

// Verificar modo atual
if (context.dori.isDark) { ... }
```

### Hierarquia de Componentes (Atomic Design)

| Precisa de... | Use |
|---------------|-----|
| Cor, espaçamento, tipografia | **Tokens** via `context.dori` |
| Texto, ícone, imagem | **Atoms** (ex: `DoriText`) |
| Campo de busca, toggle | **Molecules** (ex: `DoriSearchBar`) |
| Card de produto, AppBar | **Organisms** (ex: `DoriProductCard`) |

### Regras de Criação de Componentes Dori

1. **Prefixo obrigatório:** Todos componentes começam com `Dori` (ex: `DoriButton`)
2. **Localização:**
   - Atoms: `packages/dori/lib/src/atoms/`
   - Molecules: `packages/dori/lib/src/molecules/`
   - Organisms: `packages/dori/lib/src/organisms/`
3. **Barrels:** Exporte via barrel apropriado (ex: `dori_atoms.barrel.dart`)
4. **Acessibilidade:** WCAG AA obrigatório (contraste mínimo 4.5:1)

