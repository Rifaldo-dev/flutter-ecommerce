import 'package:ecommerce_ui/model/product.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';
import 'package:ecommerce_ui/controllers/cart_controller.dart';
import 'package:ecommerce_ui/controllers/favorites_controller.dart';
import 'package:ecommerce_ui/features/pages/product_details_screen.dart';
import 'package:ecommerce_ui/features/widgets/animated_button.dart';
import 'package:ecommerce_ui/features/widgets/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartController = Get.find<CartController>();
    final favoritesController = Get.find<FavoritesController>();

    return GestureDetector(
      onTap: () {
        // Navigate to product details
        Get.to(() => ProductDetailsScreen(product: product));
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.9,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // image
                AspectRatio(
                  aspectRatio: 1.2, // Changed from 16/9 to make it less tall
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // favorite button
                Positioned(
                  right: 6,
                  top: 6,
                  child: Obx(() => AnimatedFavoriteButton(
                        isFavorite: favoritesController.isFavorite(product),
                        onPressed: () {
                          favoritesController.toggleFavorite(product);
                        },
                        favoriteColor: Theme.of(context).primaryColor,
                        unfavoriteColor:
                            isDark ? Colors.grey[400] : Colors.grey,
                        size: screenWidth < 360 ? 20 : 22,
                      )),
                ),
                if (product.oldPrice != null)
                  Positioned(
                    left: 6,
                    top: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth < 360 ? 6 : 8,
                        vertical: screenWidth < 360 ? 2 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${calculateDiscount(product.price, product.oldPrice!)}% OFF',
                        style: TextStyle(
                          fontSize: screenWidth < 360 ? 9 : 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // product details
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 12 : 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.category,
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 10 : 11,
                      color: isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Rp ${_formatPrice(product.price)}',
                          style: TextStyle(
                            fontSize: screenWidth < 360 ? 12 : 13,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color!,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          'Rp ${_formatPrice(product.oldPrice!)}',
                          style: TextStyle(
                            fontSize: screenWidth < 360 ? 9 : 10,
                            color:
                                isDark ? Colors.grey[400]! : Colors.grey[600]!,
                            decoration: TextDecoration.lineThrough,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: SizedBox(
                width: double.infinity,
                height: screenWidth < 360 ? 32 : 36,
                child: Obx(() {
                  final isInCart = cartController.isInCart(product);
                  final quantity = cartController.getQuantity(product);

                  return AnimatedElevatedButton(
                    text: isInCart ? 'Cart ($quantity)' : 'Add to Cart',
                    onPressed: () {
                      cartController.addToCart(product);
                    },
                    icon: Icon(
                      isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                      size: screenWidth < 360 ? 14 : 16,
                      color: Colors.white,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    width: double.infinity,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(price % 1000000 == 0 ? 0 : 1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 0)}K';
    }
    return price.toStringAsFixed(0);
  }
}

// calculate discount
int calculateDiscount(double currentPrice, double oldPrice) {
  return (((oldPrice - currentPrice) / oldPrice) * 100).round();
}
