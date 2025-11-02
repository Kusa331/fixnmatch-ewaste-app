// user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String profileImageUrl;
  final List<String> savedItems;
  final List<String> listedItems;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl = '',
    this.savedItems = const [],
    this.listedItems = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      savedItems: List<String>.from(json['savedItems'] ?? []),
      listedItems: List<String>.from(json['listedItems'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'savedItems': savedItems,
      'listedItems': listedItems,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    List<String>? savedItems,
    List<String>? listedItems,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      savedItems: savedItems ?? this.savedItems,
      listedItems: listedItems ?? this.listedItems,
    );
  }
}