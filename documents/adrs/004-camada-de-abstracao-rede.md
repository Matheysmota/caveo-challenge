# ADR 004: Abstração da Camada de Rede (Networking)

| Metadado | Valor |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 13-01-2026 |
| **Decisores** | Matheus Mota |
| **Tags** | arquitetura, networking, desacoplamento, segurança |

## Contexto e Problema
A comunicação com APIs externas é uma parte crítica da aplicação. Ferramentas de mercado como `dio`, `http` ou `retrofit` são excelentes, mas criar uma dependência direta entre a regra de negócio (Repositories/UseCases) e uma biblioteca específica gera um alto acoplamento (Vendor Lock-in).

Se, no futuro, a biblioteca escolhida for descontinuada, sofrer alterações drásticas de licença ou apresentar problemas de performance, a refatoração seria custosa, exigindo alterações em centenas de arquivos de repositório. Além disso, garantir que todas as chamadas sigam os mesmos padrões de segurança, tratamento de erro e retry policies torna-se impossível sem um ponto central de controle.

## Alternativas Consideradas

### 1. Uso Direto de Bibliotecas (ex: Dio/Http)
Injetar a instância do `Dio` diretamente nos Repositórios.
*   **Pros:** Rápido de implementar, aproveita todos os recursos nativos da lib.
*   **Cons:** Acoplamento total. Se o método `.get()` do Dio mudar sua assinatura, quebramos todos os repositórios. Dificuldade de mockar o cliente HTTP em testes unitários sem bibliotecas adicionais (`mock_web_server` ou `mockito` complexos).

### 2. Camada de Abstração via Delegate (ApiDataSourceDelegate) - **Opção Escolhida**
Definir um contrato (Interface/Protocolo) próprio do projeto para operações de rede, desacoplando completamente a implementação da utilização.

## Decisão
Decidimos implementar o padrão **ApiDataSourceDelegate** para toda comunicação HTTP.

1.  **Contrato Único:**
    Criaremos uma interface abstrata (ex: `ApiDataSourceDelegate`) que define métodos agnósticos à biblioteca, utilizando tipos primitivos ou DTOs próprios do projeto.
    ```dart
    abstract class ApiDataSourceDelegate {
      Future<AppResponse> get(String path, {Map<String, dynamic>? query});
      Future<AppResponse> post(String path, {dynamic body});
      // ...
    }
    ```

2.  **Uso nos Repositórios:**
    Os Repositórios (`app/lib/features/{feature}/infrastructure/repositories`) devem depender **exclusivamente** de `ApiDataSourceDelegate`. É estritamente proibido importar `dio`, `http` ou qualquer pacote externo dentro de uma classe de repositório.

3.  **Implementação Injetada:**
    A implementação concreta (ex: `DioApiDataSourceDelegate`) residirá em `packages/shared/lib/drivers/` e será injetada via Injeção de Dependência (Riverpod). É neste único ponto que a biblioteca externa (Dio) será importada e configurada.

4.  **Bloqueio via CI/CD:**
    Reforçando a ADR 003, o script de CI/CD bloqueará qualquer importação de bibliotecas de rede (`package:dio`, `package:http`) em arquivos dentro de `app/lib/`.

## Consequências
*   **Desacoplamento Real:** O código da aplicação "não sabe" que o Dio existe. Podemos substituir o Dio pelo cliente nativo do Dart ou outra lib em 1 dia, alterando apenas 1 arquivo.
*   **Testabilidade:** Testar repositórios torna-se trivial. Não precisamos mockar o servidor HTTP nem a classe complexa do Dio; apenas criamos um `MockApiDataSourceDelegate` que retorna objetos simples.
*   **Consistência:** Tratamento de erros, Refresh Token, Logger e Headers padrões são configurados em um único lugar.
*   **Segurança:** Previne que desenvolvedores façam chamadas HTTP "soltas" sem passar pelos interceptors de segurança da aplicação.
