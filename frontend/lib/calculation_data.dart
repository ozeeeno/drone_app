class CalculationData {
  final String name;
  final String value;

  CalculationData({required this.name, required this.value});

  factory CalculationData.fromJson(Map<String, dynamic> json) {
    return CalculationData(
      name: json['name'] as String,
      value: json['value'] as String,
    );
  }
}
