import 'package:get/get.dart';
import 'package:ecommerce_ui/repositories/product_repository.dart';
import 'package:ecommerce_ui/model/product.dart';

class ProductController extends GetxController {
  final _productRepository = ProductRepository();

  final RxList<Product> _products = <Product>[].obs;
  final RxList<Product> _filteredProducts = <Product>[].obs;
  final RxList<Category> _categories = <Category>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _selectedCategory = 'All'.obs;
  final RxString _searchQuery = ''.obs;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading.value;
  String get selectedCategory => _selectedCategory.value;

  List<Product> get filteredProducts {
    // If searching, return filtered products
    if (_searchQuery.value.isNotEmpty) {
      return _filteredProducts;
    }

    // If category filter is applied
    if (_selectedCategory.value == 'All') {
      return _products;
    }

    final category = _categories.firstWhereOrNull(
      (cat) => cat.name == _selectedCategory.value,
    );
    if (category != null) {
      return _products
          .where((product) => product.categoryId == category.id)
          .toList();
    }
    return _products;
  }

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      loadCategories(),
      loadProducts(),
    ]);
  }

  Future<void> loadProducts() async {
    try {
      _isLoading.value = true;
      final products = await _productRepository.getAllProducts();

      if (products.isNotEmpty) {
        // Use products from database
        print('Loaded ${products.length} products from database');
        _products.assignAll(products);
      } else {
        // Database is empty, use sample data but show warning
        print('Database is empty, using sample data');
        _products.assignAll(sampleProductsWithIds);
        Get.snackbar(
          'Info',
          'Using sample data. Please insert data into Supabase database.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Error loading products from database: $e');
      // Only use sample data if there's a connection error
      _products.assignAll(sampleProductsWithIds);
      Get.snackbar(
        'Warning',
        'Database connection failed. Using sample data.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      final categories = await _productRepository.getAllCategories();
      _categories.assignAll(categories);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories: $e');
    }
  }

  Future<void> loadProductsByCategory(int categoryId) async {
    try {
      _isLoading.value = true;
      final products =
          await _productRepository.getProductsByCategory(categoryId);
      _products.assignAll(products);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void selectCategory(String categoryName) {
    _selectedCategory.value = categoryName;
    if (categoryName == 'All') {
      loadProducts();
    } else {
      final category = _categories.firstWhereOrNull(
        (cat) => cat.name == categoryName,
      );
      if (category != null) {
        loadProductsByCategory(category.id!);
      }
    }
  }

  Future<void> searchProducts(String query) async {
    _searchQuery.value = query;

    if (query.isEmpty) {
      _filteredProducts.clear();
      return;
    }

    try {
      _isLoading.value = true;

      // Search in current products (works for both database and sample data)
      final filtered = _products.where((product) {
        final searchLower = query.toLowerCase();
        return product.name.toLowerCase().contains(searchLower) ||
            product.category.toLowerCase().contains(searchLower) ||
            product.description.toLowerCase().contains(searchLower);
      }).toList();

      _filteredProducts.assignAll(filtered);

      if (filtered.isEmpty) {
        Get.snackbar(
          'No Results',
          'No products found for "$query"',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error searching products: $e');
      Get.snackbar('Error', 'Failed to search products');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      return await _productRepository.getProductById(id);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get product: $e');
      return null;
    }
  }

  void refreshProducts() {
    loadProducts();
  }
}
