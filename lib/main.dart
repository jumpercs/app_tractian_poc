import 'package:flutter/material.dart';
import 'package:app_tractian_poc/pages/order_page.dart';
import 'services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monitoramento TRACTIAN',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: const OrderPage(),
    );
  }
}
