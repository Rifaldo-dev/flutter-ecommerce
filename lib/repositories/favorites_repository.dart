import 'package:ecommerce_ui/config/supabase_config.dart';

class FavoritesRepository {
  final _supabase = SupabaseConfig.client;

  // Add product to favorites
  Future<void> addToFavorites({
    required String userId,
    required int productId,
  }) async {
    try {
      await _supabase.from('user_favorites').insert({
        'user_id': userId,
        'product_id': productId,
      });
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  // Remove product from favorites
  Future<void> removeFromFavorites({
    required String userId,
    required int productId,
  }) async {
    try {
      await _supabase
          .from('user_favorites')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  // Get user's favorite products
  Future<List<Map<String, dynamic>>> getFavoriteProducts(String userId) async {
    try {
      final response = await _supabase.from('user_favorites').select('''
            *,
            products (
              id,
              name,
              price,
              old_price,
              image_url,
              description,
              category_id
            )
          ''').eq('user_id', userId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting favorite products: $e');
      rethrow;
    }
  }

  // Check if product is in favorites
  Future<bool> isFavorite({
    required String userId,
    required int productId,
  }) async {
    try {
      final response = await _supabase
          .from('user_favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking if favorite: $e');
      return false;
    }
  }

  // Get favorites count
  Future<int> getFavoritesCount(String userId) async {
    try {
      final response = await _supabase
          .from('user_favorites')
          .select('id')
          .eq('user_id', userId);

      return response.length;
    } catch (e) {
      print('Error getting favorites count: $e');
      return 0;
    }
  }

  // Clear all favorites for a user
  Future<void> clearFavorites(String userId) async {
    try {
      await _supabase.from('user_favorites').delete().eq('user_id', userId);
    } catch (e) {
      print('Error clearing favorites: $e');
      rethrow;
    }
  }
}
