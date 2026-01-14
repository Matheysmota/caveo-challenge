# 📚 Widgetbook Caveo

Catálogo visual de componentes do Design System Dori e features do Caveo Challenge.

## 🚀 Rodando

```bash
# Na pasta app/widgetbook
cd app/widgetbook

# Instalar dependências
flutter pub get

# Gerar código (necessário após criar novos UseCases)
dart run build_runner build --delete-conflicting-outputs

# Rodar o widgetbook
flutter run -d chrome
```

## 📁 Estrutura

```
lib/
├── main.dart                    # Entry point do Widgetbook
├── main.directories.g.dart      # Gerado automaticamente
└── stories/                     # UseCases de componentes
    ├── colors_story.dart        # Paleta de cores
    ├── spacing_story.dart       # Escala de espaçamento
    ├── typography_story.dart    # Variantes tipográficas
    └── radius_story.dart        # Border radius
```

## ✨ Addons Disponíveis

- **Theme Toggle**: Alterna entre Light e Dark mode
- **Device Frame**: Simula diferentes dispositivos
- **Grid**: Overlay de grid para alinhamento

## 🎨 Organizando Stories

Use a annotation `@widgetbook.UseCase` para registrar novos componentes:

```dart
@widgetbook.UseCase(
  name: 'Primary Button',
  type: DoriButton,
  path: '[Atoms]/Button',
)
Widget buildPrimaryButton(BuildContext context) {
  return DoriButton(
    label: context.knobs.string(label: 'Label', initialValue: 'Click me'),
    onPressed: () {},
  );
}
```

## 📦 Regenerando Código

Após adicionar novos `@UseCase`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

*Parte do projeto Caveo Flutter Challenge*
