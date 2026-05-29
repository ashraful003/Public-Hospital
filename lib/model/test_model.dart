class TestModel {
  final int id;
  final String name;
  final String testName;
  final double price;
  final String currency;

  TestModel({
    required this.id,
    required this.name,
    required this.testName,
    required this.price,
    required this.currency,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      testName: json['testName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "testName": testName,
      "price": price,
      "currency": currency,
    };
  }
}
