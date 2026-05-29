import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/activity_screen.dart';
import '../../viewModel/dashboard/search_doctor_activity_view_model.dart';

class SearchDoctorActivityScreen extends StatelessWidget {
  final String role;

  const SearchDoctorActivityScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchDoctorActivityViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Doctor Activity'),
          centerTitle: true,
        ),
        body: Consumer<SearchDoctorActivityViewModel>(
          builder: (context, vm, child) {
            final hasError = vm.isNotFound;
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: vm.searchController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Doctor ID',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: hasError ? Colors.red : Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: hasError ? Colors.red : Colors.blue,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: vm.updateInput,
                  ),
                  if (hasError)
                    const Padding(
                      padding: EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        "Doctor not found",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (vm.searchController.text.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: vm.isLoading
                            ? null
                            : () async {
                                final patientId = await vm.searchDoctor(
                                  context,
                                );
                                if (patientId != null && context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ActivityScreen(
                                        nationalId: patientId,
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
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Search',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
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
