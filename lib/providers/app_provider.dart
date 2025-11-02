// app_provider.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/marketplace_item_model.dart';
import '../services/api_service.dart';

class AppProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  UserModel? _currentUser;
  List<MarketplaceItemModel> _marketplaceItems = [];
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  List<MarketplaceItemModel> get marketplaceItems => _marketplaceItems;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Authentication methods
  Future<bool> signIn(String email, String password) async {
    setLoading(true);
    final user = await _apiService.signIn(email, password);
    setLoading(false);
    
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signUp(String name, String email, String password) async {
    setLoading(true);
    final user = await _apiService.signUp(name, email, password);
    setLoading(false);
    
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    setLoading(true);
    await _apiService.signOut();
    _currentUser = null;
    setLoading(false);
    notifyListeners();
  }

  // Marketplace methods
  Future<void> fetchMarketplaceItems() async {
    setLoading(true);
    _marketplaceItems = await _apiService.getMarketplaceItems();
    setLoading(false);
    notifyListeners();
  }

  Future<bool> addMarketplaceItem(MarketplaceItemModel item) async {
    setLoading(true);
    final itemId = await _apiService.addMarketplaceItem(item);
    setLoading(false);
    
    if (itemId != null) {
      _marketplaceItems.add(item);
      notifyListeners();
      return true;
    }
    return false;
  }

  // User profile methods
  Future<bool> updateUserProfile(UserModel updatedUser) async {
    setLoading(true);
    final success = await _apiService.updateUserProfile(updatedUser);
    setLoading(false);
    
    if (success) {
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    }
    return false;
  }
}