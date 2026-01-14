import 'package:ecommerce_ui/model/product.dart';
import 'package:ecommerce_ui/features/pages/product_details_screen.dart';
import 'package:ecommerce_ui/features/widgets/product_card.dart';
import 'package:ecommerce_ui/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive cross axis count
    int crossAxisCount = 2;
    double childAspectRatio = 0.68; // Adjusted for better fit
    double spacing = 12;

    if (screenWidth < 360) {
      // Very small screens
      crossAxisCount = 2;
      childAspectRatio = 0.65;
      spacing = 10;
    } else if (screenWidth < 600) {
      // Small screens (phones)
      crossAxisCount = 2;
      childAspectRatio = 0.68;
      spacing = 12;
    } else if (screenWidth < 900) {
      // Medium screens (tablets)
      crossAxisCount = 3;
      childAspectRatio = 0.75;
      spacing = 16;
    } else {
      // Large screens
      crossAxisCount = 4;
      childAspectRatio = 0.8;
      spacing = 20;
    }

    return Obx(() {
      if (productController.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final products = productController.filteredProducts;

      if (products.isEmpty) {
        return const Center(
          child: Text('No products found'),
        );
      }

      return GridView.builder(
        padding: EdgeInsets.all(spacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(product: product),
              ),
            ),
            child: ProductCard(product: product),
          );
        },
      );
    });
  }
}
