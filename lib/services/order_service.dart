import 'package:app_tractian_poc/mock_data/order_services.dart';
import 'package:app_tractian_poc/models/order_model.dart';

class OrderService {
  static Future<List<Order>> fetchOrderServices() async {
    final List<dynamic> data = orderServicesMockData;

    return data.map((json) => Order.fromJson(json)).toList();
  }
}
