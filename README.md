# Caveo Flutter Challenge

![Build Status](https://github.com/Matheysmota/caveo-challenge/actions/workflows/ci.yml/badge.svg)
![Coverage](https://img.shields.io/badge/coverage-80%25-brightgreen)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)

Bem-vindo ao repositório do **Caveo Flutter Challenge**. Este projeto é uma aplicação mobile desenvolvida com foco em **Clean Architecture**, **Governança de Código** e **Escalabilidade**, seguindo rigorosamente princípios de engenharia de software documentados. O nome fictício escolhido para o aplicativo é Fish.

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
- **Package by Feature interno:** Cada feature (`splash`, `products`) encapsula suas próprias camadas.
- **Packages reutilizáveis:** `shared` e `dori` (Design System) são módulos independentes.

```
/ (root)
├── app/                      # App Shell (Projeto Flutter)
│   └── lib/
│       ├── main.dart         # Bootstrap + DI Setup
│       ├── app/              # Configuração (Router, Theme, DI)
│       └── features/         # Features isoladas
│           ├── splash/
│           │   └── presentation/
│           └── products/
│               ├── domain/         # Entities, Repository Interfaces
│               ├── infrastructure/ # Repository Impl, Data Sources
│               └── presentation/   # Pages, Widgets, ViewModels
│
├── packages/                 # Módulos reutilizáveis
│   ├── shared/               # Drivers, Utils, Library Exports
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

### Padrões Arquiteturais

| Padrão | Descrição | ADR |
|--------|-----------|-----|
| **Result Pattern** | Métodos retornam `Result<S, F>`, sem exceções | [ADR 006](documents/adrs/006-command-pattern-e-tratamento-erros.md) |
| **Repository Pattern** | Interface + Impl com fallback API → Cache | [ADR 004](documents/adrs/004-camada-de-abstracao-rede.md) |
| **SyncStore** | Sincronização inicial desacoplada de features | [ADR 013](documents/adrs/013-sync-store.md) |
| **Atomic Design** | Componentes UI organizados em Atoms/Molecules/Organisms | [ADR 009](documents/adrs/009-design-system-dori.md) |

### SyncStore — Sincronização Inicial

O projeto utiliza o **SyncStore** para sincronização de dados iniciais (splash screen). Isso permite que features como Splash não conheçam detalhes de outras features como Products:

```dart
// Products module registra seu syncer
syncStore.registerSyncer<List<Product>>(
  SyncStoreKey.products,
  fetcher: () => repository.getProducts(),
);

// Splash observa o estado sem conhecer Products
syncStore.watch<List<Product>>(SyncStoreKey.products).listen((state) {
  if (state.isSuccess) navigateToHome();
  if (state.isError) showRetry();
});
```

📖 **Documentação completa:** [ADR 013 — SyncStore](documents/adrs/013-sync-store.md)

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos

| Ferramenta | Versão Mínima | Verificar |
|------------|---------------|-----------|
| Flutter SDK | 3.24.0+ | `flutter --version` |
| Dart SDK | 3.5.0+ | `dart --version` |
| Git | 2.x | `git --version` |
| Android Studio / Xcode | Latest | Para emuladores |

### Quick Start

```bash
# 1. Clone o repositório
git clone https://github.com/Matheysmota/caveo-challenge.git
cd caveo-challenge

# 2. Instale as dependências de todos os packages
cd app && flutter pub get && cd ..
cd packages/shared && flutter pub get && cd ../..
cd packages/dori && flutter pub get && cd ../..

# 3. Execute o projeto
cd app && flutter run
```

### Execução Detalhada

#### Opção 1: Via Script (Recomendado para desenvolvimento)

```bash
# Da raiz do projeto
./scripts/run_dev.sh
```

O script `run_dev.sh`:
- Carrega variáveis do `.devEnv`
- Injeta configurações via `--dart-define`
- Executa `flutter run` no diretório `app/`

#### Opção 2: Via Flutter Run (Quick run)

```bash
cd app && flutter run
```

O app usa fallback automático em modo debug:
- `BASE_URL`: `https://fakestoreapi.com`
- `CONNECT_TIMEOUT`: `30000ms`

#### Opção 3: Via VS Code

1. Abra o workspace na raiz do projeto
2. Selecione um dispositivo no canto inferior direito
3. Pressione `F5` ou use "Run > Start Debugging"

#### Opção 4: Via Android Studio / IntelliJ

1. Abra o diretório `app/` como projeto Flutter
2. Configure um emulador ou conecte um dispositivo
3. Clique em "Run" (▶️)

### Dispositivos Disponíveis

```bash
# Listar dispositivos conectados
flutter devices

# Rodar em dispositivo específico
flutter run -d <device_id>
```

| Plataforma | Device ID Exemplo |
|------------|-------------------|
| Android Emulator | `emulator-5554` |
| iOS Simulator | `iPhone 15 Pro` |
| Chrome (Web) | `chrome` |
| macOS (Desktop) | `macos` |

### Testes

```bash
# Rodar testes unitários (do diretório app/)
cd app && flutter test

# Rodar com coverage
cd app && flutter test --coverage

# Visualizar relatório (macOS/Linux)
genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html
```

### Validação de Código (Lint + Governance)

Antes de fazer commit, execute:

```bash
# 1. Formatação
dart format .

# 2. Análise estática
cd app && flutter analyze && cd ..
cd packages/shared && flutter analyze && cd ../..
cd packages/dori && flutter analyze && cd ../..

# 3. Governança de imports
./scripts/check_imports.sh

# 4. Testes
cd app && flutter test
```

### Configuração de Ambiente

O projeto utiliza o arquivo `.devEnv` para configuração de variáveis de ambiente. Este arquivo é **versionado para conveniência de desenvolvimento**, mas em produção deve ser gerenciado via CI/CD secrets.

```bash
# .devEnv (já incluído no repositório)
BASE_URL=https://fakestoreapi.com
CONNECT_TIMEOUT=30000
RECEIVE_TIMEOUT=30000
SEND_TIMEOUT=30000
```

| Variável | Descrição | Default |
|----------|-----------|---------|
| `BASE_URL` | URL base da API | `https://fakestoreapi.com` |
| `CONNECT_TIMEOUT` | Timeout de conexão (ms) | `30000` |
| `RECEIVE_TIMEOUT` | Timeout de resposta (ms) | `30000` |
| `SEND_TIMEOUT` | Timeout de envio (ms) | `30000` |

#### Formas de Executar

| Método | Comando | Quando Usar |
|--------|---------|-------------|
| **Script** | `./scripts/run_dev.sh` | Desenvolvimento local |
| **VS Code** | `F5` | Debugging com breakpoints |
| **Flutter direto** | `cd app && flutter run` | Quick run (usa fallback) |

#### CI/CD

Em pipelines de CI/CD, as variáveis são injetadas via `--dart-define`:

```bash
flutter build apk \
  --dart-define=BASE_URL=${{ secrets.API_URL }} \
  --dart-define=CONNECT_TIMEOUT=30000
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
