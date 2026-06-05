import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/reports_screen.dart';
import '../../viewModel/dashboard/search_report_view_model.dart';

class SearchReportScreen extends StatelessWidget {
  final String role;

  const SearchReportScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchReportViewModel(),
      child: Scaffold(
        appBar: AppBar(),
        body: Consumer<SearchReportViewModel>(
          builder: (context, vm, child) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: vm.searchController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Patient ID',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: vm.isNotFound ? Colors.red : Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: vm.isNotFound ? Colors.red : Colors.blue,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: vm.updateInput,
                  ),
                  if (vm.isNotFound)
                    const Padding(
                      padding: EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        "Report not found",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: vm.isLoading
                          ? null
                          : () async {
                              final patientId = await vm.searchReport(context);
                              if (patientId != null && context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReportsScreen(
                                      patientId: patientId,
                                      role: role,
                                    ),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: vm.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Search',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
