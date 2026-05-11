import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/medicine_update_screen.dart';

import '../../color/app_color.dart';
import '../../model/medicine_model.dart';
import '../../viewModel/dashboard/medicine_details_view_model.dart';

class MedicineDetailsScreen extends StatelessWidget {

  final MedicineModel medicine;

  const MedicineDetailsScreen({
    super.key,
    required this.medicine,
  });

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(

      create: (_) {

        final vm =
        MedicineDetailsViewModel();

        vm.loadRole();

        return vm;
      },

      child:
      Consumer<MedicineDetailsViewModel>(

        builder: (context, vm, _) {

          return Scaffold(

            appBar: AppBar(

              backgroundColor:
              AppColors.blue_200,

              title: const Text(

                "Medicine Details",

                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              centerTitle: true,

              iconTheme:
              const IconThemeData(
                color: Colors.white,
              ),
            ),

            body: SingleChildScrollView(

              padding:
              const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.center,

                children: [

                  /// AVATAR
                  CircleAvatar(

                    radius: 55,

                    backgroundColor:
                    Colors.blue.shade50,

                    child: Text(

                      medicine.medicineName
                          ?.isNotEmpty ==
                          true

                          ? medicine
                          .medicineName![0]
                          .toUpperCase()

                          : "M",

                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight:
                        FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// MEDICINE NAME
                  Text(

                    medicine.medicineName ??
                        "Unknown Medicine",

                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// POWER
                  Text(

                    medicine.power ?? "N/A",

                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ONLY PHARMACEUTICAL CAN EDIT
                  if (vm.canEditMedicine)

                    Align(

                      alignment:
                      Alignment.centerRight,

                      child: IconButton(

                        icon: const Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),

                        onPressed: () async {

                          final result =
                          await Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  MedicineUpdateScreen(
                                    medicine:
                                    medicine,
                                  ),
                            ),
                          );

                          if (result == true &&
                              context.mounted) {

                            Navigator.pop(
                              context,
                              true,
                            );
                          }
                        },
                      ),
                    ),

                  const SizedBox(height: 20),

                  /// DETAILS CARD
                  Card(

                    elevation: 4,

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                    ),

                    child: Padding(

                      padding:
                      const EdgeInsets.all(16),

                      child: Column(

                        children: [

                          buildDetailsRow(
                            icon: Icons.business,
                            title: "Pharmaceutical",
                            value:
                            medicine.name ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon: Icons.money,
                            title: "Unit Price",
                            value:
                            "${medicine.unitPrice ?? 0} Tk",
                          ),

                          buildDetailsRow(
                            icon: Icons.payments,
                            title: "Total Price",
                            value:
                            "${medicine.totalPrice ?? 0} Tk",
                          ),

                          buildDetailsRow(
                            icon:
                            Icons.medication,
                            title: "Indications",
                            value:
                            medicine.indications ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon: Icons.science,
                            title: "Pharmacology",
                            value:
                            medicine.pharmacology ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon:
                            Icons.access_time,
                            title: "Dosage",
                            value:
                            medicine.dosage ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon:
                            Icons.warning_amber,
                            title: "Interaction",
                            value:
                            medicine.interaction ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon: Icons.block,
                            title:
                            "Contraindications",
                            value: medicine
                                .contraindications ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon: Icons.sick,
                            title:
                            "Side Effects",
                            value:
                            medicine.sideEffects ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon:
                            Icons.pregnant_woman,
                            title:
                            "Pregnancy & Lactation",
                            value: medicine
                                .pregnancyLactation ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon:
                            Icons.health_and_safety,
                            title:
                            "Precautions",
                            value: medicine
                                .precautionsWarnings ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon: Icons.groups,
                            title:
                            "Special Populations",
                            value: medicine
                                .specialPopulations ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon:
                            Icons.warning,
                            title:
                            "Overdose Effects",
                            value: medicine
                                .overdoseEffects ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon:
                            Icons.water_drop,
                            title:
                            "Reconstitution",
                            value:
                            medicine.reconstitution ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon:
                            Icons.storage,
                            title:
                            "Storage Conditions",
                            value: medicine
                                .storageConditions ??
                                "N/A",
                          ),

                          buildDetailsRow(
                            icon:
                            Icons.biotech,
                            title:
                            "Chemical Structure",
                            value: medicine
                                .chemicalStructure ??
                                "N/A",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// ADMIN + PHARMACEUTICAL
                  /// CAN DELETE
                  if (vm.canDeleteMedicine)

                    SizedBox(

                      width: double.infinity,
                      height: 55,

                      child:
                      ElevatedButton.icon(

                        style:
                        ElevatedButton.styleFrom(

                          backgroundColor:
                          Colors.red,

                          shape:
                          RoundedRectangleBorder(

                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),

                        onPressed:
                        vm.isLoading

                            ? null

                            : () async {

                          showDialog(

                            context: context,

                            builder: (_) {

                              return AlertDialog(

                                title: const Text(
                                  "Delete Medicine",
                                ),

                                content:
                                const Text(
                                  "Are you sure you want to delete this medicine?",
                                ),

                                actions: [

                                  TextButton(

                                    onPressed: () {

                                      Navigator.pop(
                                        context,
                                      );
                                    },

                                    child:
                                    const Text(
                                      "Cancel",
                                    ),
                                  ),

                                  ElevatedButton(

                                    style:
                                    ElevatedButton.styleFrom(

                                      backgroundColor:
                                      Colors.red,
                                    ),

                                    onPressed:
                                        () async {

                                      Navigator.pop(
                                        context,
                                      );

                                      if (medicine
                                          .id !=
                                          null) {

                                        final success =
                                        await vm
                                            .deleteMedicine(

                                          context:
                                          context,

                                          id: medicine
                                              .id!,
                                        );

                                        if (success &&
                                            context
                                                .mounted) {

                                          Navigator.pop(
                                            context,
                                            true,
                                          );
                                        }
                                      }
                                    },

                                    child:
                                    const Text(
                                      "Delete",
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },

                        icon: vm.isLoading

                            ? const SizedBox(

                          height: 22,
                          width: 22,

                          child:
                          CircularProgressIndicator(

                            strokeWidth: 2,

                            color:
                            Colors.white,
                          ),
                        )

                            : const Icon(

                          Icons.delete,

                          color: Colors.white,
                        ),

                        label: Text(

                          vm.isLoading

                              ? "Deleting..."

                              : "Delete Medicine",

                          style:
                          const TextStyle(

                            color: Colors.white,

                            fontWeight:
                            FontWeight.bold,

                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildDetailsRow({

    required IconData icon,

    required String title,

    required String value,
  }) {

    return Padding(

      padding:
      const EdgeInsets.symmetric(
        vertical: 10,
      ),

      child: Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: AppColors.blue_200,
          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 3),

                Text(

                  value,

                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}