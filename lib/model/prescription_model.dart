class PrescriptionModel {
  final String id;
  final String patientId;
  final String date;
  final String patientName;
  final String pdfUrl;

  PrescriptionModel({
    required this.id,
    required this.patientId,
    required this.date,
    required this.patientName,
    required this.pdfUrl,
  });
}