import 'package:app_tractian_poc/models/person_model.dart';

class Order {
  final String id;
  final String name;
  final String location;
  final String status;
  final List<Person> responsibles;
  final String dueDate;
  final String priority;
  final bool late;
  final List<String> assets;

  const Order({
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

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      status: json['status'],
      responsibles: (json['responsibles'] as List<dynamic>)
          .map((responsible) => Person.fromJson(responsible))
          .toList(),
      dueDate: json['dueDate'],
      priority: json['priority'],
      late: json['late'],
      assets: (json['assets'] as List<dynamic>)
          .map((asset) => asset.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'status': status,
      'responsibles':
          responsibles.map((responsible) => responsible.toJson()).toList(),
      'dueDate': dueDate,
      'priority': priority,
      'late': late,
      'assets': assets,
    };
  }
}
