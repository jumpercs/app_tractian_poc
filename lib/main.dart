import 'package:app_tractian_poc/firebase_options.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fl_chart/fl_chart.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  print('Handling a background message ${message.messageId}');
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    showFlutterNotification(message);
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

final Color primaryColor = Color(0xFF0033A0); // Azul TRACTIAN
final Color secondaryColor = Color(0xFF00A0FF); // Azul claro
final Color backgroundColor = Color(0xFFF5F5F5); // Cinza claro
final Color textColor = Color(0xFF000000); // Preto

final TextStyle headlineStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Color(0xFF000000),
);

final TextStyle bodyStyle = TextStyle(
  fontFamily: 'Open Sans',
  fontSize: 16,
  color: Color(0xFF000000),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoramento TRACTIAN',
      theme: ThemeData(
        primaryColor: primaryColor,
        hintColor: secondaryColor,
        textTheme: TextTheme(
          displayLarge: headlineStyle,
          bodyLarge: bodyStyle,
        ),
        backgroundColor: backgroundColor,
      ),
      home: Application(),
    );
  }
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final _historicoURL =
      'https://710e-45-178-234-183.ngrok-free.app/fetch-history';

  List<HistoricoVibracao> historicoVibracao = [];

  Future fetchHistorico() async {
    try {
      final response = await Dio().get(_historicoURL);
      print(response.data);
      historicoVibracao = (response.data['data'] as List)
          .map((historico) => HistoricoVibracao.fromJson(historico))
          .toList();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoramento de Vibração', style: headlineStyle),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await FirebaseMessaging.instance.requestPermission();
                  await FirebaseMessaging.instance
                      .subscribeToTopic('maquina_1');
                  print('Subscribed to maquina_1');
                },
                child: Text('MONITORAR MÁQUINA 1', style: bodyStyle),
                style: ElevatedButton.styleFrom(
                  primary: secondaryColor,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: fetchHistorico,
                child: Text('Pegar o Histórico', style: bodyStyle),
                style: ElevatedButton.styleFrom(
                  primary: secondaryColor,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Expanded(
                child: historicoVibracao.isEmpty
                    ? Center(
                        child: Text(
                            'Clique em "Pegar o Histórico" para começar',
                            style: bodyStyle),
                      )
                    : LineChart(
                        avgData(),
                        curve: Curves.easeInOutCubic,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final gradientColors = [
    const Color.fromARGB(255, 255, 0, 0),
    const Color.fromARGB(255, 72, 255, 0),
    const Color.fromARGB(255, 255, 145, 0),
  ];

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        verticalInterval: 1,
        horizontalInterval: 30,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        leftTitles: const AxisTitles(
          axisNameWidget: Text(
            'Vibração (v/s)',
          ),
          drawBelowEverything: true,
          sideTitles: SideTitles(
            interval: 10,
            showTitles: true,
            reservedSize: 45,
          ),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: const Text(
            'Tempo (s)',
          ),
          axisNameSize: 20,
          drawBelowEverything: true,
          sideTitles: SideTitles(
            interval: 20,
            getTitlesWidget: (value, meta) {
              //convert seconds to minutes
              value = (value / 60) * 300;

              return Text(value.toString());
            },
            showTitles: true,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: historicoVibracao
          .map((e) => e.timestamp)
          .reduce((a, b) => a < b ? a : b),
      maxX: historicoVibracao
          .map((e) => e.timestamp)
          .reduce((a, b) => a > b ? a : b),
      minY: 0,
      maxY: historicoVibracao
              .map((e) => e.vibration)
              .reduce((a, b) => a > b ? a : b) +
          10,
      baselineY: 0,
      baselineX: 0,
      lineBarsData: [
        LineChartBarData(
          spots: historicoVibracao
              .map((e) => FlSpot(e.timestamp, e.vibration))
              .toList(),
          isCurved: true,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            checkToShowDot: (spot, barData) {
              return spot.y > 100 || spot.y < 90;
            },
            show: true,
            getDotPainter: (p0, p1, p2, p3) {
              if (p0.y > 100) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: const Color.fromARGB(255, 255, 17, 0),
                );
              } else {
                return FlDotCirclePainter(
                  radius: 6,
                  color: const Color.fromARGB(255, 241, 177, 0),
                );
              }
            },
          ),
          isStepLineChart: false,
          curveSmoothness: 0.3,
          preventCurveOverShooting: true,
          show: true,
          isStrokeJoinRound: false,
          belowBarData: BarAreaData(
            show: false,
            color: const Color.fromARGB(255, 237, 11, 11).withOpacity(0.3),
          ),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ],
    );
  }
}

class HistoricoVibracao {
  final double timestamp;
  final double vibration;

  HistoricoVibracao(this.timestamp, this.vibration);

  factory HistoricoVibracao.fromJson(Map<String, dynamic> json) {
    return HistoricoVibracao(
        double.parse((json['timestamp']).toString()), json['vibration']);
  }

  @override
  String toString() {
    return 'HistoricoVibracao{timestamp: $timestamp, vibration: $vibration}';
  }
}
