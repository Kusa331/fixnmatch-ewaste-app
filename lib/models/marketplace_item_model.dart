// marketplace_item_model.dart
class MarketplaceItemModel {
  final String id;
  final String title;
  final double price;
  final String description;
  final String sellerId;
  final String sellerName;
  final String location;
  final String imageUrl;
  final String category;
  final String condition;
  final DateTime createdAt;

  MarketplaceItemModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.sellerId,
    required this.sellerName,
    required this.location,
    required this.imageUrl,
    required this.category,
    required this.condition,
    required this.createdAt,
  });

  factory MarketplaceItemModel.fromJson(Map<String, dynamic> json) {
    return MarketplaceItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      condition: json['condition'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'location': location,
      'imageUrl': imageUrl,
      'category': category,
      'condition': condition,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
