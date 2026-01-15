# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Adicionado

#### Organisms
- 🃏 `DoriProductCard` — Pinterest-style card for product/content display
  - Props: `imageUrl`, `primaryText`, `secondaryText`, `badgeText`, `size`, `onTap`, `semanticLabel`, `imageBuilder`
  - Agnostic API: Uses `primaryText`/`secondaryText` instead of domain-specific names
  - Sizes: sm (3:4), md (4:5, default), lg (1:1)
  - Press animation: Scale 0.95 + Opacity 0.85 on tap (100ms duration)
  - Minimum press duration: 80ms for visual feedback on quick taps
  - Uses `Timer` for scheduled release (proper resource management)
  - Shimmer loading via `DoriShimmer` atom
  - Uses `DoriText` and `DoriBadge` atoms internally
  - Custom image builder support for caching libraries (cached_network_image)
  - Built-in accessibility with semantic labels (button semantics when tappable)
  - Respects `MediaQuery.disableAnimations` for reduced motion
  - Widgetbook story with sizes, content variants, shimmer demo, and grid layout

#### Atoms
- ✨ `DoriShimmer` — Reusable shimmer loading placeholder
  - Props: none (fully automatic)
  - 1500ms animation duration with `easeInOutSine` curve
  - Horizontal gradient from `surface.two` to `surface.three`
  - Proper `AnimationController` lifecycle management
  - Can be used standalone or composed in other widgets
- ⚛️ `DoriText` — Text widget with typography tokens
  - Props: `label`, `variant`, `color`, `maxLines`, `overflow`, `textAlign`
  - Default variant: `description` (14px Medium)
  - Widgetbook story with all variants showcase
- 🔣 `DoriIcon` — Icon widget with restricted icon set
  - Props: `icon`, `size`, `color`, `semanticLabel`
  - Sizes based on spacing tokens: sm (16dp), md (24dp), lg (32dp)
  - Built-in accessibility with semantic labels
  - Widgetbook story with icon gallery
- 🎯 `DoriIconData` — Enum of allowed icons
  - search, close, lightMode, darkMode, arrowBack, error, refresh
  - chevronRight, info, check, warning
  - Each icon has default semantic label for accessibility
- 🔘 `DoriIconButton` — Circular icon button
  - Props: `icon`, `onPressed`, `size`, `backgroundColor`, `iconColor`, `semanticLabel`
  - Sizes: sm (32dp total, 16dp icon), md (40dp total, 24dp icon)
  - 8dp padding between icon and border
  - Disabled state support with 0.5 opacity
  - Built-in accessibility with semantic labels
  - Widgetbook story with size variants and states
- 🏷️ `DoriBadge` — Badge for status, labels, or counts
  - Props: `label`, `variant`, `size`, `semanticLabel`
  - Variants: neutral, success, error, info
  - Sizes: sm (compact: 8dp horizontal), md (standard: 24dp horizontal)
  - Uses `DoriText` internally for text rendering
  - Uses explicit token colors (soft backgrounds, light text)
  - Neutral variant uses `surface.three` for better contrast
  - Subtle shadow using `DoriShadows.xs` token
  - Dark mode: soft backgrounds with light tinted text for contrast
  - Light mode: soft backgrounds with feedback colors for text
  - Border radius: md (16dp)
  - Built-in accessibility with semantic labels
  - Widgetbook story with variants, sizes and use cases
- 🔄 `DoriCircularProgress` — Morphing loading indicator (Material 3 inspired)
  - Props: `size`, `color`, `showBackground`, `semanticLabel`
  - Sizes: sm (16dp), md (24dp, default), lg (32dp)
  - Morphing animation between ellipse, pentagon, and starburst shapes
  - Continuous rotation with smooth shape transitions
  - Optional background halo using brand.two color
  - Uses `RepaintBoundary` for performance optimization
  - Built-in accessibility with semantic labels
- 🔲 `DoriButton` — Button with variants and loading state
  - Props: `label`, `onPressed`, `variant`, `size`, `leadingIcon`, `trailingIcon`, `isLoading`, `isExpanded`, `semanticLabel`
  - Variants: primary (filled), secondary (outlined), tertiary (text-only)
  - Sizes: sm (32dp height), md (44dp, default), lg (52dp)
  - Loading state shows `DoriCircularProgress` matching button color
  - Press animation with subtle scale (0.96)
  - Icon support (leading and/or trailing) using `DoriIcon`
  - Uses `DoriText` for label with size-appropriate typography
  - Disabled state with 0.5 opacity
  - Built-in accessibility with semantic labels

#### Tokens
- 🎨 `DoriFeedbackColors` — Novos tokens para backgrounds e texto
  - `successSoft`, `errorSoft`, `infoSoft` — Backgrounds suaves (Green/Red/Blue 100 light, 900 dark)
  - `successLight`, `errorLight`, `infoLight` — Texto com contraste (Green/Red/Blue 600 light, 300 dark)
  - Elimina uso de `withValues(alpha:)` para gerar cores semanticamente
- 🎨 `DoriSurfaceColors` — Novo token `three`
  - `surface.three` — Superfície terciária para maior contraste (Slate 200 light, Slate 700 dark)
  - Usado em badges neutral para destaque visual
- 🌑 `DoriShadows` — Sistema de tokens para sombras
  - Escala: xs, sm, md, lg
  - Adaptado para light/dark mode com opacidades diferentes
  - xs: blur 2, offset (0,1) — badges, chips
  - sm: blur 4, offset (0,2) — cards
  - md: blur 8, offset (0,4) — elementos flutuantes
  - lg: blur 16, offset (0,8) — modais, overlays

### Alterado

#### Tokens
- 🔘 `DoriRadius` — Nova escala de border radius
  - sm: 8dp (inputs, botões pequenos)
  - md: 16dp (badges, chips, botões) — **antes era 12dp**
  - lg: 24dp (cards, modais) — **antes era 16dp**

---

## [0.1.0] - 2025-01

### Adicionado

#### Tokens
- 🎨 `DoriColors` — Esquema de cores completo (light/dark)
  - Brand: `pure`, `one`, `two`
  - Surface: `pure`, `one`, `two`
  - Content: `pure`, `one`, `two`
  - Feedback: `success`, `error`, `info`
- 📐 `DoriSpacing` — Escala flat de espaçamento
  - `xxxs(4dp)`, `xxs(8dp)`, `xs(16dp)`, `sm(24dp)`, `md(32dp)`, `lg(48dp)`, `xl(64dp)`
- 🔘 `DoriRadius` — Border radius
  - `sm(8dp)`, `md(12dp)`, `lg(16dp)`
- 🔤 `DoriTypography` — Variantes tipográficas (Plus Jakarta Sans)
  - `title5`, `description`, `descriptionBold`, `caption`, `captionBold`

#### Theme
- 🎭 `DoriTheme` — ThemeData configurado para light e dark
- 🌓 `DoriThemeMode` — Enum com `light`, `dark`, `system` e propriedade `inverse`
- 🐠 `Dori` — Provider central com `context.dori` extension

#### Widgetbook
- 📚 Setup inicial com stories para tokens (colors, spacing, typography, radius)

### Alterado
- 📖 Documentação simplificada com escala flat de spacing

---

## [0.0.1] - 2025-01-14

### Adicionado
- 🎉 Release inicial do Design System Dori
- 📁 Estrutura base do pacote seguindo Atomic Design
- 📖 README.md com documentação completa
- ♿ Diretrizes de acessibilidade (WCAG 2.1 AA)
- 🧪 Estrutura de testes configurada

### Estrutura
- `src/tokens/` - Tokens de design (cores, tipografia, espaçamentos)
- `src/atoms/` - Componentes primitivos
- `src/molecules/` - Componentes compostos
- `src/organisms/` - Componentes complexos autônomos
- `src/animations/` - Animações reutilizáveis
- `src/theme/` - Configuração de temas (Light/Dark)
