import 'package:ecommerce_ui/config/supabase_config.dart';
import 'package:ecommerce_ui/model/user.dart' as app_user;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final _supabase = SupabaseConfig.client;

  // Simple sign up - direct insert only
  Future<app_user.User?> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      print('=== SIGNUP START ===');
      print('Email: $email');
      print('Full name: $fullName');

      final userData = {
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'is_first_time': true,
        'is_logged_in': true,
      };

      print('Data to insert: $userData');

      final response =
          await _supabase.from('users').insert(userData).select().single();

      print('SUCCESS: User inserted: $response');
      print('=== SIGNUP END ===');

      return app_user.User.fromJson(response);
    } catch (e) {
      print('=== SIGNUP ERROR ===');
      print('Error: $e');
      print('=== END ERROR ===');
      rethrow;
    }
  }

  // Simple sign in - just check database
  Future<app_user.User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('Simple signin - checking database');

      final response = await _supabase
          .from('users')
          .select('*')
          .eq('email', email)
          .eq('password', password) // In real app, hash and compare!
          .single();

      // Update login status
      await _supabase
          .from('users')
          .update({'is_logged_in': true}).eq('id', response['id']);

      print('User found and logged in: $response');

      return app_user.User.fromJson(response);
    } catch (e) {
      print('Simple signin error: $e');
      throw Exception('Invalid email or password');
    }
  }

  // Simple sign out
  Future<void> signOut() async {
    try {
      // Just set a flag, no real auth to sign out from
      print('Simple signout - just clearing local state');
    } catch (e) {
      print('Simple signout error: $e');
    }
  }

  // Get current user (mock)
  Future<app_user.User?> getCurrentUser() async {
    try {
      // In a real app, you'd store current user ID somewhere
      print('Getting current user - returning null for now');
      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  // Update user profile
  Future<app_user.User?> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (phoneNumber != null) updates['phone_number'] = phoneNumber;
      if (profileImageUrl != null) {
        updates['profile_image_url'] = profileImageUrl;
      }

      if (updates.isEmpty) return null;

      final response = await _supabase
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return app_user.User.fromJson(response);
    } catch (e) {
      print('Update profile error: $e');
      rethrow;
    }
  }

  // Reset password (mock)
  Future<void> resetPassword(String email) async {
    try {
      print('Password reset for: $email - not implemented');
    } catch (e) {
      print('Reset password error: $e');
    }
  }

  // Check if user is logged in (mock)
  bool get isLoggedIn => false; // Always false for now

  // Get auth state stream (mock)
  Stream<AuthState> get authStateChanges => Stream.empty();
}
