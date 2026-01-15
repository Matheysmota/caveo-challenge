# ADR 007: Abstração de Cache Local e Políticas de Expiração

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 13-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | cache, offline-first, performance, security |

## Contexto e Problema
Para atender aos requisitos funcionais de modo offline e economizar requisições de rede (conforme `functional-specs.md`), precisamos de uma estratégia de persistência local. Depender diretamente de implementações como `SharedPreferences`, `Hive` ou `Sqflite` gera acoplamento e dificulta a aplicação de políticas de negócio uniformes, como a invalidação de dados obsoletos (TTL - Time To Live).

Além disso, é crucial diferenciar o armazenamento de dados comuns (cache de JSON, configurações de UI) de dados sensíveis (tokens, PII), embora o escopo inicial trate apenas de dados públicos (produtos).

## Alternativas Consideradas

### 1. Uso Direto de Bibliotecas (ex: SharedPreferences / Hive)
Acessar `SharedPreferences.getInstance()` diretamente nos Repositórios.
*   **Pros:** Simplicidade imediata.
*   **Cons:** Lógica de expiração (TTL) fica espalhada ou inexistente. Dificuldade de migrar para bancos mais performáticos (ex: ISAR) se o volume de dados crescer.

### 2. Camada Abstrata com Gestão de TTL - **Opção Escolhida**
Criar um contrato de serviço (`LocalCacheSource`) que encapsula não apenas a leitura/escrita, mas também a validade do dado.

## Decisão
1.  **Interface de Cache Genérica:**
    Criaremos uma interface agnóstica em `infrastructure/cache` (ou `shared/services`):
    ```dart
    abstract class LocalCacheSource {
      Future<void> save(String key, Map<String, dynamic> data, {Duration? ttl});
      Future<Map<String, dynamic>?> get(String key);
      Future<void> delete(String key);
      Future<void> clear();
    }
    ```

2.  **Política de Invalidação (TTL):**
    *   A implementação deve armazenar metadados junto com o dado (timestamp da gravação + duração do TTL).
    *   No método `get(key)`, verificar se `DateTime.now() > timestamp + ttl`.
    *   **Se expirado:** O método deve limpar o dado internamente e retornar `null` (mimetizando um "cache miss"), obrigando o repositório a buscar da API.

3.  **Segurança de Dados:**
    *   Para o escopo deste desafio (lista de produtos públicos e imagens), usaremos implementações padrão (ex: `SharedPreferences` ou `Hive` sem criptografia pesada) visando performance e simplicidade.
    *   **Ressalva Importante:** Esta camada **NÃO deve ser usada para persistir dados sensíveis** (Senhas, Access Tokens, PII).
    *   **Evolução Futura:** Caso o projeto evolua para armazenar dados sensiveis, a implementação concreta dessa interface deverá ser substituída ou decorada por uma solução segura (ex: `FlutterSecureStorage` ou `Hive` com chave de criptografia AES-256), sem alterar os contratos dos repositórios.

## Consequências
*   **Consistência:** Garantimos que o usuário não verá preços antigos por tempo indeterminado (o TTL força a atualização).
*   **Desacoplamento:** Repositórios não sabem se o dado está num arquivo JSON, no SQLite ou na RAM.
*   **Flexibilidade:** Podemos trocar `SharedPreferences` por `Hive` apenas alterando a classe concreta na injeção de dependência do Riverpod.
