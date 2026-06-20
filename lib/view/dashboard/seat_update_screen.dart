import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../service/seat_service.dart';
import '../../viewModel/dashboard/seat_update_view_model.dart';

class SeatUpdateScreen extends StatefulWidget {
  final int seatId;

  const SeatUpdateScreen({super.key, required this.seatId});

  @override
  State<SeatUpdateScreen> createState() => _SeatUpdateScreenState();
}

class _SeatUpdateScreenState extends State<SeatUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _seatNoController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedType;
  String? _selectedCurrency;
  bool _status = true;
  bool _initialized = false;

  @override
  void dispose() {
    _seatNoController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _bindData(SeatUpdateViewModel vm) {
    if (_initialized || vm.seat == null) return;
    final seat = vm.seat!;
    _seatNoController.text = seat.seatNo;
    _priceController.text = seat.price.toString();
    final type = seat.type.toUpperCase();
    final currency = seat.currency.toUpperCase();
    _selectedType = SeatUpdateViewModel.seatTypes.contains(type) ? type : null;
    _selectedCurrency = SeatUpdateViewModel.currencies.contains(currency)
        ? currency
        : null;
    _status = seat.status;
    _initialized = true;
  }

  Future<void> _submit(BuildContext context) async {
    final vm = context.read<SeatUpdateViewModel>();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final price = double.tryParse(_priceController.text.trim());
    if (price == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid price value")));
      return;
    }
    final success = await vm.updateSeat(
      id: widget.seatId,
      type: _selectedType ?? '',
      seatNo: _seatNoController.text.trim(),
      price: price,
      currency: _selectedCurrency ?? '',
      status: _status,
    );
    if (!mounted) return;
    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to update seat")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          SeatUpdateViewModel(seatService: SeatService())
            ..loadSeatById(widget.seatId),
      child: Scaffold(
        appBar: AppBar(title: const Text("Update Seat"), centerTitle: true),
        body: Consumer<SeatUpdateViewModel>(
          builder: (context, vm, _) {
            _bindData(vm);
            if (vm.isLoading && vm.seat == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.hasError) {
              return Center(
                child: Text(
                  vm.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _seatNoController,
                              decoration: const InputDecoration(
                                labelText: "Seat No",
                                prefixIcon: Icon(Icons.confirmation_number),
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? "Enter seat number"
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _selectedType,
                              items: SeatUpdateViewModel.seatTypes
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedType = val),
                              decoration: const InputDecoration(
                                labelText: "Seat Type",
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) =>
                                  v == null ? "Select seat type" : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Price",
                                prefixIcon: Icon(Icons.attach_money),
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? "Enter price"
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _selectedCurrency,
                              items: SeatUpdateViewModel.currencies
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedCurrency = val),
                              decoration: const InputDecoration(
                                labelText: "Currency",
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) =>
                                  v == null ? "Select currency" : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: vm.isLoading ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.blueGrey.shade200,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: vm.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Update Seat",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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