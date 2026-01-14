class Product {
  final int? id;
  final String name;
  final int categoryId;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final bool isFavorite;
  final String description;
  final int stockQuantity;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Product({
    this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    this.isFavorite = false,
    required this.description,
    this.stockQuantity = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    print('=== PRODUCT.FROMJSON DEBUG ===');
    print('Raw JSON: $json');
    print('ID field: ${json['id']}');
    print('ID type: ${json['id'].runtimeType}');

    // Ensure ID is properly converted to int
    int? productId;
    if (json['id'] != null) {
      if (json['id'] is int) {
        productId = json['id'];
      } else if (json['id'] is String) {
        productId = int.tryParse(json['id']);
      } else {
        productId = (json['id'] as num?)?.toInt();
      }
    }

    print('Converted ID: $productId');
    print('=== END FROMJSON DEBUG ===');

    return Product(
      id: productId,
      name: json['name'],
      categoryId: json['category_id'],
      price: (json['price'] as num).toDouble(),
      oldPrice: json['old_price'] != null
          ? (json['old_price'] as num).toDouble()
          : null,
      imageUrl: json['image_url'],
      description: json['description'],
      stockQuantity: json['stock_quantity'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'price': price,
      'old_price': oldPrice,
      'image_url': imageUrl,
      'description': description,
      'stock_quantity': stockQuantity,
      'is_active': isActive,
    };
  }

  // Helper getter for backward compatibility
  String get category => categoryId.toString();
}

class Category {
  final int? id;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Category({
    this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

// Sample data for development (will be replaced by database data)
final List<Product> products = [
  const Product(
    name: 'Shoes',
    categoryId: 2,
    price: 690000,
    oldPrice: 1890000,
    imageUrl: 'assets/images/shoe.jpg',
    description: 'This is a description of the product 1',
  ),
  const Product(
    name: 'Laptop',
    categoryId: 1,
    price: 8800000,
    oldPrice: 15000000,
    imageUrl: 'assets/images/laptop.jpg',
    description: 'This is a description of the product 2',
  ),
  const Product(
    name: 'Jordan Shoes',
    categoryId: 2,
    price: 1290000,
    imageUrl: 'assets/images/shoe2.jpg',
    description: 'This is a description of the product 3',
  ),
  const Product(
    name: 'Puma Shoes',
    categoryId: 2,
    price: 990000,
    imageUrl: 'assets/images/shoes2.jpg',
    isFavorite: true,
    description: 'This is a description of the product 4',
  ),
];

// Sample data with IDs for testing cart/favorites functionality
final List<Product> sampleProductsWithIds = [
  const Product(
    id: 1,
    name: 'Shoes',
    categoryId: 2,
    price: 690000,
    oldPrice: 1890000,
    imageUrl: 'assets/images/shoe.jpg',
    description: 'This is a description of the product 1',
    stockQuantity: 10,
  ),
  const Product(
    id: 2,
    name: 'Laptop',
    categoryId: 1,
    price: 8800000,
    oldPrice: 15000000,
    imageUrl: 'assets/images/laptop.jpg',
    description: 'This is a description of the product 2',
    stockQuantity: 5,
  ),
  const Product(
    id: 3,
    name: 'Jordan Shoes',
    categoryId: 2,
    price: 1290000,
    imageUrl: 'assets/images/shoe2.jpg',
    description: 'This is a description of the product 3',
    stockQuantity: 8,
  ),
  const Product(
    id: 4,
    name: 'Puma Shoes',
    categoryId: 2,
    price: 990000,
    imageUrl: 'assets/images/shoes2.jpg',
    isFavorite: true,
    description: 'This is a description of the product 4',
    stockQuantity: 12,
  ),
];
