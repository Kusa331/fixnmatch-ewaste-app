import 'package:flutter/material.dart';
import 'main_scaffold.dart'; // ✅ Shared scaffold

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final TextEditingController searchController = TextEditingController();
  final List<String> categories = ['Phones', 'Laptops', 'Accessories', 'Tablets'];
  String? selectedCategory;

  final Color darkGreen = const Color(0xFF0F6B32);
  final Color lightGreen = const Color(0xFF68B092);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2,
      title: "Marketplace",
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 🔹 Search Card
            sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for items',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF0F6B32)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: categories.map((category) {
                      return ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        selectedColor: lightGreen.withOpacity(0.5),
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = selected ? category : null;
                          });
                        },
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: selectedCategory == category ? darkGreen : Colors.black87,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Action Row: Sell & Categories
            Row(
              children: [
                Expanded(
                  child: sectionCard(
                    height: 80,
                    child: Center(
                      child: Text(
                        "Sell Your Item",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: sectionCard(
                    height: 80,
                    child: Center(
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 Marketplace Grid (Items)
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(6, (index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailPage(
                          itemName: "Item ${index + 1}",
                          itemDescription: "This is a detailed description of Item ${index + 1}.",
                          itemImage: Icons.shopping_bag,
                        ),
                      ),
                    );
                  },
                  child: sectionCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: darkGreen,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: const Icon(
                            Icons.shopping_bag,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Item ${index + 1}',
                          style: TextStyle(
                            color: darkGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 🔹 Card Layout
  Widget sectionCard({required Widget child, double? height}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.black26,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

// 🔹 Item Detail Page with chat
class ItemDetailPage extends StatefulWidget {
  final String itemName;
  final String itemDescription;
  final IconData itemImage;

  const ItemDetailPage({
    super.key,
    required this.itemName,
    required this.itemDescription,
    required this.itemImage,
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final List<String> messages = [
    "Hello, is this still available?",
    "Yes, it's available!",
  ];
  final TextEditingController messageController = TextEditingController();

  final Color darkGreen = const Color(0xFF0F6B32);

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(messageController.text.trim());
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreen,
        iconTheme: const IconThemeData(color: Colors.white), // back button white
        title: Text(
          widget.itemName,
          style: const TextStyle(color: Colors.white), // ✅ Title white
        ),
      ),
      body: Column(
        children: [
          // 🔹 Item Image
          Container(
            color: Colors.grey[200],
            height: 200,
            child: Center(
              child: Icon(widget.itemImage, size: 100, color: darkGreen),
            ),
          ),

          // 🔹 Description
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.itemDescription,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          const Divider(),

          // 🔹 Chat Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isMe = index % 2 == 0; // alternate sender
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? darkGreen : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      messages[index],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔹 Message Box
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Send a message to seller...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF0F6B32)),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
