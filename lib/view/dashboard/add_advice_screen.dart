import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/add_advice_view_model.dart';

class AddAdviceScreen extends StatefulWidget {
  const AddAdviceScreen({
    super.key,
    required String role,
    required String nationalId,
  });

  @override
  State<AddAdviceScreen> createState() => _AddAdviceScreenState();
}

class _AddAdviceScreenState extends State<AddAdviceScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController adviceController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    adviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddAdviceViewModel()..loadCurrentUser(),
      child: Consumer<AddAdviceViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Add Advice")),
            body: vm.isLoading && vm.nationalId.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Text(
                            "ID : ${vm.nationalId}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: titleController,
                          onChanged: vm.updateTitle,
                          decoration: InputDecoration(
                            labelText: "Title",
                            hintText: "Enter advice title",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: adviceController,
                          onChanged: vm.updateAdvice,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: "Advice",
                            hintText: "Write advice here",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: vm.isButtonEnable && !vm.isLoading
                                ? () async {
                                    final success = await vm.addAdvice();
                                    if (!context.mounted) {
                                      return;
                                    }
                                    if (success) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Advice added successfully",
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context, true);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Failed to add advice"),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: vm.isButtonEnable
                                  ? AppColors.blue_200
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: vm.isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Save Advice",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
