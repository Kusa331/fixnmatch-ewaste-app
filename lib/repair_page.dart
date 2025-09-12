import 'package:flutter/material.dart';
import 'main_scaffold.dart'; // ✅ Shared scaffold

class RepairPage extends StatefulWidget {
  const RepairPage({Key? key}) : super(key: key);

  @override
  _RepairPageState createState() => _RepairPageState();
}

class _RepairPageState extends State<RepairPage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController otherIssueController = TextEditingController();
  final TextEditingController customBrandController = TextEditingController();

  final List<String> phoneBrands = ['Apple', 'Samsung', 'Google', 'OnePlus'];
  final List<String> repairTypes = [
    'Screen Damage',
    'Battery Issue',
    'Software Problem',
    'Other Concern',
  ];

  String? selectedPhoneBrand;
  String? selectedRepairType;
  String requestType = 'Repair'; // default

  final Color darkGreen = const Color(0xFF0F6B32);
  final Color lightGreen = const Color(0xFF68B092);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      title: "Repair",
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 🔹 Request Type Toggle
            buildCard(
              title: "Request Type",
              child: Wrap(
                spacing: 8,
                children: ['Repair', 'Dispose'].map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: requestType == type,
                    selectedColor: lightGreen.withOpacity(0.5),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          requestType = type;
                        });
                      }
                    },
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: requestType == type ? darkGreen : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Phone Details + Issue Card
            buildCard(
              title: "Phone Details",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phone Brand Section
                  Text(
                    "What’s the brand of your phone?",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: phoneBrands.map((brand) {
                      return ChoiceChip(
                        label: Text(brand),
                        selected: selectedPhoneBrand == brand,
                        selectedColor: lightGreen.withOpacity(0.5),
                        onSelected: (selected) {
                          setState(() {
                            selectedPhoneBrand = selected ? brand : null;
                            if (selected) customBrandController.clear();
                          });
                        },
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: selectedPhoneBrand == brand ? darkGreen : Colors.black87,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: customBrandController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          selectedPhoneBrand = null;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Other brand (please specify)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.edit, color: darkGreen),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Repair Issue Section
                  Text(
                    "What type of issue are you facing?",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: repairTypes.map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: selectedRepairType == type,
                        selectedColor: lightGreen.withOpacity(0.5),
                        onSelected: (selected) {
                          setState(() {
                            selectedRepairType = selected ? type : null;
                            if (selected && type != 'Other Concern') {
                              otherIssueController.clear();
                            }
                          });
                        },
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: selectedRepairType == type ? darkGreen : Colors.black87,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  if (selectedRepairType == 'Other Concern')
                    TextField(
                      controller: otherIssueController,
                      decoration: InputDecoration(
                        hintText: "Please specify your issue",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.report_problem, color: darkGreen),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Location Card
            buildCard(
              title: "Where are you located?",
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: 'Enter your city or zip code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.location_on, color: darkGreen),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 🔹 Call to Action Button
            ElevatedButton.icon(
              onPressed: _showSummary,
              icon: const Icon(Icons.search),
              label: const Text("Find Eco-Friendly Repair Shops"),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Reusable Card Builder
  Widget buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  // 🔹 Show Summary Dialog
  void _showSummary() {
    final brand = customBrandController.text.isNotEmpty
        ? customBrandController.text
        : selectedPhoneBrand ?? 'Not specified';
    final issue = selectedRepairType == 'Other Concern'
        ? (otherIssueController.text.isNotEmpty
            ? otherIssueController.text
            : 'Other (unspecified)')
        : selectedRepairType ?? 'Not specified';
    final location =
        locationController.text.isEmpty ? 'Not provided' : locationController.text;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Your Repair Request"),
        content: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                summaryRow("Request Type", requestType),
                const Divider(),
                summaryRow("Phone Brand", brand),
                const Divider(),
                summaryRow("Issue", issue),
                const Divider(),
                summaryRow("Location", location),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Edit"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Finding eco-friendly repair shops...")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text("Search"),
          ),
        ],
      ),
    );
  }

  // 🔹 Row for Summary
  Widget summaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: darkGreen),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(value, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}
