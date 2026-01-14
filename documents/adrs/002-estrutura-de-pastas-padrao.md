# ADR 002: Estrutura de Pastas Padrão do Projeto

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 13-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | arquitetura, estrutura, organização |

## Contexto e Problema
Precisamos definir a organização fundamental do código fonte do projeto Flutter. A estrutura de pastas dita como os módulos se comunicam e como a aplicação escala.

Como premissa inicial do projeto, foi solicitada uma árvore de diretórios baseada em camadas técnicas (`layer-based`), contendo estritamente: `application`, `domain`, `infrastructure`, `presentation`.

No entanto, em cenários de alta complexidade e escala (ex: Super Apps com contextos de Banking, Investimentos, Marketplace), arquiteturas baseadas puramente em camadas técnicas tendem a sofrer com baixa coesão de domínio. Em outras palavras, à medida que novos verticais de negócio são adicionados, a estrutura técnica se torna um "gaveteiro misturado": arquivos de funcionalidades distintas (ex: Pix e Crédito) residem lado a lado nas mesmas pastas. Isso obriga desenvolvedores a navegar por toda a árvore para alterar uma única feature, aumenta conflitos de merge entre times e eleva drasticamente a carga cognitiva para entender o impacto de uma mudança. 

## Alternativas Consideradas

### 1. Package by Feature (Modularização por Funcionalidade)
Organizar o código por contextos de negócio (ex: `features/products`, `features/cart`, `features/auth`), onde cada feature encapsula suas próprias camadas (Domain, Data, Presentation).
*   **Pros:** Alta coesão, baixo acoplamento entre features, facilita deleção de código antigo, escala horizontalmente com times.
*   **Cons:** Requer mais *boilerplate* inicial, desvia das premissas iniciais estipuladas para este projeto.

### 2. Package by Layer (Modularização por Camada Técnica) - **Opção Escolhida**
Organizar o código por responsabilidade técnica global (ex: `domain/entitites` contém entidades de *todos* os contextos).
*   **Pros:** Separação clara de responsabilidades técnicas, fácil para times pequenos entenderem onde colocar um arquivo específico, atende diretamente às restrições do projeto.
*   **Cons:** Em escala, mistura contextos de negócio (ex: Entidades de Produto misturadas com Entidades de Usuário), dificultando a modularização futura.

## Decisão
Decidimos **seguir a estrutura Package by Layer (Opção 2)**, em conformidade com as restrições arquiteturais definidas para o escopo deste projeto.

Embora reconheçamos que a abordagem *Package by Feature* seja superior para escalabilidade de longo prazo em grandes produtos, a adesão estrita ao design de arquitetura solicitado demonstra disciplina e capacidade de entrega dentro de conformidade técnica.

A estrutura final será:
```
/
├── documents/         # Documentação Arquitetural e de Processos (ADRs)
├── lib/
│   ├── app/
│   ├── application/       # Use-cases, DTOs
│   ├── domain/            # Entities, Interfaces de Repositories
│   ├── infrastructure/    # Implementações de Repositories, Data Sources
│   ├── presentation/      # Pages, Widgets, Providers (State Management)
│   └── shared/
```

## Consequências
*   **Positivo:** Total alinhamento com a expectativa dos avaliadores.
*   **Positivo:** Facilidade de navegação para quem conhece Clean Architecture padrão.
*   **Neutro:** Para o escopo limitado deste desafio (Fake Store), os problemas de escala da abordagem *Layer-based* não serão sentidos drasticamente.
*   **Mitigação:** Manteremos uma separação lógica rigorosa dentro das pastas (ex: prefixos ou subpastas de domínio dentro de `domain/usecases`) para minimizar a mistura de contextos.
