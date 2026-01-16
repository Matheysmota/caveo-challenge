# ADR 011: Splash Screen Architecture

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 15-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | splash, inicialização, ux, performance, navegação |

## Contexto e Problema

O aplicativo precisa de uma tela de inicialização (Splash Screen) que:

1. Forneça feedback visual imediato ao usuário enquanto o app carrega
2. Execute operações de bootstrap em background sem janks
3. Carregue o primeiro lote de dados (produtos) da API ou cache
4. Navegue para a tela correta baseado no resultado da inicialização
5. Mantenha animações a 60fps+ independente do processamento

### Requisitos de Negócio (de `functional-specs.md`)

```
Splash Screen → Fluxo de Inicialização:
1. Busca API (lote 1 de produtos)
   ├── Sucesso → Salva cache → ProductList
   └── Falha → Busca Cache
               ├── Cache existe → ProductList
               └── Cache vazio → ErrorScreen
```

## Decisão

### 1. Arquitetura em Duas Camadas

```
┌─────────────────────────────────────────────────────────────────┐
│                    SPLASH NATIVA (Android/iOS)                  │
│                                                                 │
│  • Aparece instantaneamente antes do Flutter Engine             │
│  • Apenas backgroundColor (sem logo)                            │
│  • Cor: surface.one (light: #F8FAFC, dark: #0F172A)             │
│  • Implementação: flutter_native_splash package                 │
│  • Duração: ~50-200ms (tempo de attach do engine)               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      SPLASH FLUTTER                             │
│                                                                 │
│  • Logo Fish (SVG colorida) centralizada                        │
│  • DoriCircularProgress abaixo da logo                          │
│  • Carregamento de dados em background                          │
│  • Tempo mínimo de exibição: 1 segundo                          │
│  • Timeout máximo: 10 segundos                                  │
│  • Transição suave (Fade) para próxima tela                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 2. Fluxo de Inicialização

```
┌─────────────────────────────────────────────────────────────────┐
│                         main()                                  │
│  1. WidgetsFlutterBinding.ensureInitialized()                   │
│  2. LocalCacheSource.create() ← AWAIT (crítico)                 │
│  3. Carregar tema salvo (sync read)                             │
│  4. runApp(ProviderScope(...))                                  │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      SplashPage                                 │
│                                                                 │
│  initState():                                                   │
│    _minimumTimer = Timer(1s, _onMinimumTimeElapsed)             │
│    _timeoutTimer = Timer(10s, _onTimeout)                       │
│    _loadData()                                                  │
│                                                                 │
│  _loadData():                                                   │
│    result = await productRepository.getProducts(page: 1)        │
│    if (result.isSuccess) → _onDataLoaded(success)               │
│    else → result = await productRepository.getFromCache()       │
│           if (result.isSuccess) → _onDataLoaded(stale)          │
│           else → _onDataFailed()                                │
│                                                                 │
│  Navegação:                                                     │
│    if (minimumTimeElapsed && dataState == success/stale)        │
│      → context.go('/products')                                  │
│    if (dataState == failed || timeout)                          │
│      → setState(errorState) // Mostra UI de erro na splash      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 3. Estados da Splash

```dart
enum SplashState {
  /// Initial state, logo and loading visible.
  loading,
  
  /// Data loaded successfully from API.
  success,
  
  /// Data loaded from cache (API failed).
  successStale,
  
  /// Both API and cache failed, showing error UI.
  error,
  
  /// Timeout reached (10s), showing error UI.
  timeout,
}
```

### 4. ErrorScreen como Estado da Splash

A tela de erro **NÃO é uma rota separada**. É um estado visual da `SplashPage`:

```
SplashPage
├── state == loading    → Logo + DoriCircularProgress
├── state == success    → (navega para /products)
├── state == stale      → (navega para /products)
├── state == error      → Ilustração + Mensagem + Botão "Tentar novamente"
└── state == timeout    → Ilustração + Mensagem + Botão "Tentar novamente"
```

### 5. Timers (não Future.delayed)

**Decisão:** Usar `Timer` ao invés de `Future.delayed` para:
- Controle explícito de cancelamento
- Dispose garantido no ciclo de vida do widget
- Código mais legível e debugável

```dart
class _SplashPageState extends State<SplashPage> {
  Timer? _minimumTimer;
  Timer? _timeoutTimer;

  @override
  void dispose() {
    _minimumTimer?.cancel();
    _timeoutTimer?.cancel();
    super.dispose();
  }
}
```

### 6. Performance (60fps+)

| Técnica | Implementação |
|---------|---------------|
| **Pre-init no main()** | LocalCacheSource inicializado antes do runApp |
| **Nenhum await no build()** | Toda operação async em initState/ViewModel |
| **Primeiro frame leve** | Logo SVG + Loading são widgets simples |
| **AnimationController com vsync** | Sincronização com refresh rate |
| **Dispose de recursos** | Timers, controllers cancelados no dispose |

### 7. Conectividade

**Decisão:** A Splash **NÃO verifica conectividade** diretamente.

- Fluxo simplificado: API → Cache → Error
- O `ConnectivityObserver` é usado apenas na tela de Produtos (banner reativo)
- A API call falhar já indica problema de rede (não precisa checar antes)

### 8. Navegação

**Router:** go_router 17.0.1

```dart
// Rotas do app
sealed class AppRoutes {
  static const String splash = '/';
  static const String products = '/products';
  static const String productDetails = '/products/:id';
}

// Navegação da Splash (substitui stack, não permite voltar)
context.go(AppRoutes.products);
```

**Transição:** Fade (Splash → Products)

## Consequências

### Positivas

- **UX suave:** Splash nativa instantânea + Flutter com logo branded
- **Performance garantida:** Pre-init de recursos críticos no main()
- **Simplicidade:** ErrorScreen como estado, não rota separada
- **Manutenibilidade:** Fluxo claro e documentado
- **Testabilidade:** Estados bem definidos, fácil de testar

### Trade-offs

- **Splash nativa sem logo:** Transição menos "seamless" que Lottie
- **Pre-init bloqueia:** ~50-100ms antes do Flutter renderizar
- **Timer requer dispose:** Mais código que Future.delayed

### Evolução Futura

- **Animação da logo:** Fade-in + Scale quando tivermos tempo
- **Lottie na splash nativa:** Se necessário branding mais forte
- **Retry automático:** Tentar novamente após X segundos

## Referências

- [functional-specs.md](../functional-specs.md) — Requisitos de negócio
- [ADR 006](006-command-pattern-e-tratamento-erros.md) — Command Pattern
- [ADR 009](009-design-system-dori.md) — Design System Dori
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) — Package utilizado
