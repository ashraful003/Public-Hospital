class InpatientBill {
  final int? id;
  final int admissionId;
  final int patientId;
  final String patientName;
  final int? doctorId;
  final String? doctorName;
  final String? seatNo;
  final String? seatType;
  final int? totalDays;
  final double bedCharge;
  final double doctorCharge;
  final double operationCharge;
  final double medicineCharge;
  final double pathologyCharge;
  final double radiologyCharge;
  final double nursingCharge;
  final double oxygenCharge;
  final double otherCharge;
  final double discount;
  final double vat;
  final double subtotal;
  final double grandTotal;
  final double paidAmount;
  final double dueAmount;
  final String paymentStatus;
  final String? paymentMethod;
  final int? paidById;
  final String? paidByName;
  final DateTime? paymentDate;
  final String billStatus;
  final DateTime? billDate;
  final int? createdById;
  final String? createdByName;

  const InpatientBill({
    this.id,
    required this.admissionId,
    required this.patientId,
    required this.patientName,
    this.doctorId,
    this.doctorName,
    this.seatNo,
    this.seatType,
    this.totalDays,
    this.bedCharge = 0.0,
    this.doctorCharge = 0.0,
    this.operationCharge = 0.0,
    this.medicineCharge = 0.0,
    this.pathologyCharge = 0.0,
    this.radiologyCharge = 0.0,
    this.nursingCharge = 0.0,
    this.oxygenCharge = 0.0,
    this.otherCharge = 0.0,
    this.discount = 0.0,
    this.vat = 0.0,
    this.subtotal = 0.0,
    this.grandTotal = 0.0,
    this.paidAmount = 0.0,
    this.dueAmount = 0.0,
    this.paymentStatus = 'UNPAID',
    this.paymentMethod,
    this.paidById,
    this.paidByName,
    this.paymentDate,
    this.billStatus = 'DRAFT',
    this.billDate,
    this.createdById,
    this.createdByName,
  });

  factory InpatientBill.fromJson(Map<String, dynamic> json) {
    return InpatientBill(
      id: json['id'] as int?,
      admissionId: (json['admissionId'] ?? 0) as int,
      patientId: (json['patientId'] ?? 0) as int,
      patientName: json['patientName'] as String? ?? '',
      doctorId: json['doctorId'] as int?,
      doctorName: json['doctorName'] as String?,
      seatNo: json['seatNo'] as String?,
      seatType: json['seatType'] as String?,
      totalDays: json['totalDays'] as int?,
      bedCharge: _toDouble(json['bedCharge']),
      doctorCharge: _toDouble(json['doctorCharge']),
      operationCharge: _toDouble(json['operationCharge']),
      medicineCharge: _toDouble(json['medicineCharge']),
      pathologyCharge: _toDouble(json['pathologyCharge']),
      radiologyCharge: _toDouble(json['radiologyCharge']),
      nursingCharge: _toDouble(json['nursingCharge']),
      oxygenCharge: _toDouble(json['oxygenCharge']),
      otherCharge: _toDouble(json['otherCharge']),
      discount: _toDouble(json['discount']),
      vat: _toDouble(json['vat']),
      subtotal: _toDouble(json['subtotal']),
      grandTotal: _toDouble(json['grandTotal']),
      paidAmount: _toDouble(json['paidAmount']),
      dueAmount: _toDouble(json['dueAmount']),
      paymentStatus: json['paymentStatus'] as String? ?? 'UNPAID',
      paymentMethod: json['paymentMethod'] as String?,
      paidById: json['paidById'] as int?,
      paidByName: json['paidByName'] as String?,
      paymentDate: json['paymentDate'] != null
          ? DateTime.tryParse(json['paymentDate'] as String)
          : null,
      billStatus: json['billStatus'] as String? ?? 'DRAFT',
      billDate: json['billDate'] != null
          ? DateTime.tryParse(json['billDate'] as String)
          : null,
      createdById: json['createdById'] as int?,
      createdByName: json['createdByName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admissionId': admissionId,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'seatNo': seatNo,
      'seatType': seatType,
      'totalDays': totalDays,
      'bedCharge': bedCharge,
      'doctorCharge': doctorCharge,
      'operationCharge': operationCharge,
      'medicineCharge': medicineCharge,
      'pathologyCharge': pathologyCharge,
      'radiologyCharge': radiologyCharge,
      'nursingCharge': nursingCharge,
      'oxygenCharge': oxygenCharge,
      'otherCharge': otherCharge,
      'discount': discount,
      'vat': vat,
      'subtotal': subtotal,
      'grandTotal': grandTotal,
      'paidAmount': paidAmount,
      'dueAmount': dueAmount,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'paidById': paidById,
      'paidByName': paidByName,
      'paymentDate': paymentDate?.toIso8601String(),
      'billStatus': billStatus,
      'billDate': billDate?.toIso8601String(),
      'createdById': createdById,
      'createdByName': createdByName,
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0.0;
  }
}