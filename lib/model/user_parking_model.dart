class UserParkingModel {
  final int? id;
  final String patientId;
  final String? patientName;
  final String? mobileNo;
  final String vehicleNo;
  final String? vehicleType;
  final int parkingId;
  final String? floor;
  final String? parkingNo;
  final DateTime? entryTime;
  final DateTime? exitTime;
  final int? totalHours;
  final double? parkingFee;
  final double? totalAmount;
  final bool? isActive;
  final String? status;

  UserParkingModel({
    this.id,
    required this.patientId,
    this.patientName,
    this.mobileNo,
    required this.vehicleNo,
    this.vehicleType,
    required this.parkingId,
    this.floor,
    this.parkingNo,
    this.entryTime,
    this.exitTime,
    this.totalHours,
    this.parkingFee,
    this.totalAmount,
    this.isActive,
    this.status,
  });

  factory UserParkingModel.fromJson(Map<String, dynamic> json) {
    return UserParkingModel(
      id: json["id"],
      patientId: json["patientId"] ?? "",
      patientName: json["patientName"],
      mobileNo: json["mobileNo"],
      vehicleNo: json["vehicleNo"] ?? "",
      vehicleType: json["vehicleType"],
      parkingId: json["parkingId"] ?? 0,
      floor: json["floor"],
      parkingNo: json["parkingNo"],
      entryTime: json["entryTime"] != null
          ? DateTime.parse(json["entryTime"])
          : null,
      exitTime: json["exitTime"] != null
          ? DateTime.parse(json["exitTime"])
          : null,
      totalHours: json["totalHours"],
      parkingFee: (json["parkingFee"] as num?)?.toDouble(),
      totalAmount: (json["totalAmount"] as num?)?.toDouble(),
      isActive: json["isActive"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "patientId": patientId,
      "patientName": patientName,
      "mobileNo": mobileNo,
      "vehicleNo": vehicleNo,
      "vehicleType": vehicleType,
      "parkingId": parkingId,
      "floor": floor,
      "parkingNo": parkingNo,
      "entryTime": entryTime?.toIso8601String(),
      "exitTime": exitTime?.toIso8601String(),
      "totalHours": totalHours,
      "parkingFee": parkingFee,
      "totalAmount": totalAmount,
      "isActive": isActive,
      "status": status,
    };
  }
}