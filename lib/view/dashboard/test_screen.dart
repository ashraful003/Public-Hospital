import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/model/test_model.dart';
import '../../viewModel/dashboard/test_view_model.dart';

class TestScreen extends StatelessWidget {
  final String role;

  const TestScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TestViewModel()
        ..setRole(role)
        ..loadTests(),
      child: Consumer<TestViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(),
            floatingActionButton: vm.canAdd
                ? FloatingActionButton(
                    onPressed: () => showAddTestDialog(context, vm),
                    child: const Icon(Icons.add),
                  )
                : null,
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          onChanged: vm.updateSearch,
                          decoration: InputDecoration(
                            hintText: "Search test name...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        color: Colors.blue.shade100,
                        child: const Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("No", textAlign: TextAlign.left),
                            ),
                            Expanded(flex: 3, child: Text("Test Name")),
                            Expanded(flex: 2, child: Text("Price")),
                            Expanded(flex: 2, child: Text("Unit")),
                            Expanded(flex: 3, child: Text("Range")),
                            Expanded(flex: 2, child: Text("Currency")),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Action",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: vm.testList.isEmpty
                            ? const Center(child: Text("No Test Found"))
                            : ListView.builder(
                                itemCount: vm.testList.length,
                                itemBuilder: (context, index) {
                                  final test = vm.testList[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.15),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${index + 1}",
                                            textAlign: TextAlign.left,
                                          ),
                                        ),

                                        Expanded(
                                          flex: 3,
                                          child: Text(test.testName),
                                        ),

                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            test.price.toStringAsFixed(2),
                                          ),
                                        ),

                                        Expanded(
                                          flex: 2,
                                          child: Text(test.unit),
                                        ),

                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            test.range,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                        Expanded(
                                          flex: 2,
                                          child: Text(test.currency),
                                        ),

                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (vm.canEdit)
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Colors.blue,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    showEditDialog(
                                                      context,
                                                      vm,
                                                      test,
                                                    );
                                                  },
                                                ),

                                              if (vm.canDelete)
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    _showDeleteDialog(
                                                      context,
                                                      vm,
                                                      test,
                                                    );
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  void showEditDialog(BuildContext context, TestViewModel vm, TestModel test) {
    final testNameController = TextEditingController(text: test.testName);
    final priceController = TextEditingController(text: test.price.toString());
    final currencyController = TextEditingController(text: test.currency);
    final unitController = TextEditingController(text: test.unit);
    final rangeController = TextEditingController(text: test.range);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Update Test"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(testNameController, "Test Name"),
              _field(priceController, "Price"),
              _field(currencyController, "Currency"),
              _field(unitController, "Unit"),
              _field(rangeController, "Range"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final body = {
                  "name": test.name,
                  "testName": testNameController.text.trim(),
                  "price": double.tryParse(priceController.text.trim()) ?? 0,
                  "currency": currencyController.text.trim(),
                  "unit": unitController.text.trim(),
                  "range": rangeController.text.trim(),
                };

                Navigator.pop(context);

                await vm.updateTest(test.id, body);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void showAddTestDialog(BuildContext context, TestViewModel vm) {
    final name = vm.currentUser?.name ?? "";
    final testName = TextEditingController();
    final price = TextEditingController();
    final currency = TextEditingController();
    final unit = TextEditingController();
    final range = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add Test"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(
                TextEditingController(text: name),
                "Center (Auto)",
                readOnly: true,
              ),
              _field(testName, "Test Name"),
              _field(price, "Price"),
              _field(currency, "Currency"),
              _field(unit, "Unit"),
              _field(range, "Range"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final body = {
                  "name": name,
                  "testName": testName.text,
                  "price": double.tryParse(price.text) ?? 0,
                  "currency": currency.text,
                  "unit": unit.text,
                  "range": range.text,
                };
                final ok = await vm.addTest(body);
                if (ok) Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    TestViewModel vm,
    TestModel test,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete"),
          content: Text("Delete ${test.testName}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await vm.deleteTest(test.id);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
