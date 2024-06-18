import 'package:flutter/material.dart';
import 'package:app_tractian_poc/models/order_model.dart';
import 'package:app_tractian_poc/widgets/order_tile.dart';
import 'package:app_tractian_poc/services/order_service.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = OrderService.fetchOrderServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return ListView(
              children: snapshot.data!
                  .map((order) => OrderTile(
                        order: order,
                      ))
                  .toList(),
            );
          }
        },
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
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
          _buildDrawerItem(
            icon: Icons.edit_document,
            text: 'Ordens de Serviço',
          ),
          _buildDrawerItem(
            icon: Icons.computer,
            text: 'Equipamentos',
          ),
          _buildDrawerItem(
            icon: Icons.person,
            text: 'Usuários',
          ),
          _buildDrawerItem(
            icon: Icons.bar_chart,
            text: 'Relatórios',
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem({required IconData icon, required String text}) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      leading: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 22, 26, 41),
      title: const Text('Ordens de Serviço'),
      actions: [
        IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: () {}),
      ],
    );
  }
}
