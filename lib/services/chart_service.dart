import 'package:app_tractian_poc/shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:app_tractian_poc/models/chart_data.dart';

class ChartService {
  final Dio dio;

  ChartService(this.dio);

  Future<List<ChartData>> fetchHistorico() async {
    try {
      final response = await dio.get(historicoURL);
      return (response.data['data'] as List)
          .map((historico) => ChartData.fromJson(historico))
          .toList();
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch data');
    }
  }
}
