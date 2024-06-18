import 'package:app_tractian_poc/services/notifications/subscription_manager.dart';
import 'package:flutter/material.dart';
import 'chart_view.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  ValueNotifier<bool> subscribed = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    subscribed.value = prefs.getBool('subscribed') ?? false;
    subscribed.addListener(_handleSubscriptionChange);
  }

  Future<void> _handleSubscriptionChange() async {
    final prefs = await SharedPreferences.getInstance();
    await SubscriptionManager.handleSubscription(subscribed, prefs);
  }

  @override
  void dispose() {
    subscribed.removeListener(_handleSubscriptionChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Monitoramento de Vibração',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: subscribed,
            builder: (context, value, child) {
              return IconButton(
                onPressed: () {
                  subscribed.value = !subscribed.value;
                },
                icon: Icon(
                  value ? Icons.notifications_active : Icons.notifications_off,
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
      body: const ChartView(),
    );
  }
}
