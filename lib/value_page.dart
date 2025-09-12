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
    'Small Electronics'
  ];

  final List<String> conditions = [
    'All',
    'Working',
    'Partially Working',
    'Broken'
  ];

  final Color darkGreen = const Color(0xFF0F6B32);
  final Color lightGreen = const Color(0xFF68B092);

  Future<void> pickImage(int index) async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

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
                              .map((cat) => DropdownMenuItem(
                                    value: cat,
                                    child: Text(
                                      cat,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
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
                              .map((cond) => DropdownMenuItem(
                                    value: cond,
                                    child: Text(
                                      cond,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
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
                              TextFormField(
                                initialValue: item.price.toStringAsFixed(2),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: "Estimated Price (₱)",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    item.price = double.tryParse(value) ?? 0.0;
                                  });
                                },
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
                    return ListTile(
                      leading: item.image != null
                          ? Image.file(
                              item.image!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image_not_supported),
                      title: Text(item.name.isNotEmpty ? item.name : "Unnamed Item"),
                      subtitle: Text("₱${item.price.toStringAsFixed(2)}"),
                    );
                  }).toList(),
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

  ItemCard({this.name = '', this.price = 0.0, this.image});
}
