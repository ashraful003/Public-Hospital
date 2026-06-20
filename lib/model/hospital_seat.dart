class HospitalSeat {
  final int id;
  final String type;
  final String seatNo;
  final double price;
  final String currency;
  final bool status;

  HospitalSeat({
    required this.id,
    required this.type,
    required this.seatNo,
    required this.price,
    required this.currency,
    required this.status,
  });

  factory HospitalSeat.fromJson(Map<String, dynamic> json) {
    return HospitalSeat(
      id: json['id'] as int,
      type: json['type'] as String,
      seatNo: json['seatNo'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'seatNo': seatNo,
      'price': price,
      'currency': currency,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'HospitalSeat(id: $id, type: $type, seatNo: $seatNo, '
        'price: $price, currency: $currency, status: $status)';
  }
}
