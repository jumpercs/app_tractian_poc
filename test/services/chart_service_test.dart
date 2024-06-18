// test/chart_service_test.dart

import 'package:app_tractian_poc/services/chart_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chart_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late ChartService chartService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    chartService = ChartService(mockDio);
  });

  test('fetchHistorico returns list of ChartData', () async {
    final responsePayload = {
      'data': [
        {
          'timestamp': 1718664359.207394,
          'vibration': {
            'x': 67.31632978556084,
            'y': 74.47107681451574,
            'z': 74.91796647234618
          }
        },
        {
          'timestamp': 1718664360.21734,
          'vibration': {
            'x': 67.65338977181302,
            'y': 67.26022480023424,
            'z': 74.4375026433306
          }
        }
      ],
    };

    when(mockDio.get(any)).thenAnswer(
      (_) async => Response(
        data: responsePayload,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final historico = await chartService.fetchHistorico();

    expect(historico.length, 2);
    expect(historico[0].timestamp, 1718664359.207394);
    expect(historico[0].vibrationX, 67.31632978556084);
    expect(historico[0].vibrationY, 74.47107681451574);
    expect(historico[0].vibrationZ, 74.91796647234618);
  });
}
