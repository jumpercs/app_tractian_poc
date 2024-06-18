import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SubscriptionManager {
  static Future<void> handleSubscription(
      ValueNotifier<bool> subscribed, SharedPreferences prefs) async {
    if (subscribed.value) {
      await FirebaseMessaging.instance.subscribeToTopic('maquina_1');
      prefs.setBool('subscribed', true);
      debugPrint('Subscribed to maquina_1');
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic('maquina_1');
      prefs.setBool('subscribed', false);
      debugPrint('Unsubscribed from maquina_1');
    }
  }
}
