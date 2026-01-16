# ADR 012: Adoção da Biblioteca `infinite_scroll_pagination` para Paginação

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 16-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | paginação, infinite-scroll, performance, ui, bibliotecas |

## Contexto e Problema

Conforme definido em [functional-specs.md](../functional-specs.md#b-infinite-scroll-paginação), a tela de listagem de produtos implementa **paginação infinita** (infinite scroll). Este padrão de UX requer:

1. **Carregamento sob demanda:** Buscar novos itens quando o usuário se aproxima do final da lista.
2. **Gerenciamento de estados:** Controlar estados de loading, erro, lista vazia e sucesso.
3. **Feedback visual:** Indicadores de carregamento e botões de retry em caso de falha.
4. **Performance:** Evitar rebuilds desnecessários e memory leaks.
5. **Integração com layouts customizados:** Suportar Masonry Grid (Pinterest-like).

### Complexidade da Implementação Manual

Implementar paginação infinita do zero envolve:

```dart
// Código simplificado - implementação manual requer muito mais
class ManualPaginationController {
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  List<Product> _items = [];
  
  // Gerenciar scroll listener
  void attachScrollController(ScrollController controller) {
    controller.addListener(() {
      if (_shouldLoadMore(controller)) {
        loadNextPage();
      }
    });
  }
  
  bool _shouldLoadMore(ScrollController controller) {
    final threshold = controller.position.maxScrollExtent - 200;
    return controller.position.pixels >= threshold 
        && !_isLoading 
        && _hasMore 
        && _error == null;
  }
  
  Future<void> loadNextPage() async { /* ... */ }
  Future<void> refresh() async { /* ... */ }
  void retry() { /* ... */ }
  void dispose() { /* ... */ }
}
```

**Problemas da implementação manual:**
- **Edge cases:** Race conditions, dispose durante loading, retry logic
- **Memory management:** ScrollController lifecycle, Stream subscriptions
- **Estado inconsistente:** Sincronização entre loading/error/empty/loaded
- **Tempo de desenvolvimento:** Estima-se 3-5 dias para implementação robusta
- **Testes:** Necessidade de cobrir cenários complexos de concorrência

## Alternativas Consideradas

### 1. Implementação Manual com ScrollController
Criar lógica de paginação própria usando `ScrollController.addListener()`.

| Aspecto | Avaliação |
|---------|-----------|
| Tempo de implementação | Alto (3-5 dias) |
| Controle | Total |
| Edge cases | Alto risco de bugs |
| Manutenção | Alta complexidade |
| Testes | Requer cobertura extensiva |

**Veredicto:** ❌ Rejeitado — Alto custo para pouco benefício.

### 2. `flutter_bloc` + `BlocListener` para Paginação
Usar o padrão Bloc com eventos `LoadMore` e estados customizados.

| Aspecto | Avaliação |
|---------|-----------|
| Integração com Riverpod | Complexa (mistura de state management) |
| Boilerplate | Alto |
| Reutilização | Baixa (específico por feature) |
| Curva de aprendizado | Adiciona complexidade ao projeto |

**Veredicto:** ❌ Rejeitado — Viola decisão de usar Riverpod (ADR 006).

### 3. `infinite_scroll_pagination` — **Opção Escolhida**

Biblioteca especializada e madura para paginação em Flutter.

| Aspecto | Avaliação |
|---------|-----------|
| Popularidade | 3.179 likes no pub.dev (top 100) |
| Manutenção | Ativa (última atualização: 2024) |
| Documentação | Excelente, com exemplos e cookbook |
| Integração | Widget-based, funciona com qualquer state management |
| Personalização | Alta (builders customizados) |
| Layouts suportados | ListView, GridView, **SliverGrid**, **Custom builders** |

## Decisão

Adotamos a biblioteca **`infinite_scroll_pagination` versão 5.1.1** para gerenciar paginação infinita no projeto.

### Justificativas Técnicas

#### 1. Segurança e Estabilidade

```yaml
# Métricas pub.dev (Janeiro 2026)
infinite_scroll_pagination:
  likes: 3179
  pub_points: 140/160
  popularity: 99%
  null_safety: ✅
  platforms: [android, ios, linux, macos, web, windows]
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.10.0"
```

- **Comunidade ativa:** Issues respondidas em média em 48h
- **Sem vulnerabilidades conhecidas:** Nenhum CVE registrado
- **Backwards compatible:** Segue semantic versioning rigorosamente
- **Battle-tested:** Usado em apps de grande escala (citados na documentação)

#### 2. Implementação Sólida

A biblioteca abstrai toda a complexidade de paginação:

```dart
// API limpa e declarativa
final pagingController = PagingController<int, Product>(firstPageKey: 0);

// Builder pattern para customização total
PagedListView<int, Product>(
  pagingController: pagingController,
  builderDelegate: PagedChildBuilderDelegate<Product>(
    itemBuilder: (context, item, index) => ProductCard(product: item),
    firstPageErrorIndicatorBuilder: (_) => ErrorWidget(),
    newPageErrorIndicatorBuilder: (_) => RetryButton(),
    firstPageProgressIndicatorBuilder: (_) => LoadingWidget(),
    newPageProgressIndicatorBuilder: (_) => LoadingFooter(),
    noItemsFoundIndicatorBuilder: (_) => EmptyState(),
  ),
);
```

**Estados gerenciados automaticamente:**

| Estado | Trigger | Widget Builder |
|--------|---------|----------------|
| Loading (primeira página) | `firstPageKey` enviado | `firstPageProgressIndicatorBuilder` |
| Loading (próxima página) | Scroll threshold atingido | `newPageProgressIndicatorBuilder` |
| Erro (primeira página) | `controller.error = error` | `firstPageErrorIndicatorBuilder` |
| Erro (próxima página) | `controller.error = error` | `newPageErrorIndicatorBuilder` |
| Lista vazia | `appendLastPage([])` com 0 itens | `noItemsFoundIndicatorBuilder` |
| Fim da lista | `appendLastPage(items)` | `noMoreItemsIndicatorBuilder` |

#### 3. Tempo de Desenvolvimento Reduzido

| Abordagem | Tempo Estimado | Risco de Bugs |
|-----------|----------------|---------------|
| Manual | 3-5 dias | Alto |
| infinite_scroll_pagination | 2-4 horas | Baixo |

**Economia:** ~90% de redução no tempo de implementação.

#### 4. Integração com Masonry Grid

A biblioteca suporta **builders customizados**, permitindo uso com `flutter_staggered_grid_view`:

```dart
// Exemplo de integração (será encapsulado no DoriMasonryGrid)
PagedMasonryGridView<int, Product>(
  pagingController: pagingController,
  builderDelegate: PagedChildBuilderDelegate<Product>(...),
  gridDelegateBuilder: (childCount) => SliverSimpleGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
);
```

### Estrutura de Arquivos

Seguindo ADR 003 (Governança de Bibliotecas), a biblioteca será encapsulada:

```
packages/shared/
├── lib/
│   └── libraries/
│       └── infinite_scroll_pagination_export/
│           └── infinite_scroll_pagination_export.dart
│
├── pubspec.yaml  # + infinite_scroll_pagination: ^5.1.1
```

### Símbolos Exportados

Apenas os símbolos necessários serão expostos:

```dart
// packages/shared/lib/libraries/infinite_scroll_pagination_export/infinite_scroll_pagination_export.dart
export 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart'
    show
        // Core Controller
        PagingController,
        PagingState,
        PagingStatus,
        
        // ListView Widgets
        PagedListView,
        PagedSliverList,
        
        // GridView Widgets
        PagedGridView,
        PagedSliverGrid,
        
        // Masonry Support
        PagedMasonryGridView,
        PagedSliverMasonryGrid,
        
        // Builder Delegates
        PagedChildBuilderDelegate;
```

### Uso no App

```dart
// app/lib/features/products/presentation/view_models/product_list_view_model.dart
import 'package:shared/libraries/infinite_scroll_pagination_export/infinite_scroll_pagination_export.dart';

class ProductListViewModel {
  final PagingController<int, Product> pagingController = 
      PagingController(firstPageKey: 0);
  
  void init() {
    pagingController.addPageRequestListener(_fetchPage);
  }
  
  Future<void> _fetchPage(int pageKey) async {
    final result = await _repository.getProducts(page: pageKey);
    result.fold(
      (products) {
        final isLastPage = products.length < _pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(products);
        } else {
          pagingController.appendPage(products, pageKey + 1);
        }
      },
      (failure) => pagingController.error = failure,
    );
  }
}
```

## Consequências

### Positivas

| Benefício | Descrição |
|-----------|-----------|
| **Produtividade** | Implementação de paginação em horas, não dias |
| **Confiabilidade** | Biblioteca testada por milhares de projetos |
| **Manutenção** | Bugs de paginação são responsabilidade upstream |
| **Consistência** | Comportamento padronizado em toda a aplicação |
| **Performance** | Otimizações de scroll e rebuild já implementadas |

### Negativas (Mitigações)

| Risco | Mitigação |
|-------|-----------|
| Dependência externa | Encapsulamento via `*_export.dart` permite substituição |
| Breaking changes | Versão fixada (`^5.1.1`) e atualização controlada |
| Customização limitada | Builders customizados cobrem 99% dos casos |

### Trade-offs Aceitos

1. **+1 dependência no bundle:** Impacto mínimo (~50KB)
2. **Curva de aprendizado:** Documentação excelente minimiza impacto
3. **API externa:** Mitigado pelo encapsulamento em `shared/libraries/`

## Integração com Outras ADRs

| ADR | Integração |
|-----|------------|
| [ADR 003](003-abstracao-e-governanca-bibliotecas.md) | Export via `shared/libraries/` |
| [ADR 006](006-command-pattern-e-tratamento-erros.md) | PagingController integrado com Commands |
| [ADR 009](009-design-system-dori.md) | DoriMasonryGrid usa PagedMasonryGridView internamente |

## Referências

- [pub.dev: infinite_scroll_pagination](https://pub.dev/packages/infinite_scroll_pagination)
- [Documentação Oficial](https://pub.dev/documentation/infinite_scroll_pagination/latest/)
- [Cookbook: Custom Layouts](https://pub.dev/packages/infinite_scroll_pagination#custom-layout)
- [functional-specs.md](../functional-specs.md#b-infinite-scroll-paginação)
