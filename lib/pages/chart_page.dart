import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final _historicoURL =
      'https://9298-45-178-234-183.ngrok-free.app/fetch-history';

  List<AtivoDados> historicoVibracao = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    fetchHistorico();
  }

  init() async {
    final prefs = await SharedPreferences.getInstance();
    subscribed.value = prefs.getBool('subscribed') ?? false;
    print('Subscribed: ${subscribed.value}');
    setState(() {});
  }

  Future fetchHistorico() async {
    try {
      final response = await Dio().get(_historicoURL);
      print(response.data);
      historicoVibracao = (response.data['data'] as List)
          .map((historico) => AtivoDados.fromJson(historico))
          .toList();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  ValueNotifier<bool> subscribed = ValueNotifier(false);

  subUnsub() async {
    if (subscribed.value) {
      await FirebaseMessaging.instance.unsubscribeFromTopic('maquina_1');
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('subscribed', false);
      });
      print('Unsubscribed from maquina_1');
    } else {
      await FirebaseMessaging.instance.subscribeToTopic('maquina_1');
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('subscribed', true);
      });
      print('Subscribed to maquina_1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Monitoramento de Vibração',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              subscribed.value = !subscribed.value;
              subUnsub();
              setState(() {});
            },
            icon: Icon(
              subscribed.value
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(
              16.0), // Adicione padding ao redor do container
          child: Center(
            child: Column(
              children: [
                historicoVibracao.isEmpty
                    ? Center(
                        child: Text(
                          'Clique em "Pegar o Histórico" para começar',
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.7,
                        child: LineChart(
                          avgData(),
                          duration: const Duration(milliseconds: 150),
                        ),
                      ),
                // Adicione espaçamento
                ElevatedButton(
                  onPressed: fetchHistorico,
                  child: Text(
                    'Atualizar',
                  ),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 5, // Adicione sombra
                  ),
                ),
                SizedBox(height: 20), // Adicione espaçamento
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(
        enabled: true,
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        verticalInterval: 60,
        horizontalInterval: 20,
        getDrawingHorizontalLine: (value) {
          if (value < 0) return FlLine(color: Colors.transparent);

          if (value > 0 && value < 60)
            return FlLine(
                color: Color.fromARGB(255, 241, 165, 0), strokeWidth: 1);

          if (value >= 60 && value <= 100)
            return FlLine(color: Colors.green, strokeWidth: 1);

          if (value > 100)
            return FlLine(
              color: Colors.red,
              strokeWidth: 1,
            );

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
            'Vibração (mm/s)',
          ),
          drawBelowEverything: true,
          sideTitles: SideTitles(
            interval: 20,
            showTitles: true,
            reservedSize: 45,
          ),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: const Text(
            'Tempo (minutos)',
          ),
          axisNameSize: 20,
          sideTitles: SideTitles(
            interval: 30, // Intervalo de 1 hora (3600 segundos)
            getTitlesWidget: (value, meta) {
              // Formatar o timestamp para uma string de data
              String label = DateFormat('mm:ss').format(
                  DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000));
              return Text(label, style: const TextStyle(color: Colors.black));
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
              .map((e) => [e.vibrationX, e.vibrationY, e.vibrationZ]
                  .reduce((a, b) => a > b ? a : b))
              .reduce((a, b) => a > b ? a : b) +
          10,
      baselineY: 0,
      baselineX: 0,
      lineBarsData: [
        LineChartBarData(
          spots: historicoVibracao
              .map((e) => FlSpot(e.timestamp, e.vibrationX))
              .toList(),
          isCurved: true,
          barWidth: 1,
          isStrokeJoinRound: false,
          isStrokeCapRound: false,
          dotData: FlDotData(show: false),
          color: Colors.red, // Cor para o eixo X
          belowBarData: BarAreaData(
            show: false,
            color: Colors.red, // Cor para o preenchimento do eixo X
          ),
        ),
        LineChartBarData(
          spots: historicoVibracao
              .map((e) => FlSpot(e.timestamp, e.vibrationY))
              .toList(),
          isCurved: true,
          barWidth: 1,

          isStrokeJoinRound: false,
          isStrokeCapRound: false,
          dotData: FlDotData(show: false),
          color: Colors.green, // Cor para o eixo Y
          belowBarData: BarAreaData(
              show: false,
              color: Colors.green // Cor para o preenchimento do eixo Y
              ),
        ),
        LineChartBarData(
          spots: historicoVibracao
              .map((e) => FlSpot(e.timestamp, e.vibrationZ))
              .toList(),
          isCurved: true,
          barWidth: 1,

          isStrokeJoinRound: false,
          isStrokeCapRound: false,
          dotData: FlDotData(show: false),
          color: Colors.blue, // Cor para o eixo Z
          belowBarData: BarAreaData(
            show: false,
            color: Colors.blue, // Cor para o preenchimento do eixo Z
          ),
        ),
      ],
    );
  }
}

class AtivoDados {
  final double timestamp;
  final double vibrationX;
  final double vibrationY;
  final double vibrationZ;

  AtivoDados(this.timestamp, this.vibrationX, this.vibrationY, this.vibrationZ);

  factory AtivoDados.fromJson(Map<String, dynamic> json) {
    return AtivoDados(double.parse((json['timestamp']).toString()),
        json['vibration']['x'], json['vibration']['y'], json['vibration']['z']);
  }

  @override
  String toString() {
    return 'AtivoDados{timestamp: $timestamp, vibrationX: $vibrationX, vibrationY: $vibrationY, vibrationZ: $vibrationZ}';
  }
}
