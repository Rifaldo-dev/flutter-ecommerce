import 'package:ecommerce_ui/features/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';
import 'package:ecommerce_ui/features/widgets/filter_bottom_sheet.dart';
import 'package:ecommerce_ui/controllers/product_controller.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  void _showSearchDialog(BuildContext context) {
    final productController = Get.find<ProductController>();
    final TextEditingController searchController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        title: Text(
          'Search Products',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        content: TextField(
          controller: searchController,
          autofocus: true,
          style: AppTextStyle.withColor(
            AppTextStyle.bodyMedium,
            isDark ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Enter product name...',
            hintStyle: AppTextStyle.withColor(
              AppTextStyle.bodyMedium,
              isDark ? Colors.grey[400]! : Colors.grey[600]!,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              productController.searchProducts(query);
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyle.withColor(
                AppTextStyle.buttonMedium,
                isDark ? Colors.grey[400]! : Colors.grey[600]!,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final query = searchController.text.trim();
              if (query.isNotEmpty) {
                productController.searchProducts(query);
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Search',
              style: AppTextStyle.withColor(
                AppTextStyle.buttonMedium,
                Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'All Products',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          // Search icon
          IconButton(
            icon: Icon(
              Icons.search,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => _showSearchDialog(context),
          ),
          // Filter icon
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => FilterBottomSheet.show(context),
          ),
        ],
      ),
      body: const ProductGrid(),
    );
  }
}
