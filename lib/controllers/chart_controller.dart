import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_tractian_poc/models/chart_data.dart';
import 'package:app_tractian_poc/services/chart_service.dart';

class ChartController with ChangeNotifier {
  ChartService chartService = ChartService(Dio());
  List<ChartData> historicoVibracao = [];
  bool isLoading = false;

  Future<void> fetchHistorico() async {
    isLoading = true;
    notifyListeners();
    try {
      historicoVibracao = await chartService.fetchHistorico();
    } catch (e) {
      debugPrint('Erro ao buscar histórico de vibração: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
