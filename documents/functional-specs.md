# Especificação Funcional e Regras de Negócio

Este documento detalha o comportamento esperado das funcionalidades do aplicativo, servindo como referência para desenvolvimento e QA.

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
*   **Feedback:** Banner "Sem conexão com a internet" desce suavemente abaixo da AppBar (estilo SnackBar persistente ou componente customizado).
*   **Comportamento da Lista:**
    *   Itens já carregados permanecem visíveis.
    *   Imagens em cache permanecem visíveis.
*   **Tentativa de Ação Offline:**
    *   *Pull to refresh:* Falha graciosamente (mantém lista atual e avisa erro via Toast/Banner).
    *   *Paginação:* Falha com opção de retry no rodapé.

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
