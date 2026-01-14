# Tarefa Front-end Caveo — Flutter

## Objetivo

Desenvolver um app Flutter com:

- **Splash Screen** que carrega o primeiro lote de produtos da [Fake Store API](https://fakestoreapi.com/docs)  
- **Tela de produtos** com lista paginada e carregamento infinito  
- Arquitetura seguindo **Command Pattern**  
- Gerenciamento de estado e injeção com **Riverpod**

---

## Estrutura esperada do projeto
<pre>
lib/
├── app/
│ └── app_widget.dart
├── application/
│ ├── use-cases/
│ ├── repositories/
│ └── dtos/
├── domain/
│ ├── use-cases/
│ └── entities/
├── infrastructure/
│ ├── api/
│ └── repositories/
├── presentation/
│ ├── pages/
│ └── widgets/
└── shared/
└── utils/
</pre>
---

## Requisitos

- **Splash Screen**
  - Exibe ao abrir o app.
  - Carrega o primeiro lote de produtos.
  - Navega automaticamente para a tela de produtos após o carregamento.

- **Tela de Produtos**
  - Lista produtos em um `ListView`.
  - Implementa paginação infinita (carrega mais produtos ao rolar para o fim).
  - Exibe indicador de carregamento enquanto busca novos itens.

- **Arquitetura**
  - Command Pattern para encapsular regras e interações.
  - Riverpod para containers e injeção.
  - Dio para requisições HTTP.

---

## Tecnologias

- **Flutter null-safety**
- **Riverpod** – Gerenciamento de estado / injeção
- **Dio** – Requisições HTTP
- **GoRouter** – Navegação
- **Command Pattern** – Organização da lógica

---

## Diferenciais (não obrigatório, mas valorizado)

- Testes unitários dos Commands
- Animações nos elementos interativos
- Cache simples do primeiro lote (SharedPreferences, Hive, etc)

---

## Referências

- [Fake Store API](https://fakestoreapi.com/docs)  
- [Riverpod]([https://riverpod.dev/docs](https://riverpod.dev/docs/introduction/getting_started))  
- [Command Pattern no Flutter](https://www.youtube.com/watch?v=uR9AgDzj1Ro)  
- [Dio](https://pub.dev/packages/dio)  
- [GoRouter](https://pub.dev/packages/go_router)

---

## O que esperamos na entrega

- Projeto com build funcional (pode ser testado via `flutter run`)
- Código modularizado, seguindo boas práticas
- README explicativo
- Link do repositório Git enviado
- Tratamento de erros