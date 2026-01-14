# Caveo Flutter Challenge

![Build Status](https://github.com/Matheysmota/caveo-challenge/actions/workflows/ci.yml/badge.svg)
![Coverage](https://img.shields.io/badge/coverage-80%25-brightgreen)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)

Bem-vindo ao repositório do **Caveo Flutter Challenge**. Este projeto é uma aplicação mobile desenvolvida com foco em **Clean Architecture**, **Governança de Código** e **Escalabilidade**, seguindo rigorosamente princípios de engenharia de software documentados.

## 📚 Documentação e Decisões

Toda a evolução técnica deste projeto é pautada em documentação e ADRs (Architecture Decision Records). Antes de codificar, leia:

- [**Especificações Funcionais**](documents/functional-specs.md): Detalhamento das features (Splash, Feed, Offline).
- [**ADR 002: Estrutura de Pastas**](documents/adrs/002-estrutura-de-pastas-padrao.md): Entenda a modularização híbrida.
- [**ADR 003: Governança de Bibliotecas**](documents/adrs/003-abstracao-e-governanca-bibliotecas.md): Regras estritas de *imports*.
- [**ADR 005: CI/CD & Quality Gates**](documents/adrs/005-esteira-ci-cd.md): Como funciona nossa esteira de validação.

📁 **Veja todas as ADRs em:** [`documents/adrs/`](documents/adrs/)

---

## 🏗️ Arquitetura

O projeto adota uma **estrutura híbrida** que combina:
- **Monorepo organizado:** Raiz limpa com `app/`, `packages/`, `documents/` e `scripts/`.
- **Package by Feature interno:** Cada feature (`splash`, `product`) encapsula suas próprias camadas.
- **Packages reutilizáveis:** `shared` e `dori` (Design System) são módulos independentes.

```
/ (root)
├── app/                      # App Shell (Projeto Flutter)
│   └── lib/
│       ├── main.dart         # Bootstrap
│       ├── app/              # Configuração (Routes, Theme, Providers)
│       └── features/         # Features isoladas
│           ├── splash/
│           └── product/
│               ├── application/
│               ├── domain/
│               ├── infrastructure/
│               └── presentation/
│
├── packages/                 # Módulos reutilizáveis
│   ├── shared/               # Core, Utils, Library Exports
│   └── dori/                 # 🐠 Design System Dori
│
├── documents/                # Documentação e ADRs
└── scripts/                  # Automação e CI
```

### 🐠 Design System Dori

O projeto utiliza o **Dori** (D.O.R.I. — Design Oriented Reusable Interface), um Design System baseado em Atomic Design com foco em:

- **Consistência Visual:** Tokens centralizados (cores, tipografia, espaçamentos)
- **Acessibilidade:** Todos os componentes são acessíveis por padrão (WCAG 2.1 AA)
- **Reutilização:** Componentes prontos para uso (Atoms, Molecules, Organisms)

> *"We forget, it remembers."* — O desenvolvedor não precisa decorar padrões visuais, o Dori lembra por ele.

📖 **Documentação completa:** [`packages/dori/README.md`](packages/dori/README.md)

### Stack Tecnológica
- **Linguagem:** Dart (SDK >=3.0.0)
- **Framework:** Flutter 3.x (Stable)
- **Gerência de Estado:** Riverpod (Providers manuais, sem code-gen)
- **HTTP Client:** Dio (via abstração em `shared`)
- **Navegação:** GoRouter

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos
- Flutter SDK 3.x (Stable)
- Git

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/Matheysmota/caveo-challenge.git
cd caveo-challenge
```

2. Instale as dependências:
```bash
cd app && flutter pub get
```

3. Execute o projeto:
```bash
flutter run
```

---

## ✅ Governança e Qualidade

Este projeto possui scripts de *Compliance* que rodam no CI. Para garantir que seu código passe:

1. **Imports:** Não importe pacotes externos diretamente. Use os *exports* em `packages/shared/lib/libraries/`.
   - Verificar localmente: `./scripts/check_imports.sh`
2. **Testes:** Todo código novo deve ter cobertura.
   - Rodar testes: `cd app && flutter test --coverage`
3. **Lint:** Zero warnings permitidos.
   - Verificar: `cd app && flutter analyze`

---

## 🤝 Contribuição

1. Siga o **GitFlow** (Features saem da `develop`).
2. Abra um Pull Request para `develop`.
3. Aguarde a aprovação do **CI/CD** (Lint, Tests, Architecture check).
4. O Merge só é permitido se todos os checks passarem.

---
*Developed by Matheus Mota as part of Caveo Tech Challenge.*
