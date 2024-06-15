import 'package:app_tractian_poc/pages/chart_page.dart';
import 'package:app_tractian_poc/pages/order_page.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatefulWidget {
  final OrderService orderService;

  const OrderDetailsPage({super.key, required this.orderService});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.orderService.id),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.timer_outlined),
        label: const Text('Iniciar Cronômetro'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              children: [
                ProgressGrid(
                  isSelected: widget.orderService.status == 'Aberta',
                  label: 'Aberta',
                  icon: Icons.lock_open,
                ),
                ProgressGrid(
                  isSelected: widget.orderService.status == 'Em espera',
                  label: 'Em espera',
                  icon: Icons.pause_circle_outline,
                ),
                ProgressGrid(
                  isSelected: widget.orderService.status == 'Em progresso',
                  label: 'Em progresso',
                  icon: Icons.handyman_outlined,
                ),
                ProgressGrid(
                  isSelected: widget.orderService.status == 'Concluída',
                  label: 'Concluída',
                  icon: Icons.check,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Titulo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              widget.orderService.name,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text("Data de Vencimento",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              widget.orderService.dueDate,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text("Responsável",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.orderService.responsibles[0].photo),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.orderService.responsibles[0].name,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text(
                  "Adicionar outro responsável",
                  style: TextStyle(color: Colors.blue),
                ),
                leading: const Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Divider(),
            const SizedBox(height: 8),
            const Text("Ativo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (var asset in widget.orderService.assets)
              InkWell(
                onTap: () {
                  navigateToMedicao();
                },
                child: ListTile(
                  title: Text(
                    asset,
                    style: TextStyle(color: Colors.blue),
                  ),
                  leading: const Icon(
                    Icons.model_training_rounded,
                    color: Colors.blue,
                  ),
                ),
              ),
          ],
        ),
      )),
    );
  }

  navigateToMedicao() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChartPage()),
    );
  }
}

class ProgressGrid extends StatelessWidget {
  const ProgressGrid({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
  });

  final String label;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: isSelected
            ? [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 40,
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ]
            : [
                Icon(icon),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
      ),
    );
  }
}
