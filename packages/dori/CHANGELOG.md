# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Adicionado

#### Atoms
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
  - Sizes: sm (compact), md (standard)
  - Semantic background colors with 25% opacity
  - Dark mode: uses `content.one` for text color (better contrast)
  - Light mode: uses feedback color for text
  - Horizontal padding: 16dp, vertical: 4dp (md) / 2dp (sm)
  - Border radius: md (16dp)
  - Built-in accessibility with semantic labels
  - Widgetbook story with variants, sizes and use cases

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
