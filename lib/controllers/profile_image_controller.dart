import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ecommerce_ui/controllers/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileImageController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final _supabase = Supabase.instance.client;
  final _authController = Get.find<AuthController>();

  final RxBool _isUploading = false.obs;
  final RxString _imageUrl = ''.obs;

  bool get isUploading => _isUploading.value;
  String get imageUrl => _imageUrl.value;

  Future<void> pickImageFromCamera() async {
    if (kIsWeb) {
      Get.snackbar(
        'Not Supported',
        'Camera is not available on web. Please use gallery instead.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        await _uploadImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      if (kIsWeb) {
        // Use file_picker for web
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );

        if (result != null && result.files.isNotEmpty) {
          final file = result.files.first;
          if (file.bytes != null) {
            await _uploadImageBytes(file.bytes!, file.name);
          }
        }
      } else {
        // Use image_picker for mobile
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 512,
          maxHeight: 512,
          imageQuality: 75,
        );

        if (image != null) {
          await _uploadImage(File(image.path));
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      _isUploading.value = true;

      final user = _authController.currentUser;
      if (user == null || user.id == null) {
        throw Exception('User not logged in');
      }

      // Generate unique filename
      final fileName =
          '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'profile_images/$fileName';

      // Upload to Supabase Storage
      await _supabase.storage.from('avatars').upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      // Get public URL
      final publicUrl =
          _supabase.storage.from('avatars').getPublicUrl(filePath);

      _imageUrl.value = publicUrl;

      // Update user profile in database
      final success = await _authController.updateProfile(
        profileImageUrl: publicUrl,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isUploading.value = false;
    }
  }

  Future<void> _uploadImageBytes(List<int> bytes, String fileName) async {
    try {
      _isUploading.value = true;

      final user = _authController.currentUser;
      if (user == null || user.id == null) {
        throw Exception('User not logged in');
      }

      // Generate unique filename
      final uniqueFileName =
          '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'profile_images/$uniqueFileName';

      // Upload to Supabase Storage
      await _supabase.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      // Get public URL
      final publicUrl =
          _supabase.storage.from('avatars').getPublicUrl(filePath);

      _imageUrl.value = publicUrl;

      // Update user profile in database
      final success = await _authController.updateProfile(
        profileImageUrl: publicUrl,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isUploading.value = false;
    }
  }

  Future<void> removeProfileImage() async {
    try {
      _isUploading.value = true;

      final success = await _authController.updateProfile(
        profileImageUrl: null,
      );

      if (success) {
        _imageUrl.value = '';
        Get.snackbar(
          'Success',
          'Profile picture removed',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove image: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isUploading.value = false;
    }
  }
}
