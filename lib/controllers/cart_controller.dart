import 'package:get/get.dart';
import 'package:ecommerce_ui/model/product.dart';
import 'package:ecommerce_ui/repositories/cart_repository.dart';
import 'package:ecommerce_ui/controllers/auth_controller.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class CartController extends GetxController {
  final _cartRepository = CartRepository();
  final RxList<CartItem> _cartItems = <CartItem>[].obs;
  final RxBool _isLoading = false.obs;

  List<CartItem> get cartItems => _cartItems;
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  // Load cart items from database
  Future<void> loadCartItems() async {
    try {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser;

      if (currentUser?.id == null) {
        print('No user logged in, cannot load cart');
        return;
      }

      _isLoading.value = true;
      final cartData = await _cartRepository.getCartItems(currentUser!.id!);

      _cartItems.clear();
      for (var item in cartData) {
        final productData = item['products'];
        if (productData != null) {
          final product = Product.fromJson(productData);
          _cartItems.add(CartItem(
            product: product,
            quantity: item['quantity'],
          ));
        }
      }
    } catch (e) {
      print('Error loading cart items: $e');
      Get.snackbar('Error', 'Failed to load cart items');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addToCart(Product product) async {
    try {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser;

      if (currentUser?.id == null) {
        Get.snackbar('Error', 'Please login to add items to cart');
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

      // Add to database first
      await _cartRepository.addToCart(
        userId: currentUser!.id!,
        productId: product.id!,
        quantity: 1,
      );

      // Update local state after successful database operation
      final existingIndex =
          _cartItems.indexWhere((item) => item.product.id == product.id);

      if (existingIndex >= 0) {
        _cartItems[existingIndex].quantity++;
        _cartItems.refresh();
      } else {
        _cartItems.add(CartItem(product: product));
      }

      Get.snackbar(
        'Added to Cart',
        '${product.name} added to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to cart. Please check your connection.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> removeFromCart(Product product) async {
    try {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser;

      if (currentUser?.id == null) return;

      if (product.id == null) {
        Get.snackbar(
          'Error',
          'Product not found in database.',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      _isLoading.value = true;

      // Remove from database
      await _cartRepository.removeFromCart(
        userId: currentUser!.id!,
        productId: product.id!,
      );

      // Update local state
      _cartItems.removeWhere((item) => item.product.id == product.id);

      Get.snackbar(
        'Removed from Cart',
        '${product.name} removed from cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error removing from cart: $e');
      Get.snackbar(
        'Error',
        'Failed to remove item from cart.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateQuantity(Product product, int quantity) async {
    try {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser;

      if (currentUser?.id == null || product.id == null) return;

      if (quantity <= 0) {
        await removeFromCart(product);
        return;
      }

      _isLoading.value = true;

      // Update in database
      await _cartRepository.updateCartItemQuantity(
        userId: currentUser!.id!,
        productId: product.id!,
        quantity: quantity,
      );

      // Update local state
      final existingIndex =
          _cartItems.indexWhere((item) => item.product.id == product.id);
      if (existingIndex >= 0) {
        _cartItems[existingIndex].quantity = quantity;
        _cartItems.refresh();
      }
    } catch (e) {
      print('Error updating quantity: $e');
      Get.snackbar('Error', 'Failed to update quantity');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> clearCart() async {
    try {
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser;

      if (currentUser?.id == null) return;

      _isLoading.value = true;

      // Clear from database
      await _cartRepository.clearCart(currentUser!.id!);

      // Clear local state
      _cartItems.clear();
    } catch (e) {
      print('Error clearing cart: $e');
      Get.snackbar('Error', 'Failed to clear cart');
    } finally {
      _isLoading.value = false;
    }
  }

  bool isInCart(Product product) {
    return _cartItems.any((item) => item.product.id == product.id);
  }

  int getQuantity(Product product) {
    final item =
        _cartItems.firstWhereOrNull((item) => item.product.id == product.id);
    return item?.quantity ?? 0;
  }
}
