# Caveo Flutter Challenge

![Build Status](https://github.com/Matheysmota/caveo-challenge/actions/workflows/ci.yml/badge.svg)
![Coverage](https://img.shields.io/badge/coverage-80%25-brightgreen)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)

Bem-vindo ao repositório do **Caveo Flutter Challenge**. Este projeto é uma aplicação mobile desenvolvida com foco em **Clean Architecture**, **Governança de Código** e **Escalabilidade**, seguindo rigorosamente princípios de engenharia de software documentados.

## 📚 Documentação e Decisões

Toda a evolução técnica deste projeto é pautada em documentação e ADRs (Architecture Decision Records). Antes de codificar, leia:

- [**Especificações Funcionais**](documents/functional-specs.md): Detalhamento das features (Splash, Feed, Offline).
- [**ADR 002: Estrutura de Pastas**](documents/adrs/002-estrutura-de-pastas-padrao.md): Entenda o *Package by Layer*.
- [**ADR 003: Governança de Bibliotecas**](documents/adrs/003-abstracao-e-governanca-bibliotecas.md): Regras estritas de *imports*.
- [**ADR 005: CI/CD & Quality Gates**](documents/adrs/005-esteira-ci-cd.md): Como funciona nossa esteira de validação.

📁 **Veja todas as ADRs em:** [`documents/adrs/`](documents/adrs/)

---

## 🏗️ Arquitetura

O projeto utiliza **Clean Architecture** organizada por camadas funcionais (*Package by Layer*), garantindo desacoplamento e testabilidade.

```
lib/
├── application/     # UseCases, DTOs
├── domain/          # Entities, Repository Interfaces
├── infrastructure/  # Repository Impl, Data Sources, Drivers
├── presentation/    # Widgets, Pages, Controllers (Riverpod)
└── shared/          # Bibliotecas, Utils, Design System
```

### Stack Tecnológica
- **Linguagem:** Dart
- **Framework:** Flutter
- **Gerência de Estado:** Riverpod (Providers manuais, sem code-gen)
- **Padrões:** Repository Pattern, Command Pattern, Result Pattern.

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos
- Flutter SDK (Stable Channel)
- Git

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/Matheysmota/caveo-challenge.git
cd caveo-challenge
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o projeto:
```bash
flutter run
```

---

## ✅ Governança e Qualidade (Checklits)

Este projeto possui scripts de *Compliance* que rodam no CI. Para garantir que seu código passe:

1. **Imports:** Não importe pacotes externos diretamente na camada de domínio ou apresentação. Use os *exports* em `lib/shared/libraries/`.
   - Verificar localmente: `./scripts/check_imports.sh`
2. **Testes:** Todo código novo deve ter cobertura.
   - Rodar testes: `flutter test --coverage`
3. **Lint:** Zero warnings permitidos.
   - Verificar: `flutter analyze`

---

## 🤝 Contribuição

1. Siga o **GitFlow** (Features saem da `develop`).
2. Abra um Pull Request para `develop`.
3. Aguarde a aprovação do **CI/CD** (Lint, Tests, Architecture check).
4. O Merge só é permitido se todos os checks passarem.

---
*Developed by Matheus Mota as part of Caveo Tech Challenge.*
