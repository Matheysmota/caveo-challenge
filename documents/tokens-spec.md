# 🎨 Dori Design Tokens Specification

> Especificação técnica completa dos tokens do Design System Dori.

Este documento serve como **fonte da verdade** para implementação dos tokens. Para filosofia e arquitetura geral, consulte a [ADR 009](adrs/009-design-system-dori.md).

---

## 📖 Sumário

1. [Acesso via Código](#acesso-via-código)
2. [Typography](#typography)
3. [Colors](#colors)
4. [Spacing](#spacing)
5. [Radius](#radius)
6. [Theme Management](#theme-management)

---

## Acesso via Código

### API Principal

```dart
// Padrão Flutter
final dori = Dori.of(context);

// Syntax sugar (extension)
final dori = context.dori;

// Acessando tokens
final spacing = dori.tokens.spacing;
final colors = dori.tokens.colors;
final radius = dori.tokens.radius;

// Verificando tema atual
final isDark = dori.brightness == Brightness.dark;
```

### Exemplo Completo

```dart
Widget build(BuildContext context) {
  final tokens = context.dori.tokens;
  
  return Container(
    padding: EdgeInsets.all(tokens.spacing.inset.sm),
    decoration: BoxDecoration(
      color: tokens.colors.surface.one,
      borderRadius: tokens.radius.lg,
    ),
    child: Column(
      children: [
        SizedBox(height: tokens.spacing.stack.xxxs),
        DoriText(
          label: 'Produtos',
          type: DoriTypography.title5,
        ),
        SizedBox(height: tokens.spacing.stack.xxs),
        DoriText(
          label: 'Confira nossa seleção',
          type: DoriTypography.description,
          color: tokens.colors.content.two,
        ),
      ],
    ),
  );
}
```

---

## Typography

### Variantes Disponíveis

| Token | Tamanho | Peso | Uso |
|-------|---------|------|-----|
| `title5` | 24px | ExtraBold (800) | Títulos principais |
| `description` | 14px | Medium (500) | Texto padrão **(default)** |
| `descriptionBold` | 14px | Bold (700) | Texto padrão com destaque |
| `caption` | 12px | Medium (500) | Texto pequeno, labels |
| `captionBold` | 12px | Bold (700) | Texto pequeno com destaque |

### Font Family

**Plus Jakarta Sans** — Pesos: 500, 700, 800

### Componente DoriText

```dart
DoriText(
  label: 'Texto obrigatório',           // required
  type: DoriTypography.description,     // default: description
  color: tokens.colors.content.one,     // default: content.one
  maxLines: 2,                          // opcional
  overflow: TextOverflow.ellipsis,      // opcional
);
```

**Nota:** O componente é **agnóstico a formatação de negócio**. Formatação de preços, datas, moedas, etc. é responsabilidade do domínio/feature, não do Design System.

---

## Colors

### Estrutura

```
colors
├── brand      → Identidade visual da marca
├── surface    → Fundos e superfícies
├── content    → Textos e ícones
└── feedback   → Estados de feedback
```

### Brand (Identidade Visual)

| Token | Light Mode | Dark Mode | Uso |
|-------|------------|-----------|-----|
| `brand.pure` | Indigo 600 `#4F46E5` | Indigo 400 `#818CF8` | Cor pura da marca |
| `brand.one` | Indigo 900 `#312E81` | Indigo 300 `#A5B4FC` | Variação primária |
| `brand.two` | Indigo 100 `#E0E7FF` | Indigo 900 `#312E81` | Variação secundária |

### Surface (Superfícies)

| Token | Light Mode | Dark Mode | Uso |
|-------|------------|-----------|-----|
| `surface.pure` | White `#FFFFFF` | Slate 950 `#020617` | Superfície máximo contraste |
| `surface.one` | Slate 50 `#F8FAFC` | Slate 900 `#0F172A` | Fundo de cards (primário) |
| `surface.two` | Slate 100 `#F1F5F9` | Slate 800 `#1E293B` | Fundo secundário |

### Content (Textos e Ícones)

| Token | Light Mode | Dark Mode | Uso |
|-------|------------|-----------|-----|
| `content.pure` | Slate 950 `#020617` | White `#FFFFFF` | Texto máximo contraste |
| `content.one` | Slate 900 `#0F172A` | Slate 50 `#F8FAFC` | Texto primário **(default)** |
| `content.two` | Slate 500 `#64748B` | Slate 400 `#94A3B8` | Texto secundário |

### Feedback (Estados)

| Token | Cor | Uso |
|-------|-----|-----|
| `feedback.success` | Green 600 `#16A34A` | Sucesso, confirmação |
| `feedback.error` | Red 600 `#DC2626` | Erro, ação destrutiva |
| `feedback.info` | Blue 600 `#2563EB` | Informação, destaque neutro |

---

## Spacing

### Estrutura

```
spacing
├── inline    → Espaçamento horizontal (entre elementos lado a lado)
├── stack     → Espaçamento vertical (entre elementos empilhados)
└── inset     → Padding interno (todos os lados)
```

### Escala

| Token | Valor | Exemplo de Uso |
|-------|-------|----------------|
| `xxxs` | 4dp | Micro espaço, entre ícone e texto |
| `xxs` | 8dp | Entre itens muito próximos |
| `xs` | 16dp | Entre itens de lista |
| `sm` | 24dp | Padding de cards |
| `md` | 32dp | Entre seções |
| `lg` | 48dp | Margens de página |
| `xl` | 64dp | Espaços grandes, hero sections |

### Uso

```dart
// Horizontal (entre botões lado a lado)
Row(
  children: [
    Button1(),
    SizedBox(width: tokens.spacing.inline.xxs),
    Button2(),
  ],
);

// Vertical (entre título e conteúdo)
Column(
  children: [
    Title(),
    SizedBox(height: tokens.spacing.stack.xs),
    Content(),
  ],
);

// Padding interno
Container(
  padding: EdgeInsets.all(tokens.spacing.inset.sm),
  child: CardContent(),
);
```

---

## Radius

### Escala

| Token | Valor | Uso |
|-------|-------|-----|
| `sm` | 8dp | Botões, inputs, badges |
| `md` | 12dp | Cards pequenos, chips |
| `lg` | 16dp | Cards principais, modais |

### Uso

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: tokens.radius.md,
  ),
);

// Ou via helper
ClipRRect(
  borderRadius: tokens.radius.lg,
  child: Image(...),
);
```

---

## Theme Management

### Filosofia

O Dori **reage** ao tema, não o controla. O controle fica no App via state management (Riverpod).

### Interface Fornecida pelo Dori

```dart
/// Contrato que o App deve implementar para controle de tema
abstract class DoriThemeModeProvider {
  /// Tema atual
  ThemeMode get themeMode;
  
  /// Define um tema específico
  void setThemeMode(ThemeMode mode);
  
  /// Alterna entre light e dark
  void toggleThemeMode();
}
```

### Implementação no App (Riverpod)

```dart
// providers/theme_provider.dart
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// Implementação do contrato Dori
class AppThemeModeProvider implements DoriThemeModeProvider {
  final Ref _ref;
  
  AppThemeModeProvider(this._ref);
  
  @override
  ThemeMode get themeMode => _ref.read(themeModeProvider);
  
  @override
  void setThemeMode(ThemeMode mode) {
    _ref.read(themeModeProvider.notifier).state = mode;
  }
  
  @override
  void toggleThemeMode() {
    final current = themeMode;
    setThemeMode(
      current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }
}
```

### Configuração no MaterialApp

```dart
MaterialApp(
  theme: DoriTheme.light,
  darkTheme: DoriTheme.dark,
  themeMode: ref.watch(themeModeProvider),
);
```

### Uso do DoriThemeToggle

```dart
DoriThemeToggle(
  themeModeProvider: ref.read(appThemeModeProvider),
);
```

---

## Checklist de Implementação

- [ ] Criar `DoriTokens` class com subclasses (colors, spacing, radius)
- [ ] Criar `DoriTheme.light` e `DoriTheme.dark`
- [ ] Criar `DoriThemeExtension` para acesso via context
- [ ] Criar extension `context.dori`
- [ ] Criar `DoriThemeModeProvider` interface
- [ ] Criar `DoriText` component
- [ ] Adicionar fonte Plus Jakarta Sans
- [ ] Testes unitários para tokens
- [ ] Testes de acessibilidade (contraste)

---

*Documento mantido pelo time de Design System. Última atualização: 14/01/2026*
