import 'package:get/get.dart';
import 'package:ecommerce_ui/model/product.dart';
import 'package:ecommerce_ui/repositories/favorites_repository.dart';
import 'package:ecommerce_ui/controllers/auth_controller.dart';

class FavoritesController extends GetxController {
  final _favoritesRepository = FavoritesRepository();
  final RxList<Product> _favoriteProducts = <Product>[].obs;
  final RxBool _isLoading = false.obs;

  List<Product> get favoriteProducts => _favoriteProducts;
  int get favoriteCount => _favoriteProducts.length;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Load favorites from database
  Future<void> loadFavorites() async {
    try {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser;

      if (currentUser?.id == null) {
        print('No user logged in, cannot load favorites');
        return;
      }

      _isLoading.value = true;
      final favoritesData =
          await _favoritesRepository.getFavoriteProducts(currentUser!.id!);

      _favoriteProducts.clear();
      for (var item in favoritesData) {
        final productData = item['products'];
        if (productData != null) {
          final product = Product.fromJson(productData);
          _favoriteProducts.add(product);
        }
      }
    } catch (e) {
      print('Error loading favorites: $e');
      Get.snackbar('Error', 'Failed to load favorites');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(Product product) async {
    try {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser;

      if (currentUser?.id == null) {
        Get.snackbar('Error', 'Please login to manage favorites');
        return;
      }

      if (product.id == null) {
        Get.snackbar(
          'Error',
          'Product not found in database. Please refresh the product list.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      _isLoading.value = true;

      if (isFavorite(product)) {
        // Remove from database
        await _favoritesRepository.removeFromFavorites(
          userId: currentUser!.id!,
          productId: product.id!,
        );

        // Update local state
        _favoriteProducts.removeWhere((p) => p.id == product.id);

        Get.snackbar(
          'Removed from Favorites',
          '${product.name} removed from favorites',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        // Add to database
        await _favoritesRepository.addToFavorites(
          userId: currentUser!.id!,
          productId: product.id!,
        );

        // Update local state
        _favoriteProducts.add(product);

        Get.snackbar(
          'Added to Favorites',
          '${product.name} added to favorites',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      Get.snackbar(
        'Error',
        'Failed to update favorites. Please check your connection.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  bool isFavorite(Product product) {
    return _favoriteProducts.any((p) => p.id == product.id);
  }

  Future<void> clearFavorites() async {
    try {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser;

      if (currentUser?.id == null) return;

      _isLoading.value = true;

      // Clear from database
      await _favoritesRepository.clearFavorites(currentUser!.id!);

      // Clear local state
      _favoriteProducts.clear();
    } catch (e) {
      print('Error clearing favorites: $e');
      Get.snackbar('Error', 'Failed to clear favorites');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addToFavorites(Product product) async {
    if (!isFavorite(product)) {
      await toggleFavorite(product);
    }
  }

  Future<void> removeFromFavorites(Product product) async {
    if (isFavorite(product)) {
      await toggleFavorite(product);
    }
  }

  void refreshFavorites() {
    loadFavorites();
  }
}
