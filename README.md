## Monitoramento TRACTIAN - POC Flutter

Este projeto é uma prova de conceito (POC) para um aplicativo Flutter que replica algumas funcionalidades do aplicativo oficial da TRACTIAN. O objetivo é demonstrar habilidades em desenvolvimento Flutter, consumo de APIs, visualização de dados em gráficos interativos, gerenciamento de notificações push e integração com serviços externos.

### Funcionalidades

- **Visualização de Ordens de Serviço:** Listagem de ordens de serviço com informações como ID, nome, status, responsáveis, data de vencimento, prioridade e ativos relacionados.
- **Detalhes da Ordem de Serviço:** Tela de detalhes da ordem de serviço, mostrando informações adicionais como status, responsáveis, data de vencimento, ativos relacionados e histórico de medições.
- **Gráfico de Vibração:** Gráfico interativo que mostra a vibração em tempo real de um ativo, com visualização em três eixos (X, Y, Z).
- **Notificações Push:** Notificações em tempo real para o usuário em caso de vibração anormal detectada nos ativos.
- **Gerenciamento de Assinaturas:** Permite que o usuário ative ou desative as notificações push para os ativos que deseja monitorar.

### Arquitetura

O projeto utiliza a seguinte estrutura:

- **Flutter:** Framework de desenvolvimento para aplicações mobile.
- **Firebase:** Para autenticação de usuários, banco de dados (Firestore) e notificações push.
- **Dio:** Biblioteca para realizar requisições HTTP.
- **Fl Chart:** Biblioteca para criar gráficos interativos.
- **SharedPreferences:** Para armazenar dados locais.
- **Flutter Local Notifications:** Para notificações locais.
- **Backend Simulado:** API REST para simular a coleta de dados de vibração (usando Flask e WebSocket).

### Demonstração de Habilidades

Este projeto demonstra as seguintes habilidades:

- **Flutter:** Desenvolvimento de interfaces de usuário, navegação entre telas, gerenciamento de estado, widgets personalizados.
- **Consumo de API:** Integração com API REST (utilizando Dio), tratamento de respostas e erros.
- **Visualização de Dados:** Criação de gráficos interativos com Fl Chart, personalização de gráficos, manipulação de dados.
- **Gerenciamento de Notificações Push:** Implementação de notificações push com Firebase, gerenciamento de assinaturas de tópicos.
- **Gerenciamento de Estado:** Uso de ValueNotifier para gerenciar o estado de subscrição de notificações.
- **Testes:** Escrita de testes unitários para validação das funcionalidades.

### Instruções de Uso

1. **Clonar o Repositório:** Clone o repositório do GitHub: `git clone https://github.com/jumpercs/app_tractian_poc.git`
2. **Instalar Dependências:** Navegue para o diretório do projeto e instale as dependências com `flutter pub get`.
3. **Configurar Firebase:** Crie um projeto no Firebase e configure as credenciais no arquivo `firebase_options.dart`.
4. **Iniciar o Backend:** Execute o servidor Flask e WebSocket seguindo as instruções do repositório do backend. `https://github.com/jumpercs/tractian_sensor_simulation`
5. **Executar o App:** Execute o aplicativo Flutter com `flutter run`.

### Considerações

Este projeto é uma apresentação técnica para a TRACTIAN e não está pronto para produção. 

