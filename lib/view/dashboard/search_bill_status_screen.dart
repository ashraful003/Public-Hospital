import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/search_bill_status_view_model.dart';
import 'bill_status_screen.dart';

class SearchBillStatusScreen extends StatelessWidget {
  final String role;

  const SearchBillStatusScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchBillStatusViewModel(),
      child: Scaffold(
        appBar: AppBar(),
        body: Consumer<SearchBillStatusViewModel>(
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
                      labelText: 'Enter Patient ID',
                      prefixIcon: const Icon(Icons.receipt_long),
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
                        "Patient not found",
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
                              final patientId = await vm.searchBill(context);
                              if (patientId != null && context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BillStatusScreen(
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
