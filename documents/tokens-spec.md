# 🎨 Dori Design Tokens Specification# 🎨 Dori Design Tokens Specification



> Especificação técnica completa dos tokens do Design System Dori.> Especificação técnica completa dos tokens do Design System Dori.



Este documento serve como **fonte da verdade** para implementação dos tokens. Para filosofia e arquitetura geral, consulte a [ADR 009](adrs/009-design-system-dori.md).Este documento serve como **fonte da verdade** para implementação dos tokens. Para filosofia e arquitetura geral, consulte a [ADR 009](adrs/009-design-system-dori.md).



------



## 📖 Sumário## 📖 Sumário



1. [Acesso via Código](#acesso-via-código)1. [Acesso via Código](#acesso-via-código)

2. [Typography](#typography)2. [Typography](#typography)

3. [Colors](#colors)3. [Colors](#colors)

4. [Spacing](#spacing)4. [Spacing](#spacing)

5. [Radius](#radius)5. [Radius](#radius)

6. [Theme Management](#theme-management)6. [Theme Management](#theme-management)



------



## Acesso via Código## Acesso via Código



### API Principal### API Principal



```dart```dart

// Syntax sugar (extension) - RECOMENDADO// Padrão Flutter

final dori = context.dori;final dori = Dori.of(context);



// Padrão Flutter// Syntax sugar (extension)

final dori = Dori.of(context);final dori = context.dori;



// Acessando tokens// Acessando tokens

final colors = dori.colors;      // reativo ao temafinal spacing = dori.tokens.spacing;

final spacing = dori.spacing;    // escala flatfinal colors = dori.tokens.colors;

final radius = dori.radius;      // border radiusfinal radius = dori.tokens.radius;

final typography = dori.typography;

```// Verificando tema atual

final isDark = dori.brightness == Brightness.dark;

### Exemplo Completo```



```dart### Exemplo Completo

Widget build(BuildContext context) {

  final dori = context.dori;```dart

  Widget build(BuildContext context) {

  return Container(  final tokens = context.dori.tokens;

    padding: EdgeInsets.all(dori.spacing.sm),  

    decoration: BoxDecoration(  return Container(

      color: dori.colors.surface.one,    padding: EdgeInsets.all(tokens.spacing.inset.sm),

      borderRadius: dori.radius.lg,    decoration: BoxDecoration(

    ),      color: tokens.colors.surface.one,

    child: Column(      borderRadius: tokens.radius.lg,

      children: [    ),

        SizedBox(height: dori.spacing.xxxs),    child: Column(

        Text(      children: [

          'Produtos',        SizedBox(height: tokens.spacing.stack.xxxs),

          style: dori.typography.title5.copyWith(        DoriText(

            color: dori.colors.content.one,          label: 'Produtos',

          ),          type: DoriTypography.title5,

        ),        ),

        SizedBox(height: dori.spacing.xxs),        SizedBox(height: tokens.spacing.stack.xxs),

        Text(        DoriText(

          'Confira nossa seleção',          label: 'Confira nossa seleção',

          style: dori.typography.description.copyWith(          type: DoriTypography.description,

            color: dori.colors.content.two,          color: tokens.colors.content.two,

          ),        ),

        ),      ],

      ],    ),

    ),  );

  );}

}```

```

---

---

## Typography

## Typography

### Variantes Disponíveis

### Variantes Disponíveis

| Token | Tamanho | Peso | Uso |

| Token | Tamanho | Peso | Uso ||-------|---------|------|-----|

|-------|---------|------|-----|| `title5` | 24px | ExtraBold (800) | Títulos principais |

| `title5` | 24px | ExtraBold (800) | Títulos principais || `description` | 14px | Medium (500) | Texto padrão **(default)** |

| `description` | 14px | Medium (500) | Texto padrão **(default)** || `descriptionBold` | 14px | Bold (700) | Texto padrão com destaque |

| `descriptionBold` | 14px | Bold (700) | Texto padrão com destaque || `caption` | 12px | Medium (500) | Texto pequeno, labels |

| `caption` | 12px | Medium (500) | Texto pequeno, labels || `captionBold` | 12px | Bold (700) | Texto pequeno com destaque |

| `captionBold` | 12px | Bold (700) | Texto pequeno com destaque |

### Font Family

### Font Family

**Plus Jakarta Sans** — Pesos: 500, 700, 800

**Plus Jakarta Sans** — Pesos: 500, 700, 800

### Componente DoriText

### Uso

```dart

```dartDoriText(

Text(  label: 'Texto obrigatório',           // required

  'Meu título',  type: DoriTypography.description,     // default: description

  style: context.dori.typography.title5.copyWith(  color: tokens.colors.content.one,     // default: content.one

    color: context.dori.colors.content.one,  maxLines: 2,                          // opcional

  ),  overflow: TextOverflow.ellipsis,      // opcional

););

``````



**Nota:** O componente `DoriText` (futuro) será **agnóstico a formatação de negócio**. Formatação de preços, datas, moedas, etc. é responsabilidade do domínio/feature, não do Design System.**Nota:** O componente é **agnóstico a formatação de negócio**. Formatação de preços, datas, moedas, etc. é responsabilidade do domínio/feature, não do Design System.



------



## Colors## Colors



### Estrutura### Estrutura



``````

colorscolors

├── brand      → Identidade visual da marca├── brand      → Identidade visual da marca

├── surface    → Fundos e superfícies├── surface    → Fundos e superfícies

├── content    → Textos e ícones├── content    → Textos e ícones

└── feedback   → Estados de feedback└── feedback   → Estados de feedback

``````



### Brand (Identidade Visual)### Brand (Identidade Visual)



| Token | Light Mode | Dark Mode | Uso || Token | Light Mode | Dark Mode | Uso |

|-------|------------|-----------|-----||-------|------------|-----------|-----|

| `brand.pure` | Indigo 600 `#4F46E5` | Indigo 400 `#818CF8` | Cor pura da marca || `brand.pure` | Indigo 600 `#4F46E5` | Indigo 400 `#818CF8` | Cor pura da marca |

| `brand.one` | Indigo 900 `#312E81` | Indigo 300 `#A5B4FC` | Variação primária || `brand.one` | Indigo 900 `#312E81` | Indigo 300 `#A5B4FC` | Variação primária |

| `brand.two` | Indigo 100 `#E0E7FF` | Indigo 900 `#312E81` | Variação secundária || `brand.two` | Indigo 100 `#E0E7FF` | Indigo 900 `#312E81` | Variação secundária |



### Surface (Superfícies)### Surface (Superfícies)



| Token | Light Mode | Dark Mode | Uso || Token | Light Mode | Dark Mode | Uso |

|-------|------------|-----------|-----||-------|------------|-----------|-----|

| `surface.pure` | White `#FFFFFF` | Slate 950 `#020617` | Superfície máximo contraste || `surface.pure` | White `#FFFFFF` | Slate 950 `#020617` | Superfície máximo contraste |

| `surface.one` | Slate 50 `#F8FAFC` | Slate 900 `#0F172A` | Fundo de cards (primário) || `surface.one` | Slate 50 `#F8FAFC` | Slate 900 `#0F172A` | Fundo de cards (primário) |

| `surface.two` | Slate 100 `#F1F5F9` | Slate 800 `#1E293B` | Fundo secundário || `surface.two` | Slate 100 `#F1F5F9` | Slate 800 `#1E293B` | Fundo secundário |



### Content (Textos e Ícones)### Content (Textos e Ícones)



| Token | Light Mode | Dark Mode | Uso || Token | Light Mode | Dark Mode | Uso |

|-------|------------|-----------|-----||-------|------------|-----------|-----|

| `content.pure` | Slate 950 `#020617` | White `#FFFFFF` | Texto máximo contraste || `content.pure` | Slate 950 `#020617` | White `#FFFFFF` | Texto máximo contraste |

| `content.one` | Slate 900 `#0F172A` | Slate 50 `#F8FAFC` | Texto primário **(default)** || `content.one` | Slate 900 `#0F172A` | Slate 50 `#F8FAFC` | Texto primário **(default)** |

| `content.two` | Slate 500 `#64748B` | Slate 400 `#94A3B8` | Texto secundário || `content.two` | Slate 500 `#64748B` | Slate 400 `#94A3B8` | Texto secundário |



### Feedback (Estados)### Feedback (Estados)



| Token | Cor | Uso || Token | Cor | Uso |

|-------|-----|-----||-------|-----|-----|

| `feedback.success` | Green 600 `#16A34A` | Sucesso, confirmação || `feedback.success` | Green 600 `#16A34A` | Sucesso, confirmação |

| `feedback.error` | Red 600 `#DC2626` | Erro, ação destrutiva || `feedback.error` | Red 600 `#DC2626` | Erro, ação destrutiva |

| `feedback.info` | Blue 600 `#2563EB` | Informação, destaque neutro || `feedback.info` | Blue 600 `#2563EB` | Informação, destaque neutro |



------



## Spacing## Spacing



### Escala Flat### Estrutura



> ⚠️ **Simplificado**: Removemos subgrupos (inline/stack/inset) em favor de uma escala flat única.```

spacing

| Token | Valor | Uso |├── inline    → Espaçamento horizontal (entre elementos lado a lado)

|-------|-------|-----|├── stack     → Espaçamento vertical (entre elementos empilhados)

| `xxxs` | 4dp | Micro espaço (entre ícone e texto) |└── inset     → Padding interno (todos os lados)

| `xxs` | 8dp | Entre itens muito próximos |```

| `xs` | 16dp | Entre itens de lista |

| `sm` | 24dp | Padding de cards |### Escala

| `md` | 32dp | Entre seções |

| `lg` | 48dp | Margens de página || Token | Valor | Exemplo de Uso |

| `xl` | 64dp | Espaços grandes, hero sections ||-------|-------|----------------|

| `xxxs` | 4dp | Micro espaço, entre ícone e texto |

### Uso| `xxs` | 8dp | Entre itens muito próximos |

| `xs` | 16dp | Entre itens de lista |

```dart| `sm` | 24dp | Padding de cards |

// Horizontal ou Vertical — mesmo token| `md` | 32dp | Entre seções |

Row(| `lg` | 48dp | Margens de página |

  children: [| `xl` | 64dp | Espaços grandes, hero sections |

    Button1(),

    SizedBox(width: context.dori.spacing.xxs),### Uso

    Button2(),

  ],```dart

);// Horizontal (entre botões lado a lado)

Row(

Column(  children: [

  children: [    Button1(),

    Title(),    SizedBox(width: tokens.spacing.inline.xxs),

    SizedBox(height: context.dori.spacing.xs),    Button2(),

    Content(),  ],

  ],);

);

// Vertical (entre título e conteúdo)

// Padding internoColumn(

Container(  children: [

  padding: EdgeInsets.all(context.dori.spacing.sm),    Title(),

  child: CardContent(),    SizedBox(height: tokens.spacing.stack.xs),

);    Content(),

```  ],

);

---

// Padding interno

## RadiusContainer(

  padding: EdgeInsets.all(tokens.spacing.inset.sm),

### Escala  child: CardContent(),

);

| Token | Valor | Uso |```

|-------|-------|-----|

| `sm` | 8dp | Botões, inputs, badges |---

| `md` | 12dp | Cards pequenos, chips |

| `lg` | 16dp | Cards principais, modais |## Radius



### Uso### Escala



```dart| Token | Valor | Uso |

Container(|-------|-------|-----|

  decoration: BoxDecoration(| `sm` | 8dp | Botões, inputs, badges |

    borderRadius: context.dori.radius.md,| `md` | 12dp | Cards pequenos, chips |

  ),| `lg` | 16dp | Cards principais, modais |

);

### Uso

// Ou via valor numérico

ClipRRect(```dart

  borderRadius: BorderRadius.circular(context.dori.radius.lgValue),Container(

  child: Image(...),  decoration: BoxDecoration(

);    borderRadius: tokens.radius.md,

```  ),

);

---

// Ou via helper

## Theme ManagementClipRRect(

  borderRadius: tokens.radius.lg,

### Configuração no MaterialApp  child: Image(...),

);

```dart```

MaterialApp(

  theme: DoriTheme.light,---

  darkTheme: DoriTheme.dark,

  themeMode: themeMode, // Controlado pelo App via Riverpod## Theme Management

);

```### Filosofia



### API de Controle de TemaO Dori **reage** ao tema, não o controla. O controle fica no App via state management (Riverpod).



```dart### Interface Fornecida pelo Dori

// Definir tema específico

context.dori.setTheme(DoriThemeMode.dark);```dart

context.dori.setTheme(DoriThemeMode.light);/// Contrato que o App deve implementar para controle de tema

context.dori.setTheme(DoriThemeMode.system);abstract class DoriThemeModeProvider {

  /// Tema atual

// Alternar para o inverso  ThemeMode get themeMode;

context.dori.setTheme(context.dori.themeMode.inverse);  

  /// Define um tema específico

// Verificações  void setThemeMode(ThemeMode mode);

context.dori.isDark    // bool  

context.dori.isLight   // bool  /// Alterna entre light e dark

context.dori.themeMode // DoriThemeMode enum  void toggleThemeMode();

```}

```

### Integração com Riverpod

### Implementação no App (Riverpod)

Para habilitar `setTheme`, configure o `Dori.of` com callbacks:

```dart

```dart// providers/theme_provider.dart

// providers/theme_provider.dartfinal themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final themeModeProvider = StateProvider<DoriThemeMode>((ref) => DoriThemeMode.system);

// Implementação do contrato Dori

// Uso no widgetclass AppThemeModeProvider implements DoriThemeModeProvider {

final dori = Dori.of(  final Ref _ref;

  context,  

  onThemeChanged: (mode) => ref.read(themeModeProvider.notifier).state = mode,  AppThemeModeProvider(this._ref);

  themeModeGetter: () => ref.read(themeModeProvider),  

);  @override

```  ThemeMode get themeMode => _ref.read(themeModeProvider);

  

---  @override

  void setThemeMode(ThemeMode mode) {

## Checklist de Implementação    _ref.read(themeModeProvider.notifier).state = mode;

  }

- [x] Criar `DoriColors` com light/dark schemes  

- [x] Criar `DoriSpacing` com escala flat  @override

- [x] Criar `DoriRadius` com sm/md/lg  void toggleThemeMode() {

- [x] Criar `DoriTypography` com 5 variantes    final current = themeMode;

- [x] Criar `DoriTheme.light` e `DoriTheme.dark`    setThemeMode(

- [x] Criar `DoriThemeExtension` para acesso via context      current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,

- [x] Criar extension `context.dori`    );

- [x] Criar `DoriThemeMode` enum com `inverse`  }

- [ ] Adicionar fonte Plus Jakarta Sans}

- [ ] Criar `DoriText` atom```

- [ ] Testes unitários para tokens

- [ ] Testes de acessibilidade (contraste)### Configuração no MaterialApp



---```dart

MaterialApp(

*Documento mantido pelo time de Design System. Última atualização: Janeiro/2025*  theme: DoriTheme.light,

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
