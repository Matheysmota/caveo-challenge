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

## 🏗️ Arquitetura: Atomic Design

O Dori segue o padrão **Atomic Design** de Brad Frost, adaptado para Flutter:

```
┌─────────────────────────────────────────────────────────────┐
│                        ORGANISMS                            │
│   Componentes autônomos e complexos com estado próprio      │
│   Ex: DoriAppBar, DoriProductCard                           │
├─────────────────────────────────────────────────────────────┤
│                        MOLECULES                            │
│   Combinações simples de atoms com uma função específica    │
│   Ex: DoriSearchBar, DoriThemeToggle, DoriLoadingIndicator  │
├─────────────────────────────────────────────────────────────┤
│                          ATOMS                              │
│   Elementos primitivos e indivisíveis                       │
│   Ex: DoriText, DoriIcon, DoriImage, DoriBadge              │
├─────────────────────────────────────────────────────────────┤
│                         TOKENS                              │
│   Valores fundamentais (não são widgets)                    │
│   Ex: DoriColors, DoriTypography, DoriSpacing               │
└─────────────────────────────────────────────────────────────┘
```

### Quando usar cada camada?

| Precisa de... | Use |
|---------------|-----|
| Uma cor, espaçamento ou valor de tipografia | **Tokens** |
| Exibir texto, ícone ou imagem | **Atoms** |
| Um campo de busca, toggle de tema | **Molecules** |
| Um card de produto completo, uma AppBar | **Organisms** |

---

## 🎨 Tokens

> 📖 **Especificação completa:** [`documents/tokens-spec.md`](../../documents/tokens-spec.md)

### Acesso via Context

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
      ],
    ),
  );
}
```

### Cores

```dart
// Brand (Identidade visual)
tokens.colors.brand.pure    // Cor pura da marca
tokens.colors.brand.one     // Variação primária
tokens.colors.brand.two     // Variação secundária

// Surface (Fundos)
tokens.colors.surface.pure  // Máximo contraste (white/black)
tokens.colors.surface.one   // Fundo de cards
tokens.colors.surface.two   // Fundo secundário

// Content (Textos)
tokens.colors.content.pure  // Texto máximo contraste
tokens.colors.content.one   // Texto primário (default)
tokens.colors.content.two   // Texto secundário

// Feedback
tokens.colors.feedback.success
tokens.colors.feedback.error
tokens.colors.feedback.info
```

### Espaçamentos

```dart
// Horizontal (entre elementos lado a lado)
SizedBox(width: tokens.spacing.inline.xxs);

// Vertical (entre elementos empilhados)
SizedBox(height: tokens.spacing.stack.xs);

// Padding interno
EdgeInsets.all(tokens.spacing.inset.sm);

// Escala completa:
// xxxs (4dp) | xxs (8dp) | xs (16dp) | sm (24dp) | md (32dp) | lg (48dp) | xl (64dp)
```

### Bordas

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: tokens.radius.sm,   // 8dp
    borderRadius: tokens.radius.md,   // 12dp
    borderRadius: tokens.radius.lg,   // 16dp
  ),
);
```

---

## ⚛️ Atoms

### DoriText

```dart
// Uso básico (defaults: type=description, color=content.one)
DoriText(label: 'Hello, World!');

// Com customização
DoriText(
  label: 'Produtos',                        // required
  type: DoriTypography.title5,              // default: description
  color: tokens.colors.content.one,         // default: content.one
  maxLines: 2,                              // opcional
  overflow: TextOverflow.ellipsis,          // opcional
);

// Variantes de tipografia
DoriText(label: 'Título', type: DoriTypography.title5);
DoriText(label: 'Texto normal', type: DoriTypography.description);
DoriText(label: 'Texto destaque', type: DoriTypography.descriptionBold);
DoriText(label: 'Legenda', type: DoriTypography.caption);
DoriText(label: 'Legenda destaque', type: DoriTypography.captionBold);
```

### DoriIcon

```dart
DoriIcon(
  icon: Icons.search,
  size: DoriIconSize.md,
  color: tokens.colors.content.two,
);
```

### DoriImage

```dart
DoriImage(
  url: 'https://example.com/product.jpg',
  width: 200,
  height: 300,
  fit: BoxFit.cover,
  borderRadius: DoriRadius.md,
);
```

### DoriBadge

```dart
DoriBadge(
  text: 'NOVO',
  variant: DoriBadgeVariant.primary,
);
```

---

## 🧬 Molecules

### DoriSearchBar

```dart
DoriSearchBar(
  onChanged: (query) => print('Buscando: $query'),
  onClear: () => print('Busca limpa'),
  placeholder: 'Buscar produtos...',
);
```

### DoriThemeToggle

```dart
DoriThemeToggle(
  isDarkMode: false,
  onToggle: (isDark) => print('Dark mode: $isDark'),
);
```

### DoriLoadingIndicator

```dart
DoriLoadingIndicator(
  size: DoriLoadingSize.md,
  color: DoriColors.accent,
);
```

### DoriCategoryLabel

```dart
DoriCategoryLabel(
  text: 'Electronics',
  color: DoriColors.accent,
);
```

---

## 🦠 Organisms

### DoriProductCard

```dart
DoriProductCard(
  imageUrl: 'https://example.com/product.jpg',
  title: 'Wireless Headphones',
  price: 299.90,
  category: 'Electronics',
  badge: 'NOVO',
  size: DoriCardSize.large,  // ou .small
  onTap: () => print('Card clicado!'),
);
```

### DoriAppBar

```dart
DoriAppBar(
  title: 'Produtos',
  onSearch: (query) => print('Buscando: $query'),
  onThemeToggle: (isDark) => print('Tema: $isDark'),
  isDarkMode: false,
);
```

---

## 🎭 Temas

O Dori suporta **Light Mode** e **Dark Mode**. Configure no `MaterialApp`:

```dart
MaterialApp(
  theme: DoriTheme.light,
  darkTheme: DoriTheme.dark,
  themeMode: ThemeMode.system,  // ou .light / .dark
);
```

Acesse tokens do tema atual via `extension`:

```dart
final colors = Theme.of(context).extension<DoriThemeExtension>()!;

Container(
  color: colors.background,
  child: Text(
    'Hello',
    style: TextStyle(color: colors.textPrimary),
  ),
);
```

---

## 🎬 Animações

### DoriFadeAnimation

```dart
DoriFadeAnimation(
  duration: Duration(milliseconds: 300),
  child: DoriProductCard(...),
);
```

### DoriScaleAnimation

```dart
DoriScaleAnimation(
  duration: Duration(milliseconds: 200),
  curve: Curves.easeOutBack,
  child: DoriBadge(...),
);
```

---

## 📁 Estrutura de Arquivos

```
lib/
├── src/
│   ├── tokens/
│   │   ├── dori_colors.dart
│   │   ├── dori_typography.dart
│   │   ├── dori_spacing.dart
│   │   ├── dori_radius.dart
│   │   ├── dori_shadows.dart
│   │   └── dori_tokens.barrel.dart
│   │
│   ├── atoms/
│   │   ├── dori_text.dart
│   │   ├── dori_icon.dart
│   │   ├── dori_image.dart
│   │   ├── dori_badge.dart
│   │   └── dori_atoms.barrel.dart
│   │
│   ├── molecules/
│   │   ├── dori_search_bar.dart
│   │   ├── dori_theme_toggle.dart
│   │   ├── dori_category_label.dart
│   │   ├── dori_loading_indicator.dart
│   │   └── dori_molecules.barrel.dart
│   │
│   ├── organisms/
│   │   ├── dori_product_card.dart
│   │   ├── dori_app_bar.dart
│   │   └── dori_organisms.barrel.dart
│   │
│   ├── animations/
│   │   ├── dori_fade_animation.dart
│   │   ├── dori_scale_animation.dart
│   │   └── dori_animations.barrel.dart
│   │
│   └── theme/
│       ├── dori_theme.dart
│       ├── dori_theme_extension.dart
│       └── dori_theme.barrel.dart
│
└── dori.dart  ← Barrel principal (importe este!)
```

---

## 🚫 O que NÃO pertence ao Dori

- **Layouts de página** (ex: Masonry Grid da listagem)
- **Lógica de negócio** (ex: filtragem de produtos)
- **Navegação** (ex: rotas, transições entre telas)
- **State Management** (ex: Providers, ViewModels)

Esses elementos pertencem à camada de **Features** (`app/lib/features/`).

---

## ♿ Acessibilidade (A11y) — PRINCÍPIO FUNDAMENTAL

A acessibilidade é um **pilar central** do Dori, não um "nice-to-have". Todos os componentes são **acessíveis por padrão**.

### Por que Acessibilidade?

> **"Acessibilidade não é caridade, é competência."**

Um Design System sênior demonstra maturidade técnica quando:
- Elimina a necessidade do desenvolvedor "lembrar" de acessibilidade
- Garante conformidade com WCAG 2.1 AA automaticamente
- Funciona com TalkBack (Android) e VoiceOver (iOS) out-of-the-box

### Garantias do Dori

| Garantia | Descrição |
|----------|-----------|
| **Semantic Labels** | Todo componente interativo possui `semanticLabel` descritivo |
| **Contraste Mínimo** | Cores passam no teste WCAG 2.1 AA (4.5:1 texto, 3:1 grande) |
| **Touch Targets** | Áreas de toque ≥ 48x48 dp |
| **Screen Readers** | Testado com TalkBack e VoiceOver |
| **Focus Order** | Navegação por teclado/switch segue ordem lógica |
| **Reduced Motion** | Animações respeitam `MediaQuery.disableAnimations` |

### Exemplo de Uso

```dart
// O DoriProductCard já vem acessível por padrão!
DoriProductCard(
  imageUrl: 'https://example.com/product.jpg',
  title: 'Wireless Headphones',
  price: 299.90,
  category: 'Electronics',
  onTap: () => navigateToDetails(),
  // Não precisa configurar semanticLabel — já está embutido!
);

// Por baixo dos panos, o componente gera:
// Semantics(
//   label: 'Wireless Headphones, preço R$ 299,90, categoria Electronics',
//   button: true,
//   ...
// )
```

### Checklist de Acessibilidade (Interno)

Antes de marcar um componente como "pronto", ele deve passar:

```
✓ Possui semanticLabel descritivo
✓ Cores passam no teste de contraste
✓ Área de toque ≥ 48x48 dp
✓ Funciona com TalkBack/VoiceOver
✓ Ordem de foco faz sentido
✓ Animações respeitam reduced motion
✓ Testes de acessibilidade incluídos
```

---

## 📖 Documentação Completa

Para ver todos os componentes em ação, execute o **Widgetbook**:

```bash
cd packages/dori/example
flutter run
```

---

## 🤝 Contribuindo

1. Antes de criar um novo componente, verifique se já existe algo similar
2. Siga as convenções de nomenclatura (`Dori` prefix)
3. **Garanta que o componente seja acessível** (veja checklist acima)
4. Adicione o componente ao barrel file correspondente
5. Escreva testes unitários (incluindo testes de semântica)
6. Documente no Widgetbook

---

*"Just keep swimming, just keep swimming..."* 🐠

