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
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _loadUserProfile(session.user.id);
      } else {
        _currentUser.value = null;
        _isLoggedIn.value = false;
        _storage.remove('userId');
      }
    });
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      final user = app_user.User.fromJson(response);
      _currentUser.value = user;
      _isLoggedIn.value = true;
      _storage.write('userId', userId);
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> _checkAuthState() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      await _loadUserProfile(session.user.id);
    } else {
      final userId = _storage.read('userId');
      if (userId != null) {
        try {
          await _loadUserProfile(userId);
        } catch (e) {
          print('Failed to restore session: $e');
          _storage.remove('userId');
        }
      }
    }
  }

  void _loadInitialState() {
    _isFirstTime.value = _storage.read('isFirstTime') ?? true;
  }

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

      final user = await _authRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );

      if (user != null) {
        _currentUser.value = user;
        _isLoggedIn.value = true;
        _storage.write('userId', user.id);
        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.TOP,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to create account. Please try again.',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      final errorMessage = _parseAuthError(e.toString());
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
        _storage.write('userId', user.id);
        Get.snackbar(
          'Success',
          'Welcome back, ${user.fullName}!',
          snackPosition: SnackPosition.TOP,
        );
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
      _storage.remove('userId');
      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.TOP,
      );
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

  String _parseAuthError(String error) {
    if (error.contains('already registered')) {
      return 'Email is already registered';
    } else if (error.contains('Invalid email')) {
      return 'Please enter a valid email address';
    } else if (error.contains('Password')) {
      return 'Password must be at least 6 characters';
    } else if (error.contains('network')) {
      return 'Network error. Please check your connection';
    }
    return 'Failed to create account';
  }
}
