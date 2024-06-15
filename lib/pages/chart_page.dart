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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(
              16.0), // Adicione padding ao redor do container
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20), // Adicione espaçamento
                ElevatedButton(
                  onPressed: () async {
                    subscribed.value = !subscribed.value;
                    await subUnsub();
                  },
                  child: ValueListenableBuilder(
                    valueListenable: subscribed,
                    builder: (context, value, child) {
                      return Text(
                        value ? 'Desinscrever' : 'Inscrever',
                      );
                    },
                  ),
                ),
                SizedBox(height: 20), // Adicione espaçamento
                ElevatedButton(
                  onPressed: fetchHistorico,
                  child: Text(
                    'Pegar o Histórico',
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
                historicoVibracao.isEmpty
                    ? Center(
                        child: Text(
                          'Clique em "Pegar o Histórico" para começar',
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: Card(
                          child: LineChart(
                            avgData(),
                            duration: const Duration(milliseconds: 0),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // final gradientColors = [
  //   const Color.fromARGB(255, 255, 0, 0),
  //   const Color.fromARGB(255, 72, 255, 0),
  //   const Color.fromARGB(255, 255, 145, 0),
  // ];

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(
          enabled: true, touchTooltipData: LineTouchTooltipData()),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        verticalInterval: 60,
        horizontalInterval: 10,
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
            interval: 3600, // Intervalo de 1 hora (3600 segundos)
            getTitlesWidget: (value, meta) {
              // Formatar o timestamp para uma string de data
              String label = DateFormat('HH:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000));
              return Text(label,
                  style: const TextStyle(
                      color: Colors
                          .black)); // Certifique-se de definir textColor ou usar uma cor padrão
            },
            showTitles: true,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
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
          isCurved: false,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            checkToShowDot: (spot, barData) {
              return spot.y > 100 || spot.y < 90;
            },
            show: true,
            getDotPainter: (p0, p1, p2, p3) {
              if (p0.y > 80) {
                return FlDotCirclePainter(
                  radius: 6,
                  strokeColor: Color.fromARGB(255, 209, 245, 47),
                  color: const Color.fromARGB(255, 255, 17, 0),
                );
              } else {
                return FlDotCirclePainter(
                  radius: 3,
                  color: Color.fromARGB(255, 4, 244, 0),
                );
              }
            },
          ),
          isStepLineChart: false,
          curveSmoothness: 0.8,
          preventCurveOverShooting: true,
          show: true,
          isStrokeJoinRound: false,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: historicoVibracao
                  .map(
                    (e) => e.vibration > 100
                        ? Color.fromARGB(255, 255, 17, 0)
                        : Color.fromARGB(255, 0, 207, 244).withAlpha(40),
                  )
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          // gradient: LinearGradient(
          //   colors: gradientColors,
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
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
