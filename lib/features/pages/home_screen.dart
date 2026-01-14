import 'package:ecommerce_ui/controllers/theme_controller.dart';
import 'package:ecommerce_ui/controllers/auth_controller.dart';
import 'package:ecommerce_ui/controllers/navigation_controller.dart';
import 'package:ecommerce_ui/features/pages/all_products_screen.dart';
import 'package:ecommerce_ui/features/pages/cart_screen.dart';
import 'package:ecommerce_ui/features/notifications/view/notifications_screen.dart';
import 'package:ecommerce_ui/features/widgets/custom_search_bar.dart';
import 'package:ecommerce_ui/features/widgets/product_grid.dart';
import 'package:ecommerce_ui/features/widgets/animated_icon_button.dart';
import 'package:ecommerce_ui/features/widgets/animation_types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/category_chips.dart';
import '../widgets/sale_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // header section
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
              child: GetBuilder<AuthController>(
                builder: (authController) {
                  final user = authController.currentUser;
                  final firstName = user?.fullName.split(' ').first ?? 'User';

                  return Row(
                    children: [
                      // Profile Avatar
                      GestureDetector(
                        onTap: () {
                          final navController =
                              Get.find<NavigationController>();
                          navController.changeIndex(3);
                        },
                        child: CircleAvatar(
                          radius: isSmallScreen ? 18 : 20,
                          backgroundColor: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1),
                          backgroundImage: user?.profileImageUrl != null
                              ? NetworkImage(user!.profileImageUrl!)
                              : null,
                          child: user?.profileImageUrl == null
                              ? Text(
                                  _getInitials(user?.fullName ?? 'User'),
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),

                      // Greeting
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello $firstName',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _getGreeting(),
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Action Buttons
                      AnimatedIconButton(
                        icon: Icons.notifications_outlined,
                        onPressed: () => Get.to(() => NotificationsScreen()),
                        animationType: AnimationType.pulse,
                        tooltip: 'Notifications',
                        size: isSmallScreen ? 20 : 24,
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 8),
                      AnimatedIconButton(
                        icon: Icons.shopping_bag_outlined,
                        onPressed: () => Get.to(() => const CartScreen()),
                        animationType: AnimationType.scale,
                        tooltip: 'Shopping Cart',
                        size: isSmallScreen ? 20 : 24,
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 8),
                      GetBuilder<ThemeController>(
                        builder: (controller) => AnimatedIconButton(
                          icon: controller.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          onPressed: () => controller.toggleTheme(),
                          animationType: AnimationType.rotation,
                          tooltip: controller.isDarkMode
                              ? 'Light Mode'
                              : 'Dark Mode',
                          size: isSmallScreen ? 20 : 24,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // search bar
            const CustomSearchBar(),

            // category chips
            const CategoryChips(),

            // sale banner
            const SaleBanner(),

            // popular product
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12.0 : 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Product',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const AllProductsScreen()),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 8 : 12,
                        vertical: isSmallScreen ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'See All',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: isSmallScreen ? 10 : 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // product grid
            const Expanded(child: ProductGrid()),
          ],
        ),
      ),
    );
  }

  String _getInitials(String fullName) {
    final names = fullName.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'U';
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }
}
