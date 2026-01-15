# Especificação Funcional e Regras de Negócio

Este documento detalha o comportamento esperado das funcionalidades do aplicativo, servindo como referência para desenvolvimento e QA.

---

## Escopo do Aplicativo

O aplicativo possui **3 telas principais**:

```
┌──────────────┐     ┌─────────────────┐     ┌──────────────────┐
│    Splash    │ ──► │  Product List   │ ──► │ Product Details  │
│   Screen     │     │  (Feed/Grid)    │     │    (Detalhes)    │
└──────────────┘     └─────────────────┘     └──────────────────┘
                            │
                            ▼
                     ┌─────────────────┐
                     │  Error Screen   │
                     │ (fallback only) │
                     └─────────────────┘
```

**Nota:** O aplicativo **NÃO possui** Bottom Navigation Bar. A navegação é linear (Splash → Lista → Detalhes) com possibilidade de retorno.

---

## 1. Splash Screen e Inicialização

### User Story
> **Como** usuário, ao abrir o aplicativo,  
> **Quero** ver uma introdução visual enquanto os dados são preparados,  
> **Para** que eu tenha acesso imediato ao conteúdo assim que a interface principal for carregada.

### Fluxo de Inicialização (Regras de Negócio)
1.  **Conectado:** Tenta buscar o *lote 1* de produtos na API.
    *   **Sucesso:** Salva no cache, navega para `ProductList`.
    *   **Falha na API:** Tenta buscar do cache local.
        *   *Cache existe:* Navega para `ProductList`.
        *   *Cache vazio:* Navega para `ErrorScreen`.
2.  **Desconectado (Offline):** Tenta buscar do cache local.
    *   **Sucesso:** Navega para `ProductList`.
    *   **Falha:** Navega para `ErrorScreen`.

### Requisitos Não-Funcionais
*   A animação da Splash deve rodar a **60fps** sem "janks" (travamentos), independente do processamento em background (Isolate ou Async concurrency).
*   A transição para a próxima tela deve ser suave (Fade ou Slide).

---

## 2. Tela de Listagem de Produtos (Feed)

### User Story
> **Como** usuário, na listagem de produtos,  
> **Quero** navegar por uma lista infinita de itens e ser notificado de atualizações de forma não intrusiva,  
> **Para** ter uma experiência fluida de consumo de conteúdo.

### Layout: Masonry Grid

A listagem utiliza um layout **Masonry (Pinterest-like)** com 2 colunas:

```
┌─────────────────────────────────────────┐
│           [  DoriAppBar  ]              │
│  "Produtos"    🔍 Search    🌙 Toggle   │
├──────────────────┬──────────────────────┤
│  ┌────────────┐  │  ┌────────────────┐  │
│  │   Card     │  │  │     Card       │  │
│  │   Small    │  │  │     Large      │  │
│  │            │  │  │                │  │
│  └────────────┘  │  │                │  │
│  ┌────────────┐  │  └────────────────┘  │
│  │   Card     │  │  ┌────────────────┐  │
│  │   Large    │  │  │     Card       │  │
│  │            │  │  │     Small      │  │
│  │            │  │  └────────────────┘  │
│  └────────────┘  │                      │
└──────────────────┴──────────────────────┘
```

**Regras do Layout:**
- **Colunas:** 2 (fixo)
- **Espaçamento:** Definido por `DoriSpacing.md` (16dp)
- **Cards:** Alternam entre tamanhos `large` e `small` para criar efeito visual dinâmico
- **Implementação:** Utilizar `flutter_staggered_grid_view` ou equivalente

### Componentes da AppBar (`DoriAppBar`)

A AppBar contém 3 elementos principais:

#### 2.1. Título "Produtos"
- Exibido no estado padrão (quando busca não está expandida)
- Tipografia: `DoriTypography.display`
- Alinhamento: Leading (esquerda)

#### 2.2. Busca Expandível (`DoriSearchBar`)

**Estado Inicial (Colapsado):**
- Apenas ícone de lupa visível na AppBar
- Toque no ícone expande o campo de busca

**Estado Expandido:**
- O campo de busca **substitui completamente** o título "Produtos"
- Animação suave de expansão (300ms, EaseInOut)
- TextField com autofocus ativado
- Placeholder: "Buscar produtos..."
- Ícone de "X" para limpar/fechar a busca

**Comportamento de Filtragem:**
- Filtragem **client-side** (dados já carregados em memória)
- Busca por: título do produto, descrição, categoria
- Debounce de 300ms antes de aplicar filtro
- Lista atualiza em tempo real conforme digitação

**Regras:**
- Se a busca estiver vazia e o usuário clicar no "X", o campo colapsa e o título "Produtos" reaparece
- Se houver texto e o usuário clicar no "X", apenas o texto é limpo (campo permanece expandido)
- Segundo clique no "X" (campo vazio) colapsa a busca

#### 2.3. Toggle de Tema (`DoriThemeToggle`)

**Posição:** Trailing (direita) da AppBar, sempre visível

**Comportamento:**
- Ícone de lua (🌙) no Light Mode
- Ícone de sol (☀️) no Dark Mode
- Toque alterna entre temas instantaneamente
- Animação de rotação/transição no ícone (300ms)

**Persistência:**
- A preferência de tema é salva em cache local (`LocalCacheSource`)
- Ao reabrir o app, o tema selecionado é restaurado

### Features e Comportamentos

#### A. Pull to Refresh (Twitter-like UX)
*   **Ação:** Usuário arrasta o topo da lista para baixo.
*   **Comportamento:**
    1.  O componente de refresh aparece.
    2.  O app busca novas informações na API em background.
    3.  A lista **NÃO** é atualizada imediatamente (para não perder a posição de scroll ou "pular" conteúdo).
*   **Feedback:**
    *   **Sucesso:** Um botão flutuante **"Ver novos produtos"** aparece no topo da lista (apenas se o usuário estiver no topo).
    *   **Interação:** Ao clicar no botão, a lista é atualizada e o scroll volta ao topo.
    *   **Conflito:** Se o usuário ignorar o botão e rolar para baixo (acionando paginação), o botão desaparece e os dados do "Pull to Refresh" são descartados em favor da consistência da paginação atual.

#### B. Infinite Scroll (Paginação)
*   **Ação:** Usuário rola próximo ao final da lista (Threshold pré-definido).
*   **Comportamento:**
    *   App busca a próxima página em background.
    *   **UI:** Mostra loading spinner discreto no rodapé *apenas* se o usuário atingir o fim da lista antes do carregamento terminar.
    *   A UI não deve travar durante o parse do JSON (utilizar `compute` se necessário).
*   **Tratamento de Erro:**
    *   Se a paginação falhar, o spinner no rodapé muda para um botão "Tentar novamente".

#### C. Modo Offline e Resiliência
*   **Detecção:** Se a conexão cair durante o uso.
*   **Feedback:** Ver seção [Feedback Visual: Banners de Status](#feedback-visual-banners-de-status).
*   **Comportamento da Lista:**
    *   Itens já carregados permanecem visíveis.
    *   Imagens em cache permanecem visíveis.
*   **Tentativa de Ação Offline:**
    *   *Pull to refresh:* Falha graciosamente (mantém lista atual e avisa erro via Toast/Banner).
    *   *Paginação:* Falha com opção de retry no rodapé.

---

### Feedback Visual: Banners de Status

O aplicativo possui **dois tipos distintos de banners** para comunicar estados ao usuário. É importante diferenciar suas responsabilidades:

#### Banner 1: "Você está offline" (Conectividade)

| Propriedade | Valor |
|-------------|-------|
| **Trigger** | `ConnectivityObserver` detecta perda de conexão de rede |
| **Mensagem** | "Você está offline" |
| **Estilo** | `DoriBanner` com cor `feedback.info` |
| **Posição** | Abaixo da AppBar, acima do conteúdo |
| **Comportamento** | Aparece automaticamente quando offline, desaparece quando reconecta |
| **Dismissível** | ❌ Não (controlado pelo sistema) |
| **Responsável** | UI observa `ConnectivityObserver.observe()` (Stream) |

**Cenários:**
- Usuário desliga Wi-Fi → Banner aparece
- Usuário religa Wi-Fi → Banner desaparece automaticamente
- App inicia offline → Banner já aparece desde o início

#### Banner 2: "Seus dados podem estar desatualizados" (Dados Stale)

| Propriedade | Valor |
|-------------|-------|
| **Trigger** | Repository retornou dados do cache porque a API falhou (401, 500, timeout, etc.) |
| **Mensagem** | "Seus dados podem estar desatualizados" |
| **Estilo** | `DoriBanner` com cor `feedback.infoSoft` + ícone de warning |
| **Posição** | Abaixo da AppBar (e abaixo do banner de offline, se ambos ativos) |
| **Comportamento** | Aparece quando `isDataStale == true` no ViewModel |
| **Dismissível** | ✅ Sim (usuário pode fechar) |
| **Ação opcional** | Botão "Tentar novamente" para refazer fetch |
| **Responsável** | ViewModel expõe `isDataStale: bool` baseado no retorno do Repository |

**Cenários:**
- Usuário abre app, API retorna 500, cache existe → Banner aparece
- Usuário faz pull-to-refresh com sucesso → Banner desaparece
- Usuário dismiss manualmente → Banner desaparece (mas dados continuam stale)

#### Diferença Fundamental

| Situação | Está Offline? | API Falhou? | Banner Exibido |
|----------|---------------|-------------|----------------|
| Sem internet, mostrando cache | ✅ | N/A | "Você está offline" |
| Com internet, API 401/500, mostrando cache | ❌ | ✅ | "Dados desatualizados" |
| Com internet, API OK | ❌ | ❌ | Nenhum |
| Sem internet E API falhou (ambos) | ✅ | ✅ | Ambos os banners |

#### Hierarquia Visual (quando ambos ativos)

```
┌─────────────────────────────────────────┐
│           [  DoriAppBar  ]              │
├─────────────────────────────────────────┤
│ ⚠️ Você está offline                    │  ← Banner 1 (não dismissível)
├─────────────────────────────────────────┤
│ 📋 Seus dados podem estar desatualiz... │  ← Banner 2 (dismissível)
├─────────────────────────────────────────┤
│                                         │
│         Lista de Produtos               │
│                                         │
└─────────────────────────────────────────┘
```

#### D. Performance de Imagens
*   Utilizar `cached_network_image` (ou abstração equivalente).
*   Implementar `memCacheHeight` / `memCacheWidth` para decodificar imagens no tamanho exato do render, economizando memória RAM.
*   Fade-in suave ao carregar.

---

## 3. Tela de Erro (Error Screen)

### Contexto
Exibida apenas quando é impossível iniciar o app (sem internet E sem cache).

### Elementos
*   Ilustração amigável.
*   Mensagem clara: "Não foi possível carregar as informações."
*   Botão **"Tentar Novamente"** (tenta reiniciar o fluxo de Splash).

---

## 4. Tela de Detalhes do Produto (Product Details)

### User Story
> **Como** usuário, ao me interessar por um item da lista,  
> **Quero** visualizar mais detalhes sobre ele com uma transição fluida,  
> **Para** decidir sobre a compra ou obter mais informações sem sentir que saí do contexto da lista.

### Comportamento e Navegação
*   **Trigger:** Toque em qualquer card da lista de produtos.
*   **Transição:** Animação estilo **Container Transform** (Hero Animation). O card da lista deve "expandir" e se transformar na tela de detalhes.
*   **Dados:**
    *   A tela deve abrir **instantaneamente**, reaproveitando os dados já carregados na memória (Imagem, Título, Preço).
    *   A única informação adicional exibida será a **Descrição Completa** (que já deve vir no payload da lista, evitando novo request de network, ou se necessário, ser carregada sob demanda).

### Elementos da Tela
1.  **Imagem de Destaque (Hero):** Ocupa a parte superior (Banner).
2.  **Título e Preço:** Logo abaixo da imagem.
3.  **Descrição:** Texto multilinhas com scroll (única diferença significativa de conteúdo em relação ao card).
4.  **Botão de Voltar:** No topo (AppBar transparente ou botão flutuante).
