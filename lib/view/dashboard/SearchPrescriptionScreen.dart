import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/viewModel/dashboard/SearchPrescriptionViewModel.dart';

class SearchPrescriptionScreen extends StatelessWidget {
  const SearchPrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchPrescriptionViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Prescription'),
          centerTitle: true,
        ),
        body: Consumer<SearchPrescriptionViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
              child: Column(
                children: [
                  // Patient ID input
                  TextField(
                    controller: viewModel.searchController,
                    decoration: InputDecoration(
                      labelText: 'Enter Patient ID',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      viewModel.updateInput(value);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Show button only if input is not empty
                  if (viewModel.searchController.text.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () => viewModel.searchPrescription(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: viewModel.isLoading
                            ? const CircularProgressIndicator(
                            color: Colors.white)
                            : const Text('Search'),
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