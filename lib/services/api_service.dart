// api_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/marketplace_item_model.dart';

class ApiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Authentication methods
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return getUserProfile(response.user!.id);
      }
      return null;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  Future<UserModel?> signUp(String name, String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user != null) {
        // Create user profile in Supabase
        final newUser = UserModel(
          id: response.user!.id,
          name: name,
          email: email,
        );

        await _supabase.from('users').insert(newUser.toJson());

        return newUser;
      }
      return null;
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // User profile methods
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        return UserModel.fromJson(Map<String, dynamic>.from(response));
      }
      return null;
    } catch (e) {
      print('Get user profile error: $e');
      return null;
    }
  }

  Future<bool> updateUserProfile(UserModel user) async {
    try {
      await _supabase.from('users').update(user.toJson()).eq('id', user.id);
      return true;
    } catch (e) {
      print('Update user profile error: $e');
      return false;
    }
  }

  // Marketplace methods
  Future<List<MarketplaceItemModel>> getMarketplaceItems() async {
    try {
      final response = await _supabase.from('marketplace_items').select();

      return (response as List)
          .map(
            (item) =>
                MarketplaceItemModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } catch (e) {
      print('Get marketplace items error: $e');
      return [];
    }
  }

  Future<MarketplaceItemModel?> getMarketplaceItem(String itemId) async {
    try {
      final response = await _supabase
          .from('marketplace_items')
          .select()
          .eq('id', itemId)
          .maybeSingle();

      if (response != null) {
        return MarketplaceItemModel.fromJson(
          Map<String, dynamic>.from(response),
        );
      }
      return null;
    } catch (e) {
      print('Get marketplace item error: $e');
      return null;
    }
  }

  Future<String?> addMarketplaceItem(MarketplaceItemModel item) async {
    try {
      final response = await _supabase
          .from('marketplace_items')
          .insert(item.toJson())
          .select()
          .maybeSingle();

      if (response != null) {
        final data = Map<String, dynamic>.from(response);
        return data['id'] as String?;
      }
      return null;
    } catch (e) {
      print('Add marketplace item error: $e');
      return null;
    }
  }

  Future<bool> updateMarketplaceItem(MarketplaceItemModel item) async {
    try {
      await _supabase
          .from('marketplace_items')
          .update(item.toJson())
          .eq('id', item.id);
      return true;
    } catch (e) {
      print('Update marketplace item error: $e');
      return false;
    }
  }

  Future<bool> deleteMarketplaceItem(String itemId) async {
    try {
      await _supabase.from('marketplace_items').delete().eq('id', itemId);
      return true;
    } catch (e) {
      print('Delete marketplace item error: $e');
      return false;
    }
  }

  // Chat methods
  Future<List<Map<String, dynamic>>> getChatMessages(String chatId) async {
    try {
      final response = await _supabase
          .from('messages')
          .select()
          .eq('chat_id', chatId)
          .order('timestamp');

      return (response as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (e) {
      print('Get chat messages error: $e');
      return [];
    }
  }

  Future<bool> sendChatMessage(
    String chatId,
    Map<String, dynamic> message,
  ) async {
    try {
      final messageWithChatId = {...message, 'chat_id': chatId};
      await _supabase.from('messages').insert(messageWithChatId);
      return true;
    } catch (e) {
      print('Send chat message error: $e');
      return false;
    }
  }
}
