import 'package:app_tractian_poc/models/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:app_tractian_poc/controllers/chart_controller.dart';
import 'package:provider/provider.dart';

class ChartView extends StatefulWidget {
  const ChartView({super.key});

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChartController()..fetchHistorico(),
      child: Scaffold(
        body: Consumer<ChartController>(
          builder: (context, controller, child) {
            return controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildChart(controller);
          },
        ),
      ),
    );
  }

  Widget _buildChart(ChartController controller) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(
            16.0), // Adicione padding ao redor do container
        child: Center(
          child: Column(
            children: [
              controller.historicoVibracao.isEmpty
                  ? const Center(
                      child: Text(
                        'Clique em "Atualizar" para começar',
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.7,
                      child: LineChart(
                        _buildChartData(controller.historicoVibracao),
                        duration: const Duration(milliseconds: 150),
                      ),
                    ),
              ElevatedButton(
                onPressed: controller.fetchHistorico,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 5, // Adicione sombra
                ),
                child: const Text('Atualizar'),
              ),
              const SizedBox(height: 20), // Adicione espaçamento
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _buildChartData(List<ChartData> historicoVibracao) {
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
          if (value < 0) return const FlLine(color: Colors.transparent);

          if (value > 0 && value < 60) {
            return const FlLine(
                color: Color.fromARGB(255, 241, 165, 0), strokeWidth: 1);
          }

          if (value >= 60 && value <= 100) {
            return const FlLine(color: Colors.green, strokeWidth: 1);
          }

          if (value > 100) {
            return const FlLine(
              color: Colors.red,
              strokeWidth: 1,
            );
          }

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
          dotData: const FlDotData(show: false),
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
          dotData: const FlDotData(show: false),
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
          dotData: const FlDotData(show: false),
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
