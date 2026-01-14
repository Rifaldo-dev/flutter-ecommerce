import 'package:ecommerce_ui/config/supabase_config.dart';
import 'package:ecommerce_ui/model/product.dart';

class ProductRepository {
  final _supabase = SupabaseConfig.client;

  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select('*')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _supabase
          .from('products')
          .select('*')
          .eq('category_id', categoryId)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products by category: $e');
    }
  }

  // Get product by ID
  Future<Product?> getProductById(int id) async {
    try {
      final response =
          await _supabase.from('products').select('*').eq('id', id).single();

      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  // Get all categories
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _supabase
          .from('categories')
          .select('*')
          .order('name', ascending: true);

      return (response as List).map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _supabase
          .from('products')
          .select('*')
          .ilike('name', '%$query%')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }
}
