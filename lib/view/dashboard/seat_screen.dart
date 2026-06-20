import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/seat_create_screen.dart';
import 'package:public_hospital/view/dashboard/seat_update_screen.dart';
import '../../service/seat_service.dart';
import '../../viewModel/dashboard/seat_view_model.dart';

class SeatScreen extends StatelessWidget {
  final String role;
  final String patientId;

  const SeatScreen({super.key, required this.role, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SeatViewModel(seatService: SeatService()),
      child: _SeatScreenWrapper(role: role, patientId: patientId),
    );
  }
}

class _SeatScreenWrapper extends StatefulWidget {
  final String role;
  final String patientId;

  const _SeatScreenWrapper({required this.role, required this.patientId});

  @override
  State<_SeatScreenWrapper> createState() => _SeatScreenWrapperState();
}

class _SeatScreenWrapperState extends State<_SeatScreenWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SeatViewModel>().fetchAvailableSeats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AvailableSeatsView(role: widget.role, patientId: widget.patientId);
  }
}

class _AvailableSeatsView extends StatelessWidget {
  final String role;
  final String patientId;

  const _AvailableSeatsView({required this.role, required this.patientId});

  bool get isAdmin => role.toUpperCase() == 'ADMIN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A73E8),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF1A73E8),
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const SeatCreateScreen()),
                ).then((created) {
                  if (context.mounted && created == true) {
                    context.read<SeatViewModel>().fetchAvailableSeats();
                  }
                });
              },
            )
          : null,
      body: Column(
        children: [
          const _TypeFilterBar(),
          const _TableHeader(),
          Expanded(
            child: _SeatListBody(isAdmin: isAdmin, patientId: patientId),
          ),
        ],
      ),
    );
  }
}

class _TypeFilterBar extends StatelessWidget {
  const _TypeFilterBar();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SeatViewModel>();
    return Container(
      color: const Color(0xFF1A73E8),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: SeatViewModel.seatTypes.map((type) {
              final isSelected = vm.selectedType == type;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: vm.isLoading ? null : (_) => vm.changeType(type),
                  selectedColor: Colors.white,
                  backgroundColor: Colors.blue.shade300,
                  showCheckmark: true,
                  checkmarkColor: const Color(0xFF1A73E8),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFF1A73E8) : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A73E8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: const Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'No',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Seat No',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Price',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(right: 15),
              child: Text(
                'Action',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeatListBody extends StatelessWidget {
  final bool isAdmin;
  final String patientId;

  const _SeatListBody({required this.isAdmin, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SeatViewModel>();
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.hasError) {
      return Center(child: Text(vm.errorMessage));
    }
    if (vm.seats.isEmpty) {
      return const Center(child: Text('No seats found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(left: 2, right: 2, top: 3, bottom: 5),
      itemCount: vm.seats.length,
      itemBuilder: (_, index) {
        final seat = vm.seats[index];
        return InkWell(
          child: Container(
            height: 80,
            margin: const EdgeInsets.only(bottom: 1),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        seat.seatNo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${seat.currency} ${seat.price}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: isAdmin
                            ? IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          SeatUpdateScreen(seatId: seat.id),
                                    ),
                                  ).then((updated) {
                                    if (updated == true) {
                                      context
                                          .read<SeatViewModel>()
                                          .fetchAvailableSeats();
                                    }
                                  });
                                },
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}