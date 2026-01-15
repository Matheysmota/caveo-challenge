# ADR 010: Abstração de Monitoramento de Conectividade (ConnectivityObserver)

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 15-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | connectivity, offline, networking, ux |

## Contexto e Problema

Conforme definido em [functional-specs.md](../functional-specs.md#feedback-visual-banners-de-status), o aplicativo precisa detectar e comunicar ao usuário quando ele está offline. Esta detecção deve ser:

1. **Reativa:** O app deve responder automaticamente a mudanças de conectividade.
2. **Desacoplada:** A UI não deve conhecer a biblioteca de conectividade utilizada.
3. **Imediata:** Ao subscrever, deve receber o status atual imediatamente.

O uso direto de bibliotecas como `connectivity_plus` nos Widgets criaria acoplamento e dificultaria testes e substituição futura.

## Alternativas Consideradas

### 1. Uso Direto de `connectivity_plus`
Importar `connectivity_plus` diretamente nos Widgets/ViewModels.
*   **Pros:** Simplicidade imediata.
*   **Cons:** Viola ADR 003 (Governança de Libs). Difícil de mockar em testes. Vendor lock-in.

### 2. Verificação sob demanda (On-Demand)
Criar um método `isConnected()` que verifica a conectividade pontualmente.
*   **Pros:** Simples de implementar.
*   **Cons:** Não é reativo. Perde mudanças de estado entre verificações. UX inferior.

### 3. Abstração Reativa via Interface (ConnectivityObserver) - **Opção Escolhida**
Criar uma interface que expõe um `Stream<ConnectivityStatus>`, permitindo que a UI reaja a mudanças em tempo real.

## Decisão

### 1. Interface ConnectivityObserver

Criaremos uma interface abstrata em `packages/shared/lib/drivers/connectivity/`:

```dart
/// Enum representing network connectivity status.
enum ConnectivityStatus {
  /// Device has network connectivity (Wi-Fi, Mobile Data, etc.)
  online,
  
  /// Device has no network connectivity.
  offline,
}

/// Abstract interface for monitoring network connectivity.
/// 
/// Implementations should:
/// - Emit the current status immediately upon subscription (BehaviorSubject-like).
/// - Emit new values whenever connectivity status changes.
abstract class ConnectivityObserver {
  /// Returns a stream that emits connectivity status.
  /// 
  /// - Emits current status immediately on subscription.
  /// - Emits new status whenever connectivity changes.
  Stream<ConnectivityStatus> observe();
  
  /// Disposes resources used by the observer.
  void dispose();
}
```

### 2. Comportamento da Stream

A Stream deve seguir o padrão **BehaviorSubject-like**:

| Evento | Comportamento |
|--------|---------------|
| Subscrição | Emite o status atual **imediatamente** |
| Mudança de status | Emite o novo status |
| Reconexão | Emite `ConnectivityStatus.online` |
| Perda de conexão | Emite `ConnectivityStatus.offline` |

### 3. Estrutura de Arquivos

```
packages/shared/
├── lib/
│   ├── drivers/
│   │   └── connectivity/
│   │       ├── connectivity_observer.dart        # Interface (PÚBLICO)
│   │       ├── connectivity_status.dart          # Enum (PÚBLICO)
│   │       └── connectivity_export.dart          # Barrel export
│   │
│   ├── src/
│   │   └── drivers/
│   │       └── connectivity/
│   │           └── connectivity_plus_observer.dart  # Impl (PRIVADO)
│   │
│   └── shared.dart
│
└── pubspec.yaml  # connectivity_plus como dependência interna
```

### 4. Encapsulamento da Implementação

*   A biblioteca `connectivity_plus` é dependência **interna** do package `/shared`.
*   A implementação concreta (`ConnectivityPlusObserver`) fica em `/src/` (privado).
*   **NÃO exportar** `connectivity_plus` em `/libraries/`.
*   Outros packages (como `/app`) só conhecem a interface `ConnectivityObserver`.
*   A DI (Riverpod) injeta a implementação concreta.

### 5. Uso na UI (ProductListPage)

Conforme [functional-specs.md](../functional-specs.md#feedback-visual-banners-de-status), a UI deve exibir banner "Você está offline" baseado no status:

```dart
// Exemplo conceitual (não código final)
StreamBuilder<ConnectivityStatus>(
  stream: connectivityObserver.observe(),
  builder: (context, snapshot) {
    final isOffline = snapshot.data == ConnectivityStatus.offline;
    
    return Column(
      children: [
        if (isOffline) DoriBanner.warning("Você está offline"),
        // ... resto da UI
      ],
    );
  },
);
```

### 6. Diferença entre "Offline" e "Dados Stale"

| Situação | Responsável | Banner |
|----------|-------------|--------|
| **Sem conexão de rede** | `ConnectivityObserver` | "Você está offline" |
| **API falhou (401, 500, timeout)** | Repository/ViewModel | "Seus dados podem estar desatualizados" |

São **dois mecanismos distintos** que não devem ser confundidos:
- `ConnectivityObserver`: Monitora hardware/SO.
- `isDataStale`: Estado de negócio no ViewModel.

## Consequências

### Positivas
*   **Reatividade:** UI responde instantaneamente a mudanças de conectividade.
*   **Desacoplamento:** Widgets não conhecem `connectivity_plus`.
*   **Testabilidade:** Fácil de mockar `ConnectivityObserver` em testes.
*   **UX Consistente:** Banner de offline aparece/desaparece automaticamente.
*   **Governança:** `connectivity_plus` não vaza para `/app`, respeitando ADR 003.

### Trade-offs
*   **Overhead:** Mais uma abstração a manter.
*   **Falsos positivos:** Estar "online" não garante que a API responderá (pode haver firewall, API down, etc.). O banner de "dados stale" cobre esse caso.

## Referências

*   [functional-specs.md](../functional-specs.md#feedback-visual-banners-de-status) — Especificação dos banners
*   [ADR 003](003-abstracao-e-governanca-bibliotecas.md) — Governança de dependências
*   [ADR 007](007-abstracao-cache-local.md) — Padrão de abstração similar (LocalCacheSource)
