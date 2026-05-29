import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/advice_model.dart';
import '../../viewModel/dashboard/update_advice_view_model.dart';

class UpdateAdviceScreen extends StatefulWidget {
  final AdviceModel advice;

  const UpdateAdviceScreen({super.key, required this.advice});

  @override
  State<UpdateAdviceScreen> createState() => _UpdateAdviceScreenState();
}

class _UpdateAdviceScreenState extends State<UpdateAdviceScreen> {
  late TextEditingController titleController;
  late TextEditingController adviceController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.advice.title);
    adviceController = TextEditingController(text: widget.advice.advice);
  }

  @override
  void dispose() {
    titleController.dispose();
    adviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UpdateAdviceViewModel()..loadAdvice(widget.advice),
      child: Consumer<UpdateAdviceViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Update Advice")),
            body: SingleChildScrollView(
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: adviceController,
                    onChanged: vm.updateAdvice,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: "Advice",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: vm.isButtonEnable && !vm.isLoading
                          ? () async {
                              final success = await vm.updateAdviceData(
                                widget.advice.id!,
                              );
                              if (!context.mounted) {
                                return;
                              }
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Advice updated successfully",
                                    ),
                                  ),
                                );
                                Navigator.pop(context, true);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to update advice"),
                                  ),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: vm.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Update Advice",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
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
