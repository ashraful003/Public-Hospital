class BillModel {
  final int id;
  final int prescriptionId;
  final String doctorName;
  final String patientId;
  final String patientName;
  final String patientAge;
  final String patientWeight;
  final String selectedTests;
  final double totalBill;
  final double discountAmount;
  final double totalPay;
  final double refundAmount;
  final double totalDue;
  final String accountantName;
  final String accountantId;
  final String status;
  final String testStatus;
  final DateTime? paymentDateTime;
  final DateTime? createdDate;

  BillModel({
    required this.id,
    required this.prescriptionId,
    required this.doctorName,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientWeight,
    required this.selectedTests,
    required this.totalBill,
    required this.discountAmount,
    required this.totalPay,
    required this.refundAmount,
    required this.totalDue,
    required this.accountantName,
    required this.accountantId,
    required this.status,
    required this.testStatus,
    this.paymentDateTime,
    this.createdDate,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] ?? 0,
      prescriptionId: json['prescriptionId'] ?? 0,
      doctorName: json['doctorName'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      patientAge: json['patientAge'] ?? '',
      patientWeight: json['patientWeight'] ?? '',
      selectedTests: json['selectedTests'] ?? '',
      totalBill: (json['totalBill'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      totalPay: (json['totalPay'] ?? 0).toDouble(),
      refundAmount: (json['refundAmount'] ?? 0).toDouble(),
      totalDue: (json['totalDue'] ?? 0).toDouble(),
      accountantName: json['accountantName'] ?? '',
      accountantId: json['accountantId'] ?? '',
      status: json['status'] ?? '',
      testStatus: json['testStatus'] ?? '',
      paymentDateTime: json['paymentDateTime'] != null
          ? DateTime.parse(json['paymentDateTime'])
          : null,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
    );
  }
}