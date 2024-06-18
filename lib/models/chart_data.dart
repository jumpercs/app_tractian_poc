class ChartData {
  final double timestamp;
  final double vibrationX;
  final double vibrationY;
  final double vibrationZ;

  ChartData(this.timestamp, this.vibrationX, this.vibrationY, this.vibrationZ);

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(double.parse((json['timestamp']).toString()),
        json['vibration']['x'], json['vibration']['y'], json['vibration']['z']);
  }

  @override
  String toString() {
    return 'ChartData{timestamp: $timestamp, vibrationX: $vibrationX, vibrationY: $vibrationY, vibrationZ: $vibrationZ}';
  }
}
