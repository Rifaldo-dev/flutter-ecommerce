import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ecommerce_ui/repositories/auth_repository.dart';
import 'package:ecommerce_ui/model/user.dart' as app_user;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final _storage = GetStorage();
  final _authRepository = AuthRepository();

  final RxBool _isFirstTime = true.obs;
  final RxBool _isLoggedIn = false.obs;
  final RxBool _isLoading = false.obs;
  final Rx<app_user.User?> _currentUser = Rx<app_user.User?>(null);

  bool get isFirstTime => _isFirstTime.value;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isLoading => _isLoading.value;
  app_user.User? get currentUser => _currentUser.value;

  @override
  void onInit() {
    super.onInit();
    _loadInitialState();
    _checkAuthState();
  }

  void _checkAuthState() async {
    // Check if user is already logged in from Supabase
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      // Get user profile from database
      try {
        final response = await Supabase.instance.client
            .from('users')
            .select()
            .eq('id', session.user.id)
            .single();

        final user = app_user.User.fromJson(response);
        _currentUser.value = user;
        _isLoggedIn.value = true;
        print('User already logged in: ${user.email}');
      } catch (e) {
        print('Error loading user profile: $e');
        // If profile doesn't exist, sign out
        await signOut();
      }
    }
  }

  void _loadInitialState() {
    _isFirstTime.value = _storage.read('isFirstTime') ?? true;
    // Remove auth status check for simplicity
  }

  // Remove auth state listening method

  // Google Sign In - Removed for simplicity
  // Use email/password authentication instead

  void setFirstTimeDone() {
    _isFirstTime.value = false;
    _storage.write('isFirstTime', false);
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      _isLoading.value = true;

      print('Controller: Starting signup process');

      final user = await _authRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );

      if (user != null) {
        print('Controller: Signup successful, updating state');
        _currentUser.value = user;
        _isLoggedIn.value = true;
        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.TOP,
        );
        return true;
      } else {
        print('Controller: Signup failed - no user returned');
        Get.snackbar(
          'Error',
          'Failed to create account. Please try again.',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      print('Controller: Signup error - $e');

      String errorMessage = 'Failed to create account';

      // Parse common Supabase errors
      if (e.toString().contains('already registered')) {
        errorMessage = 'Email is already registered';
      } else if (e.toString().contains('Invalid email')) {
        errorMessage = 'Please enter a valid email address';
      } else if (e.toString().contains('Password')) {
        errorMessage = 'Password must be at least 6 characters';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your connection';
      }

      Get.snackbar(
        'Registration Failed',
        errorMessage,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading.value = true;
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );

      if (user != null) {
        _currentUser.value = user;
        _isLoggedIn.value = true;
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      await _authRepository.signOut();
      _currentUser.value = null;
      _isLoggedIn.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      if (_currentUser.value == null) return false;

      _isLoading.value = true;
      final updatedUser = await _authRepository.updateProfile(
        userId: _currentUser.value!.id!,
        fullName: fullName,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );

      if (updatedUser != null) {
        _currentUser.value = updatedUser;
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading.value = true;
      await _authRepository.resetPassword(email);
      Get.snackbar('Success', 'Password reset email sent');
    } catch (e) {
      Get.snackbar('Error', 'Failed to reset password: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Legacy methods for compatibility
  void login() {
    _isLoggedIn.value = true;
    _storage.write('isLoggedIn', true);
  }

  void logout() {
    signOut();
    _storage.write('isLoggedIn', false);
  }
}
