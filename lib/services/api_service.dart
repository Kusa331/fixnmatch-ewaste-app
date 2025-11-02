// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/marketplace_item_model.dart';

class ApiService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Authentication methods
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        return getUserProfile(userCredential.user!.uid);
      }
      return null;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }
  
  Future<UserModel?> signUp(String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        // Create user profile in Firestore
        final newUser = UserModel(
          id: userCredential.user!.uid,
          name: name,
          email: email,
        );
        
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toJson());
            
        return newUser;
      }
      return null;
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // User profile methods
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Get user profile error: $e');
      return null;
    }
  }
  
  Future<bool> updateUserProfile(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .update(user.toJson());
      return true;
    } catch (e) {
      print('Update user profile error: $e');
      return false;
    }
  }
  
  // Marketplace methods
  Future<List<MarketplaceItemModel>> getMarketplaceItems() async {
    try {
      final snapshot = await _firestore.collection('marketplace_items').get();
      return snapshot.docs
          .map((doc) => MarketplaceItemModel.fromJson(
                {...doc.data(), 'id': doc.id}
              ))
          .toList();
    } catch (e) {
      print('Get marketplace items error: $e');
      return [];
    }
  }
  
  Future<MarketplaceItemModel?> getMarketplaceItem(String itemId) async {
    try {
      final doc = await _firestore.collection('marketplace_items').doc(itemId).get();
      if (doc.exists) {
        return MarketplaceItemModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Get marketplace item error: $e');
      return null;
    }
  }
  
  Future<String?> addMarketplaceItem(MarketplaceItemModel item) async {
    try {
      final docRef = await _firestore
          .collection('marketplace_items')
          .add(item.toJson());
      return docRef.id;
    } catch (e) {
      print('Add marketplace item error: $e');
      return null;
    }
  }
  
  Future<bool> updateMarketplaceItem(MarketplaceItemModel item) async {
    try {
      await _firestore
          .collection('marketplace_items')
          .doc(item.id)
          .update(item.toJson());
      return true;
    } catch (e) {
      print('Update marketplace item error: $e');
      return false;
    }
  }
  
  Future<bool> deleteMarketplaceItem(String itemId) async {
    try {
      await _firestore
          .collection('marketplace_items')
          .doc(itemId)
          .delete();
      return true;
    } catch (e) {
      print('Delete marketplace item error: $e');
      return false;
    }
  }
  
  // Chat methods
  Future<List<Map<String, dynamic>>> getChatMessages(String chatId) async {
    try {
      final snapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp')
          .get();
          
      return snapshot.docs
          .map((doc) => doc.data())
          .toList();
    } catch (e) {
      print('Get chat messages error: $e');
      return [];
    }
  }
  
  Future<bool> sendChatMessage(String chatId, Map<String, dynamic> message) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message);
      return true;
    } catch (e) {
      print('Send chat message error: $e');
      return false;
    }
  }
}