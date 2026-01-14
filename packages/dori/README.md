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
│   │   ├── atoms/        # DoriText, DoriIcon, DoriBadge, DoriButton
│   │   ├── tokens/       # Colors, Spacing, Radius, Typography
│   │   └── theme/        # DoriTheme, DoriProvider
│   └── dori.dart         # Barrel principal
├── example/              # Widgetbook
└── test/
```

---

*Mantido pelo time de Design System • Janeiro/2026*
