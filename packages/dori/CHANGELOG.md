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
