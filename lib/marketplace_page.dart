import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_scaffold.dart'; // ✅ Shared scaffold
import 'chat_screen.dart';
import 'models/marketplace_item_model.dart';
import 'providers/app_provider.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final TextEditingController searchController = TextEditingController();
  final List<String> categories = ['Phones', 'Laptops', 'Accessories', 'Tablets', 'Chargers', 'Keyboards'];
  String? selectedCategory;

  final Color darkGreen = const Color(0xFF0F6B32);
  final Color lightGreen = const Color(0xFF68B092);
  
  @override
  void initState() {
    super.initState();
    // Fetch marketplace items when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).fetchMarketplaceItems();
    });
  }
  
  // Sample marketplace items for fallback
  final List<MarketplaceItemModel> sampleItems = [
    MarketplaceItemModel(
      id: '1',
      createdAt: DateTime.now(),
      sellerId: 'user1',
      title: 'iPhone 12 Pro',
      price: 450,
      description: 'Good condition, battery health 85%, includes charger',
      sellerName: 'John Doe',
      location: 'Downtown',
      imageUrl: 'https://images.unsplash.com/photo-1603891128711-11b4b03bb138',
      category: 'Phones',
      condition: 'Used - Good',
    ),
    MarketplaceItemModel(
      id: '2',
      createdAt: DateTime.now(),
      sellerId: 'user2',
      title: 'MacBook Pro 2019',
      price: 850,
      description: 'Excellent condition, 16GB RAM, 512GB SSD',
      sellerName: 'Jane Smith',
      location: 'Westside',
      imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca4',
      category: 'Laptops',
      condition: 'Used - Excellent',
    ),
    MarketplaceItemModel(
      id: '3',
      createdAt: DateTime.now(),
      sellerId: 'user3',
      title: 'Wireless Keyboard',
      price: 35,
      description: 'Mechanical keyboard, RGB lighting, like new',
      sellerName: 'Mike Johnson',
      location: 'Eastside',
      imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3',
      category: 'Keyboards',
      condition: 'Used - Like New',
    ),
    MarketplaceItemModel(
      id: '4',
      createdAt: DateTime.now(),
      sellerId: 'user4',
      title: 'USB-C Charger',
      price: 15,
      description: '65W fast charging, works with all USB-C devices',
      sellerName: 'Sarah Williams',
      location: 'Northside',
      imageUrl: 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0',
      category: 'Chargers',
      condition: 'Used - Good',
    ),
  ];

  // Filter items based on search and category
  List<MarketplaceItemModel> filteredItems() {
    final appProvider = Provider.of<AppProvider>(context);
    
    // Use items from provider or fallback to sample items
    List<MarketplaceItemModel> items = appProvider.marketplaceItems.isNotEmpty 
        ? appProvider.marketplaceItems 
        : sampleItems;
        
    if (searchController.text.isEmpty && selectedCategory == null) {
      return items;
    }
    
    return items.where((item) {
      bool matchesSearch = searchController.text.isEmpty || 
          item.title.toLowerCase().contains(searchController.text.toLowerCase()) ||
          item.description.toLowerCase().contains(searchController.text.toLowerCase());
          
      bool matchesCategory = selectedCategory == null || item.category == selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }
  
  // Build marketplace item card
  Widget _buildMarketplaceItem(MarketplaceItemModel item) {
    return GestureDetector(
      onTap: () {
        _showItemDetails(context, item);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                item.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            
            // Item details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "\$${item.price.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: darkGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            item.location,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        item.condition,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showItemDetails(context, item);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("View Details"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                sellerName: item.sellerName,
                                itemName: item.title,
                                itemImage: item.imageUrl,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightGreen,
                          foregroundColor: Colors.white,
                        ),
                        child: const Icon(Icons.chat),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Show item details dialog
  void _showItemDetails(BuildContext context, MarketplaceItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${item.price.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: darkGreen,
                    ),
                  ),
                  Text(
                    item.condition,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Description",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    "Seller: ${item.sellerName}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    "Location: ${item.location}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              sellerName: item.sellerName,
                              itemName: item.title,
                              itemImage: item.imageUrl,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Chat with Seller",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  
  // Show sell item dialog
  void _showSellItemDialog(BuildContext context) {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedItemCategory;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Sell Your Item",
            style: TextStyle(color: darkGreen),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Item Title",
                    hintText: "e.g., iPhone 12 Pro",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: "Price (\$)",
                    hintText: "e.g., 450",
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    hintText: "Describe your item's condition, features, etc.",
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                const Text("Category:"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: categories.map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected: selectedItemCategory == category,
                      selectedColor: lightGreen.withOpacity(0.5),
                      onSelected: (selected) {
                        setState(() {
                          selectedItemCategory = selected ? category : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add photo functionality
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text("Add Photos"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate and submit
                if (titleController.text.isNotEmpty && 
                    priceController.text.isNotEmpty && 
                    descriptionController.text.isNotEmpty &&
                    selectedItemCategory != null) {
                  
                  // Show success message
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Your item has been listed successfully!"),
                      backgroundColor: darkGreen,
                    ),
                  );
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill in all fields"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text("List Item"),
            ),
          ],
        );
      },
    );
  }

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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search for items...',
                      prefixIcon: Icon(Icons.search, color: darkGreen),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) {
                      final isSelected = selectedCategory == category;
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: darkGreen,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = selected ? category : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Floating Action Button to Sell
            ElevatedButton.icon(
              onPressed: () => _showSellItemDialog(context),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text("Sell Your Item"),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),
            
            // Marketplace Items
            ...filteredItems().map((item) => _buildMarketplaceItem(item)).toList(),

            if (filteredItems().isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text("No items found.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

}
