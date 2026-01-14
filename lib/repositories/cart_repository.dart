import 'package:ecommerce_ui/config/supabase_config.dart';

class CartRepository {
  final _supabase = SupabaseConfig.client;

  // Add item to cart in database
  Future<void> addToCart({
    required String userId,
    required int productId,
    int quantity = 1,
  }) async {
    try {
      // Check if item already exists in cart
      final existingItem = await _supabase
          .from('cart_items')
          .select('*')
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (existingItem != null) {
        // Update quantity if item exists
        await _supabase
            .from('cart_items')
            .update({
              'quantity': existingItem['quantity'] + quantity,
            })
            .eq('user_id', userId)
            .eq('product_id', productId);
      } else {
        // Insert new item
        await _supabase.from('cart_items').insert({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        });
      }
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  // Get cart items for user
  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    try {
      final response = await _supabase.from('cart_items').select('''
            *,
            products (
              id,
              name,
              price,
              old_price,
              image_url,
              description
            )
          ''').eq('user_id', userId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting cart items: $e');
      rethrow;
    }
  }

  // Update cart item quantity
  Future<void> updateCartItemQuantity({
    required String userId,
    required int productId,
    required int quantity,
  }) async {
    try {
      if (quantity <= 0) {
        await removeFromCart(userId: userId, productId: productId);
        return;
      }

      await _supabase
          .from('cart_items')
          .update({'quantity': quantity})
          .eq('user_id', userId)
          .eq('product_id', productId);
    } catch (e) {
      print('Error updating cart item quantity: $e');
      rethrow;
    }
  }

  // Remove item from cart
  Future<void> removeFromCart({
    required String userId,
    required int productId,
  }) async {
    try {
      await _supabase
          .from('cart_items')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
    } catch (e) {
      print('Error removing from cart: $e');
      rethrow;
    }
  }

  // Clear all cart items for user
  Future<void> clearCart(String userId) async {
    try {
      await _supabase.from('cart_items').delete().eq('user_id', userId);
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }

  // Get cart item count
  Future<int> getCartItemCount(String userId) async {
    try {
      final response = await _supabase
          .from('cart_items')
          .select('quantity')
          .eq('user_id', userId);

      int totalCount = 0;
      for (var item in response) {
        totalCount += item['quantity'] as int;
      }
      return totalCount;
    } catch (e) {
      print('Error getting cart item count: $e');
      return 0;
    }
  }
}
