# ADR 009: Design System Dori — Arquitetura e Convenções

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 14-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | design-system, ui, componentes, tokens, atomic-design, acessibilidade |

## Contexto e Problema

O projeto necessita de uma biblioteca de componentes visuais reutilizáveis que garanta:
1. **Consistência visual** em todas as telas do aplicativo
2. **Velocidade de desenvolvimento** — componentes prontos para uso
3. **Manutenibilidade** — mudanças visuais centralizadas em um único lugar
4. **Acessibilidade** — inclusão de todos os usuários, independente de suas capacidades
5. **Documentação viva** — catálogo de componentes navegável

Sem um Design System, desenvolvedores tendem a:
- Criar componentes duplicados com variações sutis
- Hardcodar valores de cores, espaçamentos e tipografia
- Ignorar requisitos de acessibilidade por desconhecimento
- Perder tempo em decisões triviais de UI

## Decisão

Implementaremos o **Design System Dori** (D.O.R.I. — Design Oriented Reusable Interface) como um package Flutter independente em `packages/dori/`.

### Filosofia

> **"We forget, it remembers."** (Nós esquecemos, ele lembra.)

Assim como a personagem Dory do filme "Procurando Nemo" tem perda de memória recente, desenvolvedores frequentemente esquecem hex codes, paddings corretos e regras de acessibilidade. O Design System Dori existe como **memória persistente** — o desenvolvedor não precisa decorar nada, apenas consultar.

### Arquitetura: Atomic Design

Adotamos o padrão **Atomic Design** de Brad Frost, adaptado para Flutter:

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

#### Definição das Camadas

| Camada | Definição | Critério | Exemplos |
|--------|-----------|----------|----------|
| **Tokens** | Valores primitivos que definem a identidade visual | Não são widgets, apenas `const` e classes de configuração | Cores, tipografia, espaçamentos, sombras |
| **Atoms** | Componentes com **uma única responsabilidade**, sem lógica de estado complexa | Não combinam outros componentes | `DoriText`, `DoriIcon`, `DoriImage` |
| **Molecules** | Combinação de **2+ atoms** para formar uma funcionalidade específica | Têm uma função clara e delimitada | `DoriSearchBar` (Icon + TextField) |
| **Organisms** | Componentes **autônomos** que combinam molecules/atoms e possuem **estado próprio** ou representam **entidades de negócio** | Funcionam independentemente, têm lógica interna | `DoriProductCard`, `DoriAppBar` |

#### Por que `DoriProductCard` é Organism e não Molecule?

O `DoriProductCard` é classificado como **Organism** porque:
1. **Combina múltiplos elementos**: `DoriImage` + `DoriText` (título) + `DoriText` (preço) + `DoriBadge` + `DoriCategoryLabel`
2. **Representa uma entidade de negócio**: Um produto completo, não apenas um agrupamento visual
3. **Possui variantes complexas**: Tamanhos diferentes (`large`, `small`) com layouts distintos
4. **É autocontido**: Pode ser usado em qualquer contexto sem dependências externas

#### Por que `DoriAppBar` é Organism?

O `DoriAppBar` é **Organism** porque:
1. **Combina múltiplas molecules**: `DoriSearchBar` + `DoriThemeToggle`
2. **Gerencia estado interno**: Modo normal vs modo busca expandida
3. **É autônomo**: Funciona sozinho com comportamento próprio

### Estrutura de Pastas

```
packages/dori/
├── lib/
│   ├── src/
│   │   ├── tokens/
│   │   │   ├── dori_colors.dart
│   │   │   ├── dori_typography.dart
│   │   │   ├── dori_spacing.dart
│   │   │   ├── dori_radius.dart
│   │   │   ├── dori_shadows.dart
│   │   │   └── dori_tokens.barrel.dart
│   │   │
│   │   ├── atoms/
│   │   │   ├── dori_text.dart
│   │   │   ├── dori_icon.dart
│   │   │   ├── dori_image.dart
│   │   │   ├── dori_badge.dart
│   │   │   └── dori_atoms.barrel.dart
│   │   │
│   │   ├── molecules/
│   │   │   ├── dori_search_bar.dart
│   │   │   ├── dori_theme_toggle.dart
│   │   │   ├── dori_category_label.dart
│   │   │   ├── dori_loading_indicator.dart
│   │   │   └── dori_molecules.barrel.dart
│   │   │
│   │   ├── organisms/
│   │   │   ├── dori_product_card.dart
│   │   │   ├── dori_app_bar.dart
│   │   │   └── dori_organisms.barrel.dart
│   │   │
│   │   ├── animations/
│   │   │   ├── dori_fade_animation.dart
│   │   │   ├── dori_scale_animation.dart
│   │   │   └── dori_animations.barrel.dart
│   │   │
│   │   └── theme/
│   │       ├── dori_theme.dart
│   │       ├── dori_theme_extension.dart
│   │       └── dori_theme.barrel.dart
│   │
│   └── dori.dart                    # Barrel principal
│
├── example/                         # Widgetbook (não exportado)
├── test/
├── pubspec.yaml
└── README.md
```

### Convenções de Nomenclatura

| Elemento | Padrão | Exemplo |
|----------|--------|---------|
| Arquivos | `dori_{nome}.dart` | `dori_text.dart` |
| Barrel files | `dori_{camada}.barrel.dart` | `dori_atoms.barrel.dart` |
| Classes | `Dori{Nome}` | `DoriText`, `DoriProductCard` |
| Enums | `Dori{Nome}` | `DoriTypography`, `DoriCardSize` |
| Tokens (const) | `Dori{Categoria}.{valor}` | `DoriColors.brand.one`, `DoriSpacing.inline.md` |

### Sistema de Tokens

Os tokens são baseados no **Material Design 3** com customizações do **GenZ Commerce Kit**.

> 📖 **Especificação completa:** [`documents/tokens-spec.md`](../tokens-spec.md)

#### Estrutura de Acesso

```dart
// Via context
final dori = Dori.of(context);  // ou context.dori

// Tokens disponíveis
dori.tokens.colors.brand.one      // Cores
dori.tokens.spacing.inline.md     // Espaçamentos
dori.tokens.radius.lg             // Bordas

// Tema atual
dori.brightness                   // Brightness.light ou Brightness.dark
```

#### Cores (Semantic Tokens)

```
colors
├── brand      → pure, one, two      (Identidade visual)
├── surface    → pure, one, two      (Fundos e superfícies)
├── content    → pure, one, two      (Textos e ícones)
└── feedback   → success, error, info (Estados)
```

#### Espaçamentos (Spacing)

```
spacing
├── inline    → xxxs, xxs, xs, sm, md, lg, xl   (Horizontal)
├── stack     → xxxs, xxs, xs, sm, md, lg, xl   (Vertical)
└── inset     → xxxs, xxs, xs, sm, md, lg, xl   (Padding)
```

| Token | Valor |
|-------|-------|
| `xxxs` | 4dp |
| `xxs` | 8dp |
| `xs` | 16dp |
| `sm` | 24dp |
| `md` | 32dp |
| `lg` | 48dp |
| `xl` | 64dp |

#### Tipografia
- **Font Family:** Plus Jakarta Sans
- **Weights:** Medium (500), Bold (700), ExtraBold (800)

```dart
enum DoriTypography {
  title5,          // 24px, ExtraBold 800 - Títulos principais
  description,     // 14px, Medium 500 - Texto padrão (default)
  descriptionBold, // 14px, Bold 700 - Texto com destaque
  caption,         // 12px, Medium 500 - Texto pequeno
  captionBold,     // 12px, Bold 700 - Texto pequeno com destaque
}
```

### Temas (Light/Dark)

O Design System suporta **Light Mode** e **Dark Mode** via `ThemeExtension`:

```dart
class DoriThemeExtension extends ThemeExtension<DoriThemeExtension> {
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  // ...
}
```

O toggle de tema é um componente (`DoriThemeToggle`) posicionado na `DoriAppBar`.

### Animações

Todas as animações são implementadas com **Flutter nativo** (sem Lottie/Rive):
- `AnimationController`
- `AnimatedBuilder`
- `Hero` transitions
- Curvas customizadas

Componentes de animação reutilizáveis ficam em `src/animations/`:
- `DoriFadeAnimation` — Fade in/out
- `DoriScaleAnimation` — Scale com bounce

### Documentação (Widgetbook)

O package inclui um app de exemplo em `/example` usando **Widgetbook** para documentação interativa dos componentes. Este diretório **não é exportado** no barrel principal.

### Acessibilidade (A11y) — PRINCÍPIO FUNDAMENTAL

A acessibilidade é um **pilar central** do Design System Dori, não um "nice-to-have". Todos os componentes **DEVEM** ser acessíveis por padrão.

#### Regras Obrigatórias

| Regra | Descrição | Implementação |
|-------|-----------|---------------|
| **Semantic Labels** | Todo componente interativo DEVE ter um `semanticLabel` | `Semantics(label: '...')` |
| **Contraste Mínimo** | Texto/fundo DEVE respeitar WCAG 2.1 AA (4.5:1 para texto normal, 3:1 para texto grande) | Validação nos tokens de cor |
| **Touch Targets** | Áreas de toque DEVEM ter no mínimo 48x48 dp | Padding mínimo garantido |
| **Screen Reader** | Componentes DEVEM funcionar com TalkBack (Android) e VoiceOver (iOS) | Testes obrigatórios |
| **Focus Order** | Navegação por teclado/switch DEVE seguir ordem lógica | `FocusTraversalGroup` |
| **Reduced Motion** | Animações DEVEM respeitar preferência do sistema | `MediaQuery.disableAnimations` |

#### Checklist por Componente

Todo componente Dori deve passar no seguinte checklist antes de ser considerado "pronto":

```
□ Possui semanticLabel descritivo
□ Cores passam no teste de contraste (usar Accessibility Scanner)
□ Área de toque ≥ 48x48 dp
□ Funciona com TalkBack/VoiceOver
□ Ordem de foco faz sentido
□ Animações respeitam MediaQuery.disableAnimations
□ Testes de acessibilidade incluídos
```

#### Implementação em Código

```dart
// ✅ CORRETO: Componente acessível
class DoriProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    
    return Semantics(
      label: '$title, preço $formattedPrice, categoria $category',
      button: true,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: reduceMotion ? Duration.zero : Duration(milliseconds: 300),
          // ...
        ),
      ),
    );
  }
}

// ❌ ERRADO: Sem suporte a acessibilidade
class BadProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(  // GestureDetector não é acessível por padrão
      onTap: onTap,
      child: Container(...),  // Sem Semantics
    );
  }
}
```

#### Validação Automatizada

A CI/CD inclui verificações de acessibilidade:
- **Lint rules:** `flutter analyze` com regras de acessibilidade habilitadas
- **Testes:** Testes de widget com `semanticsTester` para validar labels

## Consequências

### Positivas
- **Consistência garantida** — Todos os componentes seguem os mesmos tokens
- **Desenvolvimento acelerado** — Componentes prontos para composição
- **Manutenção centralizada** — Mudança de cor/tipografia em um único lugar
- **Acessibilidade embutida** — Desenvolvedores não precisam "lembrar" de acessibilidade, ela já vem pronta
- **Documentação viva** — Widgetbook como catálogo navegável
- **Independência** — Package pode ser reutilizado em outros projetos

### Trade-offs
- **Overhead inicial** — Configurar o Design System leva tempo antes de ver valor
- **Curva de aprendizado** — Time precisa conhecer os componentes disponíveis
- **Rigidez proposital** — Customizações fora do DS são desencorajadas

### Regras de Dependência
- **Dori NÃO depende** de nenhum outro package do projeto (exceto Flutter SDK)
- **App depende** de Dori para UI
- **Features NÃO devem** criar componentes visuais fora do Design System

## Referências

- [Atomic Design - Brad Frost](https://bradfrost.com/blog/post/atomic-web-design/)
- [Material Design 3](https://m3.material.io/)
- [GenZ Commerce Kit Tokens](internal)
