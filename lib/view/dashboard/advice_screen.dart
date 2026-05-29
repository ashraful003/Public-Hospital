import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/advice_view_model.dart';
import 'add_advice_screen.dart';
import 'advice_details_screen.dart';

class AdviceScreen extends StatefulWidget {
  final String role;
  final String nationalId;

  const AdviceScreen({super.key, required this.role, required this.nationalId});

  @override
  State<AdviceScreen> createState() => _AdviceScreenState();
}

class _AdviceScreenState extends State<AdviceScreen> {
  late AdviceViewModel vm;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    vm = AdviceViewModel();
    vm.loadAdvice(widget.nationalId);
  }

  Future<void> _goToAddAdvice() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AddAdviceScreen(role: widget.role, nationalId: widget.nationalId),
      ),
    );
    if (result == true) {
      await vm.loadAdvice(widget.nationalId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<AdviceViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Advice")),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: vm.searchAdvice,
                    decoration: InputDecoration(
                      hintText: "Search advice by title...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.filteredList.isEmpty
                      ? const Center(child: Text("No advice found"))
                      : RefreshIndicator(
                          onRefresh: () async {
                            await vm.loadAdvice(widget.nationalId);
                          },
                          child: ListView.builder(
                            itemCount: vm.filteredList.length,
                            itemBuilder: (context, index) {
                              final advice = vm.filteredList[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AdviceDetailsScreen(
                                        role: widget.role,
                                        nationalId: widget.nationalId,
                                        adviceId: advice.id ?? "",
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          advice.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
            floatingActionButton: widget.role.toUpperCase() == "DOCTOR"
                ? FloatingActionButton(
                    onPressed: _goToAddAdvice,
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        },
      ),
    );
  }
}
