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
// Via extension (recomendado)
final dori = context.dori;

// Via método estático
final dori = Dori.of(context);

// Acessando tokens
final colors = dori.colors;
final spacing = dori.spacing;
final radius = dori.radius;
final typography = dori.typography;

// Verificando tema atual
final isDark = dori.isDark;
```

### Exemplo Completo

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
      'Produtos',
      style: dori.typography.title5.copyWith(
        color: dori.colors.content.one,
      ),
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

> **Nota:** A fonte deve ser configurada pelo app consumidor. Se não configurada, será usada a fonte padrão do sistema.

### Uso

```dart
Text(
  'Meu título',
  style: context.dori.typography.title5.copyWith(
    color: context.dori.colors.content.one,
  ),
);
```

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

### Escala

| Token | Valor | Uso |
|-------|-------|-----|
| `xxxs` | 4dp | Micro espaço, entre ícone e texto |
| `xxs` | 8dp | Entre itens muito próximos |
| `xs` | 16dp | Entre itens de lista |
| `sm` | 24dp | Padding de cards |
| `md` | 32dp | Entre seções |
| `lg` | 48dp | Margens de página |
| `xl` | 64dp | Espaços grandes, hero sections |

### Uso

```dart
// Espaçamento horizontal
Row(
  children: [
    Button1(),
    SizedBox(width: context.dori.spacing.xxs),
    Button2(),
  ],
);

// Espaçamento vertical
Column(
  children: [
    Title(),
    SizedBox(height: context.dori.spacing.xs),
    Content(),
  ],
);

// Padding interno
Container(
  padding: EdgeInsets.all(context.dori.spacing.sm),
  child: CardContent(),
);
```

---

## Radius

### Escala

| Token | Valor | Uso |
|-------|-------|-----|
| `sm` | 8dp | Elementos pequenos (inputs, botões pequenos) |
| `md` | 16dp | Elementos médios (badges, chips, botões) |
| `lg` | 24dp | Elementos grandes (cards, modais, containers) |

### Uso

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: context.dori.radius.md,
  ),
);

// Ou via valor numérico
ClipRRect(
  borderRadius: BorderRadius.circular(context.dori.radius.lgValue),
  child: Image(...),
);
```

---

## Theme Management

### Configuração no MaterialApp

```dart
MaterialApp(
  theme: DoriTheme.light,
  darkTheme: DoriTheme.dark,
  themeMode: ref.watch(themeModeProvider),
);
```

### Verificar Tema Atual

```dart
final isDark = context.dori.isDark;
final isLight = context.dori.isLight;
```

### Alterar Tema

Para habilitar `setTheme()`, configure com callbacks:

```dart
final dori = Dori.of(
  context,
  onThemeChanged: (mode) => ref.read(themeModeProvider.notifier).state = mode.toThemeMode(),
  themeModeGetter: () => DoriThemeMode.fromThemeMode(ref.read(themeModeProvider)),
);

// Definir tema específico
dori.setTheme(DoriThemeMode.dark);
dori.setTheme(DoriThemeMode.light);

// Alternar para o inverso
dori.setTheme(dori.themeMode.inverse);
```

---

## Checklist de Implementação

- [x] `DoriColors` com light/dark schemes
- [x] `DoriSpacing` com escala flat
- [x] `DoriRadius` com sm/md/lg
- [x] `DoriTypography` com 5 variantes
- [x] `DoriTheme.light` e `DoriTheme.dark`
- [x] `DoriThemeExtension` para acesso via context
- [x] Extension `context.dori`
- [x] `DoriThemeMode` enum com `inverse`
- [ ] Adicionar fonte Plus Jakarta Sans (responsabilidade do app)
- [ ] Testes unitários para tokens
- [ ] Testes de acessibilidade (contraste)

---

*Documento mantido pelo time de Design System. Última atualização: Janeiro/2026*
