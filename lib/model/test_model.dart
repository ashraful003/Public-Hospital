class TestModel {
  final int id;
  final String name;
  final String testName;
  final double price;
  final String currency;
  final String unit;
  final String range;

  TestModel({
    required this.id,
    required this.name,
    required this.testName,
    required this.price,
    required this.currency,
    required this.unit,
    required this.range,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      testName: json['testName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      unit: json['unit'] ?? '',
      range: json['range'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'testName': testName,
      'price': price,
      'currency': currency,
      'unit': unit,
      'range': range,
    };
  }

  TestModel copyWith({
    int? id,
    String? name,
    String? testName,
    double? price,
    String? currency,
    String? unit,
    String? range,
  }) {
    return TestModel(
      id: id ?? this.id,
      name: name ?? this.name,
      testName: testName ?? this.testName,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      unit: unit ?? this.unit,
      range: range ?? this.range,
    );
  }
}