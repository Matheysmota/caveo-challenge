# 🐠 Dori Design System

> **D.O.R.I.** — Design Oriented Reusable Interface

## Filosofia

> **"We forget, it remembers."**
> (Nós esquecemos, ele lembra.)

Assim como a personagem Dory do filme "Procurando Nemo" tem perda de memória recente, desenvolvedores frequentemente esquecem hex codes, paddings corretos e regras de acessibilidade. O Design System Dori existe como **memória persistente** — você não precisa decorar nada, apenas consultar.

---

## 📦 Instalação

No `pubspec.yaml` do seu projeto Flutter:

```yaml
dependencies:
  dori:
    path: ../packages/dori
```

Importe o barrel principal:

```dart
import 'package:dori/dori.dart';
```

---

## 🚀 Uso Rápido

### Configuração no MaterialApp

```dart
MaterialApp(
  theme: DoriTheme.light,
  darkTheme: DoriTheme.dark,
  themeMode: themeMode,
);
```

### Acessando Tokens via Context

```dart
Widget build(BuildContext context) {
  final dori = context.dori;

  return Container(
    padding: EdgeInsets.all(dori.spacing.sm),
    decoration: BoxDecoration(
      color: dori.colors.surface.one,
      borderRadius: dori.radius.lg,
    ),
    child: Text(
      'Hello Dori!',
      style: dori.typography.title5.copyWith(
        color: dori.colors.content.one,
      ),
    ),
  );
}
```

---

## 🎨 Tokens Disponíveis

### Colors

| Grupo | Tokens | Descrição |
|-------|--------|-----------|
| `brand` | `pure`, `one`, `two` | Identidade visual |
| `surface` | `pure`, `one`, `two` | Fundos e superfícies |
| `content` | `pure`, `one`, `two` | Textos e ícones |
| `feedback` | `success`, `error`, `info` | Estados de feedback |

### Spacing

| Token | Valor | Uso |
|-------|-------|-----|
| `xxxs` | 4dp | Micro espaço |
| `xxs` | 8dp | Entre itens próximos |
| `xs` | 16dp | Entre itens de lista |
| `sm` | 24dp | Padding de cards |
| `md` | 32dp | Entre seções |
| `lg` | 48dp | Margens de página |
| `xl` | 64dp | Espaços grandes |

### Radius

| Token | Valor | Uso |
|-------|-------|-----|
| `sm` | 8dp | Botões, inputs, badges |
| `md` | 12dp | Cards pequenos, chips |
| `lg` | 16dp | Cards principais, modais |

### Typography

| Token | Tamanho | Peso |
|-------|---------|------|
| `title5` | 24px | ExtraBold (800) |
| `description` | 14px | Medium (500) |
| `descriptionBold` | 14px | Bold (700) |
| `caption` | 12px | Medium (500) |
| `captionBold` | 12px | Bold (700) |

> **Nota:** A tipografia usa a fonte `Plus Jakarta Sans`. O app consumidor deve incluir a fonte em seu `pubspec.yaml`. Veja a seção [Configuração de Fonte](#-configuração-de-fonte).

---

## 🎭 Controle de Tema

### Verificar tema atual

```dart
final isDark = context.dori.isDark;
final isLight = context.dori.isLight;
```

### Alterar tema (requer configuração)

Para habilitar `setTheme()`, configure com callbacks:

```dart
final dori = Dori.of(
  context,
  onThemeChanged: (mode) => ref.read(themeModeProvider.notifier).state = mode.toThemeMode(),
  themeModeGetter: () => DoriThemeMode.fromThemeMode(ref.read(themeModeProvider)),
);

// Agora você pode:
dori.setTheme(DoriThemeMode.dark);
dori.setTheme(dori.themeMode.inverse);
```

---

## 🔤 Configuração de Fonte

O Dori usa **Plus Jakarta Sans**. Para que a tipografia funcione corretamente, adicione a fonte no app consumidor:

1. Baixe a fonte do [Google Fonts](https://fonts.google.com/specimen/Plus+Jakarta+Sans)
2. Adicione os arquivos em `assets/fonts/`
3. Configure no `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: PlusJakartaSans
      fonts:
        - asset: assets/fonts/PlusJakartaSans-Medium.ttf
          weight: 500
        - asset: assets/fonts/PlusJakartaSans-Bold.ttf
          weight: 700
        - asset: assets/fonts/PlusJakartaSans-ExtraBold.ttf
          weight: 800
```

> Se a fonte não for configurada, o sistema usará a fonte padrão da plataforma.

---

## ⚛️ Atoms

### DoriText

Text widget with Dori typography tokens.

```dart
// Basic usage (defaults to description style)
DoriText(label: 'Hello, World!')

// With typography variant
DoriText(
  label: 'Products',
  variant: DoriTypographyVariant.title5,
)

// With custom color
DoriText(
  label: 'Subtitle',
  variant: DoriTypographyVariant.caption,
  color: context.dori.colors.content.two,
)

// With overflow handling
DoriText(
  label: 'Very long text that might overflow...',
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `String` | **required** | Text to display |
| `variant` | `DoriTypographyVariant` | `description` | Typography style |
| `color` | `Color?` | `null` | Text color |
| `maxLines` | `int?` | `null` | Max lines |
| `overflow` | `TextOverflow?` | `null` | Overflow behavior |
| `textAlign` | `TextAlign?` | `null` | Text alignment |

### DoriIcon

Icon widget with restricted icon set and Dori tokens.

```dart
// Basic usage with default size (md = 24dp)
DoriIcon(icon: DoriIconData.search)

// With custom size
DoriIcon(
  icon: DoriIconData.close,
  size: DoriIconSize.sm,
)

// With custom color
DoriIcon(
  icon: DoriIconData.lightMode,
  color: context.dori.colors.brand.pure,
)

// With custom semantic label (accessibility)
DoriIcon(
  icon: DoriIconData.arrowBack,
  semanticLabel: 'Return to previous screen',
)
```

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `icon` | `DoriIconData` | **required** | Icon from allowed set |
| `size` | `DoriIconSize` | `md` | Icon size (sm=16, md=24, lg=32) |
| `color` | `Color?` | `null` | Icon color |
| `semanticLabel` | `String?` | `null` | Accessibility label |

**Available Icons (`DoriIconData`):**

| Icon | Name | Use Case |
|------|------|----------|
| 🔍 | `search` | AppBar search button |
| ✕ | `close` | Close buttons, clear |
| ☀️ | `lightMode` | Theme toggle (in dark) |
| 🌙 | `darkMode` | Theme toggle (in light) |
| ← | `arrowBack` | Navigation back |
| ⚠️ | `error` | Error states |
| 🔄 | `refresh` | Refresh actions |
| › | `chevronRight` | List navigation |
| ℹ️ | `info` | Information |
| ✓ | `check` | Success states |
| ⚡ | `warning` | Warning states |

### DoriIconButton

Circular icon button with Dori tokens.

```dart
// Basic usage with default size (md = 40dp)
DoriIconButton(
  icon: DoriIconData.search,
  onPressed: () => print('Pressed!'),
)

// Small size (32dp)
DoriIconButton(
  icon: DoriIconData.close,
  size: DoriIconButtonSize.sm,
  onPressed: () {},
)

// With custom colors
DoriIconButton(
  icon: DoriIconData.lightMode,
  backgroundColor: context.dori.colors.brand.pure,
  iconColor: context.dori.colors.surface.pure,
  onPressed: () {},
)

// Disabled state
DoriIconButton(
  icon: DoriIconData.refresh,
  onPressed: null, // null = disabled
)

// With custom semantic label (accessibility)
DoriIconButton(
  icon: DoriIconData.arrowBack,
  semanticLabel: 'Return to previous screen',
  onPressed: () => Navigator.pop(context),
)
```

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `icon` | `DoriIconData` | **required** | Icon from allowed set |
| `onPressed` | `VoidCallback?` | **required** | Tap callback (null = disabled) |
| `size` | `DoriIconButtonSize` | `md` | Button size (sm=32dp, md=40dp) |
| `backgroundColor` | `Color?` | `null` | Background color |
| `iconColor` | `Color?` | `null` | Icon color |
| `semanticLabel` | `String?` | `null` | Accessibility label |

**Size Reference:**

| Size | Total | Padding | Icon |
|------|-------|---------|------|
| `sm` | 32dp | 8dp | 16dp |
| `md` | 40dp | 8dp | 24dp |

---

## 📚 Documentação

- **ADR 009:** [Design System Dori — Arquitetura e Convenções](../../documents/adrs/009-design-system-dori.md)
- **Tokens Spec:** [Especificação Completa de Tokens](../../documents/tokens-spec.md)
- **Widgetbook:** Execute `cd packages/dori/example && flutter run` para ver o catálogo visual

---

## 📁 Estrutura

```
packages/dori/
├── lib/
│   ├── src/
│   │   ├── atoms/        # DoriText, DoriIcon, DoriBadge, DoriButton, DoriShimmer
│   │   ├── organisms/    # DoriProductCard
│   │   ├── tokens/       # Colors, Spacing, Radius, Typography
│   │   └── theme/        # DoriTheme, DoriProvider
│   └── dori.dart         # Barrel principal
├── example/              # Widgetbook
└── test/
```

---

## 🦠 Organisms

### DoriProductCard

Pinterest-style card for product/content display with shimmer loading and press animation.

```dart
// Basic usage
DoriProductCard(
  imageUrl: 'https://example.com/product.jpg',
  primaryText: 'Product Name',
)

// With all options
DoriProductCard(
  imageUrl: 'https://example.com/product.jpg',
  primaryText: 'Premium Headphones',
  secondaryText: 'R\$ 299,90',
  badgeText: 'NEW',
  size: DoriProductCardSize.lg,
  onTap: () => print('Card tapped!'),
)

// With custom image builder (e.g., cached_network_image)
DoriProductCard(
  imageUrl: imageUrl,
  primaryText: 'Product',
  imageBuilder: (context, url) => CachedNetworkImage(
    imageUrl: url,
    fit: BoxFit.cover,
  ),
)
```

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `imageUrl` | `String` | **required** | URL of the product image |
| `primaryText` | `String` | **required** | Main text (e.g., product name) |
| `secondaryText` | `String?` | `null` | Secondary text (e.g., price) |
| `badgeText` | `String?` | `null` | Badge label (e.g., category, status) |
| `size` | `DoriProductCardSize` | `md` | Card size variant |
| `onTap` | `VoidCallback?` | `null` | Tap callback (enables press animation) |
| `semanticLabel` | `String?` | `null` | Custom accessibility label |
| `imageBuilder` | `Widget Function(BuildContext, String)?` | `null` | Custom image builder |

**Size Reference:**

| Size | Aspect Ratio | Use Case |
|------|--------------|----------|
| `sm` | 3:4 (0.75) | Compact grids, small thumbnails |
| `md` | 4:5 (0.80) | Standard product cards |
| `lg` | 1:1 (1.00) | Featured products, hero cards |

**Features:**
- 🎭 **Press Animation:** Scale 0.95 + Opacity 0.85 with 80ms minimum duration
- ✨ **Shimmer Loading:** Automatic shimmer effect while image loads
- ♿ **Accessibility:** Full semantic support with button role when tappable
- 🎬 **Reduced Motion:** Respects system accessibility settings

---

## ✨ Atoms (continued)

### DoriShimmer

Reusable shimmer loading placeholder with animated gradient.

```dart
// Basic usage (fills parent container)
Container(
  width: 200,
  height: 100,
  child: DoriShimmer(),
)

// Inside a card or skeleton
AspectRatio(
  aspectRatio: 4 / 5,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: DoriShimmer(),
  ),
)
```

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| (none) | — | — | Fully automatic, no configuration needed |

**Animation Details:**
- Duration: 1500ms
- Curve: `Curves.easeInOutSine`
- Colors: `surface.two` → `surface.three` (theme-aware)

---

*Mantido pelo time de Design System • Janeiro/2026*
