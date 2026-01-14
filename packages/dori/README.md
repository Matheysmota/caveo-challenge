# 🐠 Dori Design System# 🐠 Dori Design System



> **D.O.R.I.** — Design Oriented Reusable Interface> **D.O.R.I.** — Design Oriented Reusable Interface



## Filosofia## Filosofia



> **"We forget, it remembers."**  > **"We forget, it remembers."**  

> (Nós esquecemos, ele lembra.)> (Nós esquecemos, ele lembra.)



Assim como a personagem Dory do filme "Procurando Nemo" tem perda de memória recente, desenvolvedores frequentemente esquecem hex codes, paddings corretos e regras de acessibilidade. O Design System Dori existe como **memória persistente** — você não precisa decorar nada, apenas consultar.Assim como a personagem Dory do filme "Procurando Nemo" tem perda de memória recente, desenvolvedores frequentemente esquecem hex codes, paddings corretos e regras de acessibilidade. O Design System Dori existe como **memória persistente** — você não precisa decorar nada, apenas consultar.



------



## 📦 Instalação## 📦 Instalação



No `pubspec.yaml` do seu projeto Flutter:No `pubspec.yaml` do seu projeto Flutter:



```yaml```yaml

dependencies:dependencies:

  dori:  dori:

    path: ../packages/dori    path: ../packages/dori

``````



Importe o barrel principal:Importe o barrel principal:



```dart```dart

import 'package:dori/dori.dart';import 'package:dori/dori.dart';

``````



------



## 🏗️ Arquitetura: Atomic Design## 🏗️ Arquitetura: Atomic Design



O Dori segue o padrão **Atomic Design** de Brad Frost, adaptado para Flutter:O Dori segue o padrão **Atomic Design** de Brad Frost, adaptado para Flutter:



``````

┌─────────────────────────────────────────────────────────────┐┌─────────────────────────────────────────────────────────────┐

│                        ORGANISMS                            ││                        ORGANISMS                            │

│   Componentes autônomos e complexos com estado próprio      ││   Componentes autônomos e complexos com estado próprio      │

│   Ex: DoriAppBar, DoriProductCard                           ││   Ex: DoriAppBar, DoriProductCard                           │

├─────────────────────────────────────────────────────────────┤├─────────────────────────────────────────────────────────────┤

│                        MOLECULES                            ││                        MOLECULES                            │

│   Combinações simples de atoms com uma função específica    ││   Combinações simples de atoms com uma função específica    │

│   Ex: DoriSearchBar, DoriThemeToggle, DoriLoadingIndicator  ││   Ex: DoriSearchBar, DoriThemeToggle, DoriLoadingIndicator  │

├─────────────────────────────────────────────────────────────┤├─────────────────────────────────────────────────────────────┤

│                          ATOMS                              ││                          ATOMS                              │

│   Elementos primitivos e indivisíveis                       ││   Elementos primitivos e indivisíveis                       │

│   Ex: DoriText, DoriIcon, DoriImage, DoriBadge              ││   Ex: DoriText, DoriIcon, DoriImage, DoriBadge              │

├─────────────────────────────────────────────────────────────┤├─────────────────────────────────────────────────────────────┤

│                         TOKENS                              ││                         TOKENS                              │

│   Valores fundamentais (não são widgets)                    ││   Valores fundamentais (não são widgets)                    │

│   Ex: DoriColors, DoriTypography, DoriSpacing               ││   Ex: DoriColors, DoriTypography, DoriSpacing               │

└─────────────────────────────────────────────────────────────┘└─────────────────────────────────────────────────────────────┘

``````



---### Quando usar cada camada?



## 🎨 Tokens| Precisa de... | Use |

|---------------|-----|

> 📖 **Especificação completa:** [`documents/tokens-spec.md`](../../documents/tokens-spec.md)| Uma cor, espaçamento ou valor de tipografia | **Tokens** |

| Exibir texto, ícone ou imagem | **Atoms** |

### Acesso via Context| Um campo de busca, toggle de tema | **Molecules** |

| Um card de produto completo, uma AppBar | **Organisms** |

```dart

Widget build(BuildContext context) {---

  final dori = context.dori;

  ## 🎨 Tokens

  return Container(

    padding: EdgeInsets.all(dori.spacing.sm),> 📖 **Especificação completa:** [`documents/tokens-spec.md`](../../documents/tokens-spec.md)

    decoration: BoxDecoration(

      color: dori.colors.surface.one,### Acesso via Context

      borderRadius: dori.radius.lg,

    ),```dart

    child: Column(Widget build(BuildContext context) {

      children: [  final tokens = context.dori.tokens;

        SizedBox(height: dori.spacing.xxxs),  

        Text(  return Container(

          'Produtos',    padding: EdgeInsets.all(tokens.spacing.inset.sm),

          style: dori.typography.title5.copyWith(    decoration: BoxDecoration(

            color: dori.colors.content.one,      color: tokens.colors.surface.one,

          ),      borderRadius: tokens.radius.lg,

        ),    ),

      ],    child: Column(

    ),      children: [

  );        SizedBox(height: tokens.spacing.stack.xxxs),

}        DoriText(

```          label: 'Produtos',

          type: DoriTypography.title5,

### Cores        ),

      ],

```dart    ),

// Brand (Identidade visual)  );

dori.colors.brand.pure    // Cor pura da marca}

dori.colors.brand.one     // Variação primária```

dori.colors.brand.two     // Variação secundária

### Cores

// Surface (Fundos)

dori.colors.surface.pure  // Máximo contraste (white/black)```dart

dori.colors.surface.one   // Fundo de cards// Brand (Identidade visual)

dori.colors.surface.two   // Fundo secundáriotokens.colors.brand.pure    // Cor pura da marca

tokens.colors.brand.one     // Variação primária

// Content (Textos)tokens.colors.brand.two     // Variação secundária

dori.colors.content.pure  // Texto máximo contraste

dori.colors.content.one   // Texto primário (default)// Surface (Fundos)

dori.colors.content.two   // Texto secundáriotokens.colors.surface.pure  // Máximo contraste (white/black)

tokens.colors.surface.one   // Fundo de cards

// Feedbacktokens.colors.surface.two   // Fundo secundário

dori.colors.feedback.success

dori.colors.feedback.error// Content (Textos)

dori.colors.feedback.infotokens.colors.content.pure  // Texto máximo contraste

```tokens.colors.content.one   // Texto primário (default)

tokens.colors.content.two   // Texto secundário

### Espaçamentos (Escala Flat)

// Feedback

```darttokens.colors.feedback.success

// Uso simples — mesmo token para qualquer direçãotokens.colors.feedback.error

SizedBox(width: dori.spacing.xxs);   // horizontaltokens.colors.feedback.info

SizedBox(height: dori.spacing.xs);   // vertical```

EdgeInsets.all(dori.spacing.sm);     // padding

### Espaçamentos

// Escala:

// xxxs (4dp) | xxs (8dp) | xs (16dp) | sm (24dp) | md (32dp) | lg (48dp) | xl (64dp)```dart

```// Horizontal (entre elementos lado a lado)

SizedBox(width: tokens.spacing.inline.xxs);

### Tipografia

// Vertical (entre elementos empilhados)

```dartSizedBox(height: tokens.spacing.stack.xs);

// 5 variantes disponíveis

dori.typography.title5          // 24px ExtraBold — Títulos// Padding interno

dori.typography.description     // 14px Medium — Texto padrãoEdgeInsets.all(tokens.spacing.inset.sm);

dori.typography.descriptionBold // 14px Bold — Texto com destaque

dori.typography.caption         // 12px Medium — Texto pequeno// Escala completa:

dori.typography.captionBold     // 12px Bold — Texto pequeno destaque// xxxs (4dp) | xxs (8dp) | xs (16dp) | sm (24dp) | md (32dp) | lg (48dp) | xl (64dp)

```

// Uso com cor

Text(### Bordas

  'Olá mundo',

  style: dori.typography.description.copyWith(```dart

    color: dori.colors.content.one,Container(

  ),  decoration: BoxDecoration(

);    borderRadius: tokens.radius.sm,   // 8dp

```    borderRadius: tokens.radius.md,   // 12dp

    borderRadius: tokens.radius.lg,   // 16dp

### Border Radius  ),

);

```dart```

Container(

  decoration: BoxDecoration(---

    borderRadius: dori.radius.sm,   // 8dp  — Botões, inputs

    borderRadius: dori.radius.md,   // 12dp — Cards pequenos## ⚛️ Atoms

    borderRadius: dori.radius.lg,   // 16dp — Cards principais

  ),### DoriText

);

```dart

// Valor numérico// Uso básico (defaults: type=description, color=content.one)

BorderRadius.circular(dori.radius.lgValue)DoriText(label: 'Hello, World!');

```

// Com customização

---DoriText(

  label: 'Produtos',                        // required

## 🎭 Temas  type: DoriTypography.title5,              // default: description

  color: tokens.colors.content.one,         // default: content.one

O Dori suporta **Light Mode** e **Dark Mode**. Configure no `MaterialApp`:  maxLines: 2,                              // opcional

  overflow: TextOverflow.ellipsis,          // opcional

```dart);

MaterialApp(

  theme: DoriTheme.light,// Variantes de tipografia

  darkTheme: DoriTheme.dark,DoriText(label: 'Título', type: DoriTypography.title5);

  themeMode: ThemeMode.system,DoriText(label: 'Texto normal', type: DoriTypography.description);

);DoriText(label: 'Texto destaque', type: DoriTypography.descriptionBold);

```DoriText(label: 'Legenda', type: DoriTypography.caption);

DoriText(label: 'Legenda destaque', type: DoriTypography.captionBold);

### Controle de Tema```



```dart### DoriIcon

// Definir tema específico

context.dori.setTheme(DoriThemeMode.dark);```dart

context.dori.setTheme(DoriThemeMode.light);DoriIcon(

  icon: Icons.search,

// Alternar para o inverso  size: DoriIconSize.md,

context.dori.setTheme(context.dori.themeMode.inverse);  color: tokens.colors.content.two,

);

// Verificações```

context.dori.isDark    // bool

context.dori.isLight   // bool### DoriImage

```

```dart

### Integração com RiverpodDoriImage(

  url: 'https://example.com/product.jpg',

Para habilitar `setTheme`, configure com callbacks:  width: 200,

  height: 300,

```dart  fit: BoxFit.cover,

// Crie um provider  borderRadius: DoriRadius.md,

final themeModeProvider = StateProvider<DoriThemeMode>((ref) => DoriThemeMode.system););

```

// Configure no widget

final dori = Dori.of(### DoriBadge

  context,

  onThemeChanged: (mode) => ref.read(themeModeProvider.notifier).state = mode,```dart

  themeModeGetter: () => ref.read(themeModeProvider),DoriBadge(

);  text: 'NOVO',

```  variant: DoriBadgeVariant.primary,

);

---```



## ♿ Acessibilidade---



O Dori foi projetado com acessibilidade em mente:## 🧬 Molecules



- **Contraste WCAG AA**: Todas as combinações de cores atendem o mínimo de 4.5:1### DoriSearchBar

- **Tipografia legível**: Tamanhos mínimos de 12px para garantir leitura

- **Espaçamentos consistentes**: Touch targets adequados para motor impairment```dart

DoriSearchBar(

---  onChanged: (query) => print('Buscando: $query'),

  onClear: () => print('Busca limpa'),

## 📁 Estrutura de Arquivos  placeholder: 'Buscar produtos...',

);

``````

packages/dori/

├── lib/### DoriThemeToggle

│   ├── dori.dart                          # Barrel principal

│   └── src/```dart

│       ├── tokens/DoriThemeToggle(

│       │   ├── dori_colors.dart           # Esquema de cores  isDarkMode: false,

│       │   ├── dori_spacing.dart          # Escala de espaçamento  onToggle: (isDark) => print('Dark mode: $isDark'),

│       │   ├── dori_radius.dart           # Border radius);

│       │   ├── dori_typography.dart       # Variantes tipográficas```

│       │   └── dori_tokens.barrel.dart    # Barrel de tokens

│       ├── theme/### DoriLoadingIndicator

│       │   ├── dori_theme.dart            # ThemeData light/dark

│       │   ├── dori_theme_mode.dart       # Enum de modos```dart

│       │   ├── dori_provider.dart         # Context extensionDoriLoadingIndicator(

│       │   └── dori_theme.barrel.dart     # Barrel de theme  size: DoriLoadingSize.md,

│       ├── atoms/                         # (futuro)  color: DoriColors.accent,

│       ├── molecules/                     # (futuro));

│       └── organisms/                     # (futuro)```

├── pubspec.yaml

├── CHANGELOG.md### DoriCategoryLabel

└── README.md

``````dart

DoriCategoryLabel(

---  text: 'Electronics',

  color: DoriColors.accent,

## 🚀 Widgetbook);

```

Visualize os componentes no catálogo interativo:

---

```bash

cd app/widgetbook## 🦠 Organisms

flutter pub get

dart run build_runner build --delete-conflicting-outputs### DoriProductCard

flutter run -d chrome

``````dart

DoriProductCard(

---  imageUrl: 'https://example.com/product.jpg',

  title: 'Wireless Headphones',

## 📚 Referências  price: 299.90,

  category: 'Electronics',

- [ADR 009 - Design System Dori](../../documents/adrs/009-design-system-dori.md)  badge: 'NOVO',

- [Tokens Specification](../../documents/tokens-spec.md)  size: DoriCardSize.large,  // ou .small

- [Atomic Design - Brad Frost](https://bradfrost.com/blog/post/atomic-web-design/)  onTap: () => print('Card clicado!'),

);

---```



*Mantido pelo time de Design System — Caveo Flutter Challenge*### DoriAppBar


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

