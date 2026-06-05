import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../service/api_config.dart';
import '../../service/report_service.dart';
import '../../viewModel/dashboard/report_update_view_model.dart';

class ReportUpdateScreen extends StatelessWidget {
  final int reportId;
  final int billId;

  const ReportUpdateScreen({
    super.key,
    required this.reportId,
    required this.billId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportUpdateViewModel(
        service: ReportService(baseUrl: ApiConfig.baseUrl),
      )..loadReport(reportId),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportUpdateViewModel>();
    return Scaffold(
      appBar: AppBar(),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(color: Colors.blue.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            vm.report.centerName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vm.report.centerAddress,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _infoRow("Patient ID", vm.report.patientId),
                                const SizedBox(height: 5),
                                _infoRow("Patient Name", vm.report.patientName),
                                const SizedBox(height: 5),
                                _infoRow("Age", vm.report.patientAge),
                                const SizedBox(height: 5),
                                _infoRow("Weight", vm.report.patientWeight),
                                const SizedBox(height: 5),
                                _infoRow("Referred By", vm.report.doctorName),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [
                                _formRow(
                                  label: "Lab No",
                                  child: TextField(
                                    controller: vm.labNoController,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _dateField(
                                  context: context,
                                  label: "Sample Date",
                                  controller: vm.sampleDateController,
                                ),
                                const SizedBox(height: 10),
                                _dateField(
                                  context: context,
                                  label: "Review Date",
                                  controller: vm.reviewDateController,
                                ),
                                const SizedBox(height: 10),
                                _dateField(
                                  context: context,
                                  label: "Report Date",
                                  controller: vm.reportDateController,
                                ),
                                const SizedBox(height: 10),
                                _formRow(
                                  label: "Status",
                                  child: Container(
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.grey.shade100,
                                    ),
                                    child: Text(
                                      vm.status,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Selected Tests",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Expanded(flex: 3, child: Text("Test Name")),
                                Expanded(flex: 2, child: Text("Result")),
                                Expanded(flex: 2, child: Text("Unit")),
                                Expanded(flex: 2, child: Text("Reference")),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: vm.tests.length,
                            itemBuilder: (context, index) {
                              final test = vm.tests[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(test["testName"] ?? "-"),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          height: 38,
                                          width: 120,
                                          child: TextField(
                                            controller:
                                                vm.resultControllers[index],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              border: OutlineInputBorder(),
                                              hintText: "Enter",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(test["unit"] ?? "-"),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(test["range"] ?? "-"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: SizedBox(
                        width: 220,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            final success = await vm.updateReport();
                            if (success) {
                              if (context.mounted) {
                                Navigator.pop(context, true);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        const Text(
          ":",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value.trim().isNotEmpty ? value : "-",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _formRow({required String label, required Widget child}) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const Text(":"),
        const SizedBox(width: 10),
        Expanded(child: child),
      ],
    );
  }

  Widget _dateField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
  }) {
    return _formRow(
      label: label,
      child: TextField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
          hintText: "Select date & time",
          hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
        ),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    onSurface: Colors.black87,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (date == null) return;
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    onSurface: Colors.black87,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (time == null) return;
          final dateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          final String formattedDate =
              "${dateTime.day.toString().padLeft(2, '0')} "
              "${_monthName(dateTime.month)} "
              "${dateTime.year}  "
              "${_formatHour(dateTime.hour)}:"
              "${dateTime.minute.toString().padLeft(2, '0')} "
              "${dateTime.hour >= 12 ? 'PM' : 'AM'}";
          controller.text = formattedDate;
        },
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  String _formatHour(int hour) {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    return h.toString().padLeft(2, '0');
  }
}
