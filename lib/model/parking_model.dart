class ParkingModel {
  final int parkingId;
  final String floor;
  final String parkingNo;
  final double parkingFee;
  final bool isActive;

  ParkingModel({
    required this.parkingId,
    required this.floor,
    required this.parkingNo,
    required this.parkingFee,
    required this.isActive,
  });

  factory ParkingModel.fromJson(Map<String, dynamic> json) {
    return ParkingModel(
      parkingId: json['id'],
      floor: json['floor'],
      parkingNo: json['parkingNo'],
      parkingFee: (json['parkingFee'] as num).toDouble(),
      isActive: json['isActive'] ?? true,
    );
  }
}
