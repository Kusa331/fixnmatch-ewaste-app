// value_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'main_scaffold.dart';

class ValuePage extends StatefulWidget {
  const ValuePage({super.key});

  @override
  State<ValuePage> createState() => _ValuePageState();
}

class _ValuePageState extends State<ValuePage> {
  final List<ItemCard> items = [];
  final List<ItemCard> savedItems = []; // ✅ List for saved items
  final picker = ImagePicker();

  String selectedCategory = 'All';
  String selectedCondition = 'All';
  RangeValues priceRange = const RangeValues(0, 10000);

  final List<String> categories = [
    'All',
    'Mobile Phones',
    'Laptops',
    'Appliances',
    'Small Electronics',
  ];

  final List<String> conditions = [
    'All',
    'Working',
    'Partially Working',
    'Broken',
  ];

  final Color darkGreen = const Color(0xFF0F6B32);
  final Color lightGreen = const Color(0xFF68B092);

  Future<void> pickImage(int index) async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        items[index].image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 3,
      title: "E-Waste Value Estimator",
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 🔹 Filter Card
            buildCard(
              title: "Filter Items",
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: categories
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(
                                    cat,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedCondition,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Condition',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: conditions
                              .map(
                                (cond) => DropdownMenuItem(
                                  value: cond,
                                  child: Text(
                                    cond,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCondition = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text("Price Range:"),
                      Expanded(
                        child: RangeSlider(
                          values: priceRange,
                          min: 0,
                          max: 10000,
                          divisions: 100,
                          labels: RangeLabels(
                            priceRange.start.round().toString(),
                            priceRange.end.round().toString(),
                          ),
                          onChanged: (values) {
                            setState(() {
                              priceRange = values;
                            });
                          },
                          activeColor: lightGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Add Item Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              onPressed: () {
                setState(() {
                  items.add(ItemCard());
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Item"),
            ),
            const SizedBox(height: 16),

            // 🔹 Items Input List
            ...items.asMap().entries.map((entry) {
              int index = entry.key;
              ItemCard item = entry.value;

              return buildCard(
                title: "Item ${index + 1}",
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => pickImage(index),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              image: item.image != null
                                  ? DecorationImage(
                                      image: FileImage(item.image!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: item.image == null
                                ? const Icon(Icons.camera_alt)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: item.name,
                                decoration: const InputDecoration(
                                  labelText: "Item Name",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    item.name = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: item.category,
                                      decoration: const InputDecoration(
                                        labelText: "Category",
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 15,
                                        ),
                                      ),
                                      items: categories
                                          .where((cat) => cat != 'All')
                                          .map(
                                            (cat) => DropdownMenuItem(
                                              value: cat,
                                              child: Text(
                                                cat,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          item.category = value!;
                                          // Recalculate price based on new category
                                          item.price = item
                                              .calculateMaterialValue();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: item.condition,
                                      decoration: const InputDecoration(
                                        labelText: "Condition",
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 15,
                                        ),
                                      ),
                                      items: conditions
                                          .where((cond) => cond != 'All')
                                          .map(
                                            (cond) => DropdownMenuItem(
                                              value: cond,
                                              child: Text(
                                                cond,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          item.condition = value!;
                                          // Recalculate price based on new condition
                                          item.price = item
                                              .calculateMaterialValue();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                initialValue: item.weight.toString(),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: const InputDecoration(
                                  labelText: "Weight (grams)",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    item.weight = double.tryParse(value) ?? 0.0;
                                    // Recalculate price based on new weight
                                    item.price = item.calculateMaterialValue();
                                  });
                                },
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                initialValue: item.price.toStringAsFixed(2),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: const InputDecoration(
                                  labelText: "Estimated Value (₱)",
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              items.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 🔹 Save Button moves item to savedItems
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            savedItems.add(item);
                            items.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.save),
                        label: const Text("Save"),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 16),
            // 🔹 Saved Items Section
            if (savedItems.isNotEmpty)
              buildCard(
                title: "Saved Items",
                child: Column(
                  children: savedItems.map((item) {
                    return ExpansionTile(
                      leading: item.image != null
                          ? Image.file(
                              item.image!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image_not_supported),
                      title: Text(
                        item.name.isNotEmpty ? item.name : "Unnamed Item",
                      ),
                      subtitle: Text(
                        "₱${item.price.toStringAsFixed(2)} - ${item.condition}",
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Item details
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Category:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(item.category),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Weight:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${item.weight.toStringAsFixed(1)} grams",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Material value breakdown
                              const Divider(),
                              Text(
                                "Material Value Breakdown:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                ),
                              ),
                              const SizedBox(height: 8),

                              ...item.materialValues.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(entry.key),
                                      Text(
                                        "₱${entry.value.toStringAsFixed(2)}",
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),

                              const Divider(),

                              // Environmental impact
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Eco-Impact Score:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: darkGreen,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.eco,
                                        color: item.ecoImpactScore > 70
                                            ? Colors.green
                                            : (item.ecoImpactScore > 40
                                                  ? Colors.amber
                                                  : Colors.red),
                                      ),
                                      const SizedBox(width: 4),
                                      Text("${item.ecoImpactScore}/100"),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Recommendation:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                ),
                              ),
                              Text(item.recyclingRecommendation),

                              const SizedBox(height: 16),
                              // Action buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      // Navigate to Smart Finder
                                      Navigator.pushNamed(
                                        context,
                                        '/smart_finder',
                                      );
                                    },
                                    icon: const Icon(Icons.location_on),
                                    label: const Text("Find Recycling Centers"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

            // Total value summary if there are saved items
            if (savedItems.isNotEmpty)
              buildCard(
                title: "Total Value Summary",
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Estimated Value:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "₱${savedItems.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: darkGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "By recycling these items, you're helping reduce e-waste and recovering valuable materials!",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 🔹 Reusable Card
  Widget buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black26,
      margin: const EdgeInsets.symmetric(vertical: 8),
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
}

class ItemCard {
  String name;
  double price;
  File? image;
  String category;
  String condition;
  double weight;
  Map<String, double> materialValues = {};
  int ecoImpactScore = 0;
  String recyclingRecommendation = '';

  ItemCard({
    this.name = '',
    this.price = 0.0,
    this.image,
    this.category = 'Mobile Phones',
    this.condition = 'Working',
    this.weight = 0.0,
  });

  // Calculate total material value based on device type, condition and weight
  double calculateMaterialValue() {
    double baseValue = 0.0;

    // Base value by category (in ₱ per gram)
    switch (category) {
      case 'Mobile Phones':
        baseValue = 15.0;
        break;
      case 'Laptops':
        baseValue = 12.0;
        break;
      case 'Appliances':
        baseValue = 5.0;
        break;
      case 'Small Electronics':
        baseValue = 8.0;
        break;
      default:
        baseValue = 5.0;
    }

    // Condition multiplier
    double conditionMultiplier = 1.0;
    switch (condition) {
      case 'Working':
        conditionMultiplier = 1.5;
        break;
      case 'Partially Working':
        conditionMultiplier = 1.0;
        break;
      case 'Broken':
        conditionMultiplier = 0.7;
        break;
    }

    // Calculate material values
    materialValues = {
      'Precious Metals': baseValue * weight * 0.05 * conditionMultiplier,
      'Copper': baseValue * weight * 0.15 * conditionMultiplier,
      'Plastics': baseValue * weight * 0.30 * conditionMultiplier,
      'Other Materials': baseValue * weight * 0.50 * conditionMultiplier,
    };

    // Calculate eco-impact score (0-100)
    ecoImpactScore = ((weight * baseValue / 100) * conditionMultiplier)
        .round()
        .clamp(0, 100);

    // Set recycling recommendation
    if (ecoImpactScore > 70) {
      recyclingRecommendation =
          'High value - Specialized recycling recommended';
    } else if (ecoImpactScore > 40) {
      recyclingRecommendation = 'Medium value - Standard e-waste recycling';
    } else {
      recyclingRecommendation = 'Low value - General recycling';
    }

    return materialValues.values.fold(0, (sum, value) => sum + value);
  }
}
