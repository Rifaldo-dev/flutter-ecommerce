import 'package:get/get.dart';
import 'package:ecommerce_ui/features/my%20orders/repository/order_repository.dart';
import 'package:ecommerce_ui/features/my%20orders/model/order.dart';
import 'package:ecommerce_ui/controllers/auth_controller.dart';
import 'package:ecommerce_ui/controllers/cart_controller.dart';

class OrderController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  final AuthController _authController = Get.find<AuthController>();
  final CartController _cartController = Get.find<CartController>();

  final RxList<Order> _orders = <Order>[].obs;
  final RxBool _isLoading = false.obs;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  // Load orders for current user
  Future<void> loadOrders() async {
    try {
      _isLoading.value = true;
      final userId = _authController.currentUser?.id;
      final orders = await _orderRepository.getOrders(userId: userId);
      _orders.value = orders;
    } catch (e) {
      print('Error loading orders: $e');
      Get.snackbar('Error', 'Failed to load orders');
    } finally {
      _isLoading.value = false;
    }
  }

  // Create new order from cart
  Future<Order?> createOrderFromCart() async {
    try {
      if (_cartController.cartItems.isEmpty) {
        Get.snackbar('Error', 'Cart is empty');
        return null;
      }

      if (_authController.currentUser == null) {
        Get.snackbar('Error', 'Please login to place order');
        return null;
      }

      _isLoading.value = true;

      // Generate order number
      final orderNumber =
          'ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      // Convert cart items to order items
      final orderItems = _cartController.cartItems
          .map((cartItem) => OrderItem(
                productId: cartItem.product.id?.toString() ?? '',
                productName: cartItem.product.name,
                price: cartItem.product.price,
                quantity: cartItem.quantity,
                imageUrl: cartItem.product.imageUrl,
              ))
          .toList();

      // Create order
      final order = await _orderRepository.createOrder(
        orderNumber: orderNumber,
        itemCount: _cartController.itemCount,
        totalAmount: _cartController.totalAmount,
        imageUrl: _cartController.cartItems.first.product.imageUrl,
        userId: _authController.currentUser!.id!,
        items: orderItems,
      );

      if (order != null) {
        // Add to local orders list
        _orders.insert(0, order);

        // Clear cart after successful order
        _cartController.clearCart();

        Get.snackbar(
          'Success',
          'Order placed successfully!',
          snackPosition: SnackPosition.TOP,
        );

        return order;
      } else {
        Get.snackbar('Error', 'Failed to create order');
        return null;
      }
    } catch (e) {
      print('Error creating order: $e');
      Get.snackbar('Error', 'Failed to place order: $e');
      return null;
    } finally {
      _isLoading.value = false;
    }
  }

  // Get orders by status
  Future<List<Order>> getOrdersByStatus(OrderStatus status) async {
    try {
      final userId = _authController.currentUser?.id;
      return await _orderRepository.getOrdersByStatus(status, userId: userId);
    } catch (e) {
      print('Error getting orders by status: $e');
      return [];
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      final success = await _orderRepository.updateOrderStatus(orderId, status);
      if (success) {
        // Update local list
        final index = _orders.indexWhere((order) => order.id == orderId);
        if (index != -1) {
          final updatedOrder = Order(
            id: _orders[index].id,
            orderNumber: _orders[index].orderNumber,
            itemCount: _orders[index].itemCount,
            totalAmount: _orders[index].totalAmount,
            status: status,
            imageUrl: _orders[index].imageUrl,
            orderDate: _orders[index].orderDate,
            userId: _orders[index].userId,
          );
          _orders[index] = updatedOrder;
        }
        Get.snackbar('Success', 'Order status updated');
      }
      return success;
    } catch (e) {
      print('Error updating order status: $e');
      Get.snackbar('Error', 'Failed to update order status');
      return false;
    }
  }

  // Get order items
  Future<List<OrderItem>> getOrderItems(String orderId) async {
    try {
      return await _orderRepository.getOrderItems(orderId);
    } catch (e) {
      print('Error getting order items: $e');
      return [];
    }
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId) async {
    return await updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  // Delete order
  Future<bool> deleteOrder(String orderId) async {
    try {
      final success = await _orderRepository.deleteOrder(orderId);
      if (success) {
        // Remove from local list
        _orders.removeWhere((order) => order.id == orderId);
        Get.snackbar('Success', 'Order deleted successfully');
      }
      return success;
    } catch (e) {
      print('Error deleting order: $e');
      Get.snackbar('Error', 'Failed to delete order');
      return false;
    }
  }
}
