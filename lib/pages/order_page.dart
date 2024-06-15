import 'package:app_tractian_poc/pages/order_details_page.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 22, 26, 41),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 22, 26, 41),
              ),
              child: Image.network(
                  'https://static.wixstatic.com/media/71e7fa_4dc95a1262104a8fa717034d14dd52e4~mv2.png/v1/fit/w_500,h_500,q_90/file.png'),
            ),
            const ListTile(
              title: Text(
                'Ordens de Serviço',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Icon(
                Icons.edit_document,
                color: Colors.white,
              ),
            ),
            const ListTile(
              title: Text(
                'Equipamentos',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Icon(
                Icons.computer,
                color: Colors.white,
              ),
            ),
            const ListTile(
              title: Text(
                'Usuários',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const ListTile(
              title: Text(
                'Relatórios',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Icon(
                Icons.bar_chart,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 22, 26, 41),
        title: const Text('Ordens de Serviço'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: const [
          OrderServiceTile(
            orderService: OrderService(
              id: '#001',
              name: 'Inspeção de Motores Elétricos',
              location: 'Planta 1 - Setor A',
              status: 'Em progresso',
              responsibles: [
                Person(
                  name: 'Carlos',
                  photo: 'https://randomuser.me/api/portraits/men/1.jpg',
                ),
                Person(
                  name: 'Ana',
                  photo: 'https://randomuser.me/api/portraits/women/1.jpg',
                ),
              ],
              dueDate: '12/07/2024, 14:00',
              priority: 'Alta',
              late: false,
              assets: [
                'ME401001 - MOTOR VENTILADOR',
                'ME409834 - MOTOR BOMBA',
              ],
            ),
          ),
          OrderServiceTile(
            orderService: OrderService(
              id: '#003',
              name: 'Análise de Óleo Lubrificante',
              location: 'Planta 1 - Setor C',
              status: 'Em progresso',
              responsibles: [
                Person(
                  name: 'João',
                  photo: 'https://randomuser.me/api/portraits/men/3.jpg',
                ),
                Person(
                  name: 'Maria',
                  photo: 'https://randomuser.me/api/portraits/women/2.jpg',
                ),
                Person(
                  name: 'Roberto',
                  photo: 'https://randomuser.me/api/portraits/men/4.jpg',
                ),
              ],
              dueDate: '16/07/2024, 11:00',
              priority: 'Alta',
              late: false,
              assets: [
                'ME401002 - MOTOR DE ÓLEO',
              ],
            ),
          ),
          OrderServiceTile(
            orderService: OrderService(
              id: '#002',
              name: 'Monitoramento de Vibração',
              location: 'Planta 2 - Setor B',
              status: 'Aberta',
              responsibles: [
                Person(
                  name: 'Fernando',
                  photo: 'https://randomuser.me/api/portraits/men/2.jpg',
                ),
              ],
              dueDate: '14/07/2024, 09:00',
              priority: 'Baixa',
              late: false,
              assets: [
                'ME409835 - MOTOR VIBRADOR',
              ],
            ),
          ),
          OrderServiceTile(
            orderService: OrderService(
              id: '#004',
              name: 'Termografia de Equipamentos',
              location: 'Planta 3 - Setor D',
              status: 'Aberta',
              responsibles: [
                Person(
                  name: 'Luciana',
                  photo: 'https://randomuser.me/api/portraits/women/3.jpg',
                ),
                Person(
                  name: 'Marcos',
                  photo: 'https://randomuser.me/api/portraits/men/5.jpg',
                ),
              ],
              dueDate: '18/07/2024, 10:00',
              priority: 'Média',
              late: false,
              assets: [
                'ME409836 - MOTOR TERMOGRÁFICO',
              ],
            ),
          ),
          OrderServiceTile(
            orderService: OrderService(
              id: '#005',
              name: 'Inspeção de Rolamentos',
              location: 'Planta 2 - Setor E',
              status: 'Em progresso',
              responsibles: [
                Person(
                  name: 'Pedro',
                  photo: 'https://randomuser.me/api/portraits/men/6.jpg',
                ),
              ],
              dueDate: '20/07/2024, 15:00',
              priority: 'Alta',
              late: false,
              assets: [
                'ME401003 - MOTOR DE ROLAMENTO',
              ],
            ),
          ),
          OrderServiceTile(
            orderService: OrderService(
              id: '#006',
              name: 'Análise de Vibração',
              location: 'Planta 4 - Setor F',
              status: 'Aberta',
              responsibles: [
                Person(
                  name: 'Sofia',
                  photo: 'https://randomuser.me/api/portraits/women/4.jpg',
                ),
                Person(
                  name: 'Carlos',
                  photo: 'https://randomuser.me/api/portraits/men/7.jpg',
                ),
              ],
              dueDate: '22/07/2024, 13:00',
              priority: 'Baixa',
              late: false,
              assets: [
                'ME409837 - MOTOR DE ANÁLISE',
              ],
            ),
          ),
          OrderServiceTile(
            orderService: OrderService(
              id: '#007',
              name: 'Monitoramento de Temperatura',
              location: 'Planta 3 - Setor G',
              status: 'Em progresso',
              responsibles: [
                Person(
                  name: 'Fernanda',
                  photo: 'https://randomuser.me/api/portraits/women/5.jpg',
                ),
                Person(
                  name: 'João',
                  photo: 'https://randomuser.me/api/portraits/men/8.jpg',
                ),
                Person(
                  name: 'Mariana',
                  photo: 'https://randomuser.me/api/portraits/women/6.jpg',
                ),
              ],
              dueDate: '24/07/2024, 12:00',
              priority: 'Alta',
              late: false,
              assets: [
                'ME401004 - MOTOR DE MONITORAMENTO',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderService {
  final String id;
  final String name;
  final String location;
  final String status;
  final List<Person> responsibles;
  final String dueDate;
  final String priority;
  final bool late;
  final List<String> assets;

  const OrderService({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.responsibles,
    required this.dueDate,
    required this.priority,
    required this.late,
    required this.assets,
  });
}

class Person {
  final String name;
  final String photo;

  const Person({
    required this.name,
    required this.photo,
  });
}

class OrderServiceTile extends StatelessWidget {
  final OrderService orderService;
  const OrderServiceTile({super.key, required this.orderService});

  @override
  Widget build(BuildContext context) {
    var tractianBlue = const Color.fromARGB(255, 24, 93, 246);
    var tractianBackground = const Color.fromARGB(255, 202, 216, 229);
    var statusColors = {
      'Em progresso': tractianBackground,
      'Aberta': const Color.fromARGB(0, 12, 255, 12),
    };

    var priorityColors = {
      'Alta': const Color.fromARGB(52, 255, 0, 0),
      'Média': const Color.fromARGB(52, 255, 255, 0),
      'Baixa': const Color.fromARGB(52, 0, 255, 0),
    };

    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  OrderDetailsPage(orderService: orderService),
            ),
          );
        },
        child: ListTile(
          isThreeLine: true,
          minVerticalPadding: 10,
          leading: CircleAvatar(
            backgroundColor: tractianBackground,
            child: Icon(
              Icons.edit_document,
              color: tractianBlue,
            ),
          ),
          title: Text(orderService.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(orderService.location),
              Container(
                decoration: BoxDecoration(
                  color:
                      statusColors[orderService.status] ?? tractianBackground,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    orderService.status,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 14, 48, 163),
                    ),
                  ),
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (int i = 0; i < orderService.responsibles.length; i++)
                    Align(
                      widthFactor: 0.5,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage:
                            NetworkImage(orderService.responsibles[i].photo),
                      ),
                    )
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: priorityColors[orderService.priority] ??
                      tractianBackground.withOpacity(0.5),
                  border: Border.all(
                      color: priorityColors[orderService.priority] ??
                          tractianBackground),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    orderService.priority,
                    style: TextStyle(
                      color: orderService.priority == 'Alta'
                          ? Colors.red
                          : orderService.priority == 'Baixa'
                              ? Colors.green
                              : orderService.priority == 'Média'
                                  ? Colors.yellow
                                  : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
