import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/appointment_schedule_model.dart';
import '../../viewModel/dashboard/appointment_schedule_viewmodel.dart';

class AppointmentScheduleScreen extends StatelessWidget {
  final String userRole;
  final String? nationalId;

  const AppointmentScheduleScreen({
    super.key,
    required this.userRole,
    this.nationalId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AppointmentScheduleViewModel()
            ..init(role: userRole, nationalId: nationalId),
      child: _AppointmentScheduleView(nationalId: nationalId),
    );
  }
}

class _AppointmentScheduleView extends StatefulWidget {
  final String? nationalId;

  const _AppointmentScheduleView({this.nationalId});

  @override
  State<_AppointmentScheduleView> createState() =>
      _AppointmentScheduleViewState();
}

class _AppointmentScheduleViewState extends State<_AppointmentScheduleView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppointmentScheduleViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text("Appointment Schedule")),
      body: RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: Column(
          children: [
            _buildSearchBar(viewModel),
            Expanded(child: _buildBody(context, viewModel)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAdd(context, viewModel),
        tooltip: "Add Appointment",
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSearchBar(AppointmentScheduleViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: TextField(
        controller: _searchController,
        onChanged: viewModel.search,
        decoration: InputDecoration(
          hintText: "Search by day, date or time...",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    viewModel.search("");
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppointmentScheduleViewModel viewModel,
  ) {
    switch (viewModel.state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 8),
                Text(viewModel.errorMessage, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: viewModel.fetchAppointments,
                  child: const Text("Retry"),
                ),
              ],
            ),
          ),
        );
      case ViewState.success:
        if (viewModel.appointments.isEmpty) {
          return const Center(child: Text("No appointments found."));
        }
        return ListView.builder(
          itemCount: viewModel.appointments.length,
          itemBuilder: (context, index) {
            final AppointmentSchedule appt = viewModel.appointments[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.event_note),
                title: Text(
                  "${appt.day} - ${appt.formattedDate}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Time: ${appt.startTime} - ${appt.endTime}"),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: "Edit",
                      onPressed: () => _onEdit(context, viewModel, appt),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: "Delete",
                      onPressed: () => _onDelete(context, viewModel, appt),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      case ViewState.idle:
        return const SizedBox.shrink();
    }
  }

  void _onEdit(
    BuildContext context,
    AppointmentScheduleViewModel viewModel,
    AppointmentSchedule appt,
  ) {
    viewModel.clearUpdateError();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _EditAppointmentDialog(appointment: appt, viewModel: viewModel);
      },
    );
  }

  void _onAdd(BuildContext context, AppointmentScheduleViewModel viewModel) {
    viewModel.clearCreateError();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _CreateAppointmentDialog(
          nationalId: widget.nationalId ?? "",
          viewModel: viewModel,
        );
      },
    );
  }

  void _onDelete(
    BuildContext context,
    AppointmentScheduleViewModel viewModel,
    AppointmentSchedule appt,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete Appointment"),
          content: Text("Are you sure you want to delete the appointment!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                viewModel.deleteAppointment(appt);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class _EditAppointmentDialog extends StatefulWidget {
  final AppointmentSchedule appointment;
  final AppointmentScheduleViewModel viewModel;

  const _EditAppointmentDialog({
    required this.appointment,
    required this.viewModel,
  });

  @override
  State<_EditAppointmentDialog> createState() => _EditAppointmentDialogState();
}

class _EditAppointmentDialogState extends State<_EditAppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _nationalId;
  late TextEditingController _dayController;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  @override
  void initState() {
    super.initState();
    final appt = widget.appointment;
    _nationalId = appt.nationalId.toString() ?? "";
    _dayController = TextEditingController(text: appt.day.toString() ?? "");
    _dateController = TextEditingController(
      text: appt.formattedDate.toString() ?? "",
    );
    _startTimeController = TextEditingController(
      text: appt.startTime.toString() ?? "",
    );
    _endTimeController = TextEditingController(
      text: appt.endTime.toString() ?? "",
    );
  }

  @override
  void dispose() {
    _dayController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime today = DateTime.now();
    final DateTime firstAllowedDate = DateTime(
      today.year,
      today.month,
      today.day,
    );
    DateTime initial;
    try {
      initial = DateTime.parse(_dateController.text);
    } catch (_) {
      initial = firstAllowedDate;
    }
    if (initial.isBefore(firstAllowedDate)) {
      initial = firstAllowedDate;
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstAllowedDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        _dayController.text = _weekdayName(picked.weekday);
      });
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    TimeOfDay initial = TimeOfDay.now();
    final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(controller.text);
    if (match != null) {
      initial = TimeOfDay(
        hour: int.parse(match.group(1)!),
        minute: int.parse(match.group(2)!),
      );
    }
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    final bool success = await widget.viewModel.updateAppointment(
      original: widget.appointment,
      nationalId: _nationalId,
      day: _dayController.text.trim(),
      date: _dateController.text.trim(),
      startTime: _startTimeController.text.trim(),
      endTime: _endTimeController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment updated successfully.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final bool isUpdating = widget.viewModel.isUpdating;
        final String updateError = widget.viewModel.updateErrorMessage;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.event_note, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "Edit Appointment",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: isUpdating
                                ? null
                                : () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _ReadOnlyIdBox(label: "Doctor Id", value: _nationalId),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: isUpdating ? null : _pickDate,
                        decoration: const InputDecoration(
                          labelText: "Date (YYYY-MM-DD)",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? "Date is required"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _dayController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Day",
                          border: OutlineInputBorder(),
                          helperText: "Auto-filled from selected date",
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _startTimeController,
                              readOnly: true,
                              onTap: isUpdating
                                  ? null
                                  : () => _pickTime(_startTimeController),
                              decoration: const InputDecoration(
                                labelText: "Start Time",
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.access_time),
                              ),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                  ? "Required"
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _endTimeController,
                              readOnly: true,
                              onTap: isUpdating
                                  ? null
                                  : () => _pickTime(_endTimeController),
                              decoration: const InputDecoration(
                                labelText: "End Time",
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.access_time),
                              ),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                  ? "Required"
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      if (updateError.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          updateError,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isUpdating
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: isUpdating ? null : _onSave,
                            child: isUpdating
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Update"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CreateAppointmentDialog extends StatefulWidget {
  final String nationalId;
  final AppointmentScheduleViewModel viewModel;

  const _CreateAppointmentDialog({
    required this.nationalId,
    required this.viewModel,
  });

  @override
  State<_CreateAppointmentDialog> createState() =>
      _CreateAppointmentDialogState();
}

class _CreateAppointmentDialogState extends State<_CreateAppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dayController;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  @override
  void initState() {
    super.initState();
    _dayController = TextEditingController();
    _dateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _dayController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime today = DateTime.now();
    final DateTime firstAllowedDate = DateTime(
      today.year,
      today.month,
      today.day,
    );
    DateTime initial;
    try {
      initial = DateTime.parse(_dateController.text);
    } catch (_) {
      initial = firstAllowedDate;
    }
    if (initial.isBefore(firstAllowedDate)) {
      initial = firstAllowedDate;
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstAllowedDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        _dayController.text = _weekdayName(picked.weekday);
      });
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    TimeOfDay initial = TimeOfDay.now();
    final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(controller.text);
    if (match != null) {
      initial = TimeOfDay(
        hour: int.parse(match.group(1)!),
        minute: int.parse(match.group(2)!),
      );
    }
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _onCreate() async {
    if (!_formKey.currentState!.validate()) return;
    final bool success = await widget.viewModel.createAppointment(
      nationalId: widget.nationalId,
      day: _dayController.text.trim(),
      date: _dateController.text.trim(),
      startTime: _startTimeController.text.trim(),
      endTime: _endTimeController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment created successfully.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final bool isCreating = widget.viewModel.isCreating;
        final String createError = widget.viewModel.createErrorMessage;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.event_available,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "Add Appointment",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: isCreating
                                ? null
                                : () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _ReadOnlyIdBox(
                        label: "Doctor Id",
                        value: widget.nationalId,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: isCreating ? null : _pickDate,
                        decoration: const InputDecoration(
                          labelText: "Date (YYYY-MM-DD)",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? "Date is required"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _dayController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Day",
                          border: OutlineInputBorder(),
                          helperText: "Auto-filled from selected date",
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _startTimeController,
                              readOnly: true,
                              onTap: isCreating
                                  ? null
                                  : () => _pickTime(_startTimeController),
                              decoration: const InputDecoration(
                                labelText: "Start Time",
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.access_time),
                              ),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                  ? "Required"
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _endTimeController,
                              readOnly: true,
                              onTap: isCreating
                                  ? null
                                  : () => _pickTime(_endTimeController),
                              decoration: const InputDecoration(
                                labelText: "End Time",
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.access_time),
                              ),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                  ? "Required"
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      if (createError.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          createError,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isCreating
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: isCreating ? null : _onCreate,
                            child: isCreating
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Create"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReadOnlyIdBox extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyIdBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.badge_outlined, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

String _weekdayName(int weekday) {
  const names = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  return names[weekday - 1];
}
