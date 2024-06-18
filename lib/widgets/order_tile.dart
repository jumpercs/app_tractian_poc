import 'package:app_tractian_poc/models/order_model.dart';
import 'package:app_tractian_poc/models/person_model.dart';
import 'package:app_tractian_poc/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:app_tractian_poc/pages/order_details_page.dart';

class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(orders: order),
            ),
          );
        },
        child: ListTile(
          isThreeLine: true,
          minVerticalPadding: 10,
          leading: const CircleAvatar(
            backgroundColor: tractianBackground,
            child: Icon(
              Icons.edit_document,
              color: tractianBlue,
            ),
          ),
          title: Text(order.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.location),
              _buildStatusContainer(order.status, statusColors),
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildResponsiblesAvatars(order.responsibles),
              _buildPriorityContainer(order.priority, priorityColors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusContainer(String status, Map<String, Color> statusColors) {
    return Container(
      decoration: BoxDecoration(
        color: statusColors[status] ?? Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          status,
          style: const TextStyle(
            color: Color.fromARGB(255, 14, 48, 163),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityContainer(
      String priority, Map<String, Color> priorityColors) {
    return Container(
      decoration: BoxDecoration(
        color: priorityColors[priority] ?? Colors.grey.withOpacity(0.5),
        border: Border.all(
          color: priorityColors[priority] ?? Colors.grey,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          priority,
          style: TextStyle(
            color: _getPriorityTextColor(priority),
          ),
        ),
      ),
    );
  }

  Color _getPriorityTextColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red;
      case 'Média':
        return Colors.yellow;
      case 'Baixa':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  Widget _buildResponsiblesAvatars(List<Person> responsibles) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        for (int i = 0; i < responsibles.length; i++)
          Align(
            widthFactor: 0.5,
            child: CircleAvatar(
              radius: 10,
              backgroundImage: NetworkImage(responsibles[i].photo),
            ),
          ),
      ],
    );
  }
}
