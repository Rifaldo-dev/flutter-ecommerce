import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/order.dart';

class OrderRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Create new order
  Future<Order?> createOrder({
    required String orderNumber,
    required int itemCount,
    required double totalAmount,
    required String imageUrl,
    required String userId,
    required List<OrderItem> items,
  }) async {
    try {
      print('Creating order: $orderNumber');

      // Insert order
      final orderResponse = await _supabase
          .from('orders')
          .insert({
            'order_number': orderNumber,
            'item_count': itemCount,
            'total_amount': totalAmount,
            'status': OrderStatus.active.name,
            'image_url': imageUrl,
            'order_date': DateTime.now().toIso8601String(),
            'user_id': userId,
          })
          .select()
          .single();

      print('Order created: ${orderResponse['id']}');

      // Insert order items
      final orderItems = items
          .map((item) => {
                ...item.toJson(),
                'order_id': orderResponse['id'],
              })
          .toList();

      await _supabase.from('order_items').insert(orderItems);

      print('Order items inserted: ${orderItems.length}');

      return Order.fromJson(orderResponse);
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  // Get orders for user
  Future<List<Order>> getOrders({String? userId}) async {
    try {
      dynamic query;

      if (userId != null) {
        query = _supabase
            .from('orders')
            .select('*')
            .eq('user_id', userId)
            .order('order_date', ascending: false);
      } else {
        query = _supabase
            .from('orders')
            .select('*')
            .order('order_date', ascending: false);
      }

      final response = await query;

      return response.map<Order>((json) => Order.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching orders: $e');
      // Return dummy data as fallback
      return _getDummyOrders();
    }
  }

  // Get orders by status
  Future<List<Order>> getOrdersByStatus(OrderStatus status,
      {String? userId}) async {
    try {
      dynamic query;

      if (userId != null) {
        query = _supabase
            .from('orders')
            .select('*')
            .eq('status', status.name)
            .eq('user_id', userId)
            .order('order_date', ascending: false);
      } else {
        query = _supabase
            .from('orders')
            .select('*')
            .eq('status', status.name)
            .order('order_date', ascending: false);
      }

      final response = await query;

      return response.map<Order>((json) => Order.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching orders by status: $e');
      return _getDummyOrders()
          .where((order) => order.status == status)
          .toList();
    }
  }

  // Get order items for an order
  Future<List<OrderItem>> getOrderItems(String orderId) async {
    try {
      final response = await _supabase
          .from('order_items')
          .select('*')
          .eq('order_id', orderId);

      return response
          .map<OrderItem>((json) => OrderItem.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching order items: $e');
      return [];
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _supabase
          .from('orders')
          .update({'status': status.name}).eq('id', orderId);

      return true;
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }

  // Fallback dummy data
  List<Order> _getDummyOrders() {
    return [
      Order(
        orderNumber: '12345',
        itemCount: 2,
        totalAmount: 299.99,
        status: OrderStatus.active,
        imageUrl: 'assets/images/shoe.jpg',
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Order(
        orderNumber: '12346',
        itemCount: 1,
        totalAmount: 199.99,
        status: OrderStatus.active,
        imageUrl: 'assets/images/laptop.jpg',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Order(
        orderNumber: '12347',
        itemCount: 3,
        totalAmount: 499.99,
        status: OrderStatus.completed,
        imageUrl: 'assets/images/shoe2.jpg',
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Order(
        orderNumber: '12348',
        itemCount: 1,
        totalAmount: 149.99,
        status: OrderStatus.cancelled,
        imageUrl: 'assets/images/shoes2.jpg',
        orderDate: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  }
}
