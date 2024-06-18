// test/chart_controller_test.dart

import 'package:app_tractian_poc/controllers/chart_controller.dart';
import 'package:app_tractian_poc/models/chart_data.dart';
import 'package:app_tractian_poc/services/chart_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chart_controller_test.mocks.dart';

@GenerateMocks([ChartService])
void main() {
  late ChartController chartController;
  late MockChartService mockChartService;

  setUp(() {
    mockChartService = MockChartService();
    chartController = ChartController();
    chartController.chartService = mockChartService;
  });

  test('fetchHistorico sets historicoVibracao and isLoading correctly',
      () async {
    final historico = [
      ChartData(1718664359.207394, 67.31632978556084, 74.47107681451574,
          74.91796647234618),
      ChartData(1718664360.21734, 67.65338977181302, 67.26022480023424,
          74.4375026433306),
    ];

    when(mockChartService.fetchHistorico()).thenAnswer((_) async => historico);

    final future = chartController.fetchHistorico();

    expect(chartController.isLoading, true);
    await future;
    expect(chartController.isLoading, false);
    expect(chartController.historicoVibracao, historico);
  });
}
