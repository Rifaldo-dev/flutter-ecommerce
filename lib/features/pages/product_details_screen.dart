import 'package:ecommerce_ui/model/product.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';
import 'package:ecommerce_ui/controllers/cart_controller.dart';
import 'package:ecommerce_ui/controllers/favorites_controller.dart';
import 'package:ecommerce_ui/features/widgets/animated_button.dart';
import 'package:ecommerce_ui/features/widgets/animated_icon_button.dart';
import 'package:ecommerce_ui/features/widgets/animation_types.dart';
import 'package:ecommerce_ui/features/pages/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/size_selector.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: AnimatedIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
          color: isDark ? Colors.white : Colors.black,
          animationType: AnimationType.scale,
        ),
        title: Text(
          'Details',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          // share button
          AnimatedIconButton(
            icon: Icons.share,
            onPressed: () =>
                _shareProduct(context, product.name, product.description),
            color: isDark ? Colors.white : Colors.black,
            animationType: AnimationType.pulse,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // image
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    product.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // favorite button
                Positioned(
                  right: screenWidth * 0.04,
                  top: screenWidth * 0.04,
                  child: GetBuilder<FavoritesController>(
                    builder: (favoritesController) => AnimatedFavoriteButton(
                      isFavorite: favoritesController.isFavorite(product),
                      onPressed: () {
                        favoritesController.toggleFavorite(product);
                      },
                      favoriteColor: Theme.of(context).primaryColor,
                      unfavoriteColor: isDark ? Colors.white : Colors.black,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
            // product details
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: AppTextStyle.withColor(
                            AppTextStyle.h2,
                            Theme.of(context).textTheme.headlineMedium!.color!,
                          ),
                        ),
                      ),
                      Text(
                        'Rp ${product.price.toStringAsFixed(0)}',
                        style: AppTextStyle.withColor(
                          AppTextStyle.h2,
                          Theme.of(context).textTheme.headlineMedium!.color!,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    product.category,
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodyMedium,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Select Size',
                    style: AppTextStyle.withColor(
                      AppTextStyle.labelMedium,
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // size selector
                  const SizeSelector(),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Description',
                    style: AppTextStyle.withColor(
                      AppTextStyle.labelMedium,
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    product.description,
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodySmall,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // buttons
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
            children: [
              Expanded(
                child: AnimatedOutlinedButton(
                  text: 'Add To Cart',
                  onPressed: () {
                    final cartController = Get.find<CartController>();
                    cartController.addToCart(product);
                  },
                  borderColor: isDark ? Colors.white70 : Colors.black12,
                  textColor: Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: AnimatedElevatedButton(
                  text: 'Buy Now',
                  onPressed: () {
                    // Add to cart and navigate to checkout
                    final cartController = Get.find<CartController>();
                    cartController.addToCart(product);

                    // Navigate to cart screen
                    Get.snackbar(
                      'Buy Now',
                      '${product.name} added to cart. Redirecting to cart...',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );

                    // Navigate to cart screen
                    Future.delayed(const Duration(seconds: 1), () {
                      Get.to(() => const CartScreen());
                    });
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareProduct(
      BuildContext context, String productName, String description) async {
    // Get the render box for share position origin (required for iPad)
    final box = context.findRenderObject() as RenderBox?;

    const String shopLink = 'https://yourshop.com/product/cotton-tshirt';

    final String shareMessage = '$description\n\nShop now at: $shopLink';

    try {
      final ShareResult result = await Share.share(
        shareMessage,
        subject: productName,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );

      if (result.status == ShareResultStatus.success) {
        debugPrint('Thank you for sharing!');
      }
    } catch (e) {
      debugPrint('Error sharing: $e');
    }
  }
}
