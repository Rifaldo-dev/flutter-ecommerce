import 'package:ecommerce_ui/utils/app_textstyles.dart';
import 'package:ecommerce_ui/features/widgets/category_chips.dart';
import 'package:ecommerce_ui/features/widgets/product_grid.dart';
import 'package:ecommerce_ui/features/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Shopping',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => FilterBottomSheet.show(context),
          ),
        ],
      ),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: CategoryChips(),
          ),
          Expanded(child: ProductGrid()),
        ],
      ),
    );
  }
}
