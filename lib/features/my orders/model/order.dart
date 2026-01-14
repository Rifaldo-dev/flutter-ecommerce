enum OrderStatus { active, completed, cancelled }

class Order {
  final String? id;
  final String orderNumber;
  final int itemCount;
  final double totalAmount;
  final OrderStatus status;
  final String imageUrl;
  final DateTime orderDate;
  final String? userId;
  final List<OrderItem>? items;

  const Order({
    this.id,
    required this.orderNumber,
    required this.itemCount,
    required this.totalAmount,
    required this.status,
    required this.imageUrl,
    required this.orderDate,
    this.userId,
    this.items,
  });

  String get statusString => status.name;

  // Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'item_count': itemCount,
      'total_amount': totalAmount,
      'status': status.name,
      'image_url': imageUrl,
      'order_date': orderDate.toIso8601String(),
      'user_id': userId,
    };
  }

  // Create from JSON from Supabase
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString(),
      orderNumber: json['order_number'] ?? '',
      itemCount: json['item_count'] ?? 0,
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.active,
      ),
      imageUrl: json['image_url'] ?? '',
      orderDate: DateTime.parse(
          json['order_date'] ?? DateTime.now().toIso8601String()),
      userId: json['user_id']?.toString(),
    );
  }
}

class OrderItem {
  final String? id;
  final String? orderId;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;

  const OrderItem({
    this.id,
    this.orderId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id']?.toString(),
      orderId: json['order_id']?.toString(),
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
      imageUrl: json['image_url'],
    );
  }
}
