import 'package:app_tractian_poc/models/order_model.dart';
import 'package:app_tractian_poc/pages/chart_page.dart';
import 'package:app_tractian_poc/widgets/progress_grid.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order orders;

  const OrderDetailsPage({super.key, required this.orders});

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
        title: Text(widget.orders.id),
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
                  isSelected: widget.orders.status == 'Aberta',
                  label: 'Aberta',
                  icon: Icons.lock_open,
                ),
                ProgressGrid(
                  isSelected: widget.orders.status == 'Em espera',
                  label: 'Em espera',
                  icon: Icons.pause_circle_outline,
                ),
                ProgressGrid(
                  isSelected: widget.orders.status == 'Em progresso',
                  label: 'Em progresso',
                  icon: Icons.handyman_outlined,
                ),
                ProgressGrid(
                  isSelected: widget.orders.status == 'Concluída',
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
              widget.orders.name,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text("Data de Vencimento",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              widget.orders.dueDate,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text("Responsável",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.orders.responsibles[0].photo),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.orders.responsibles[0].name,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {},
              child: const ListTile(
                title: Text(
                  "Adicionar outro responsável",
                  style: TextStyle(color: Colors.blue),
                ),
                leading: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            const Text("Ativo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (var asset in widget.orders.assets)
              InkWell(
                onTap: () {
                  navigateToMedicao();
                },
                child: ListTile(
                  title: Text(
                    asset,
                    style: const TextStyle(color: Colors.blue),
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
      MaterialPageRoute(builder: (context) => const ChartPage()),
    );
  }
}
