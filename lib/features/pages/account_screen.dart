import 'package:ecommerce_ui/controllers/auth_controller.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';
import 'package:ecommerce_ui/features/my%20orders/my_orders_screen.dart';
import 'package:ecommerce_ui/features/auth/signin_screen.dart';
import 'package:ecommerce_ui/features/help%20center/views/screens/help_center_screen.dart';
import 'package:ecommerce_ui/features/pages/settings_screen.dart';
import 'package:ecommerce_ui/features/shipping%20address/shipping_address_screen.dart';
import 'package:ecommerce_ui/features/widgets/animated_button.dart';
import 'package:ecommerce_ui/features/widgets/animated_icon_button.dart';
import 'package:ecommerce_ui/features/widgets/user_info_card.dart';
import 'package:ecommerce_ui/features/widgets/animation_types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Account',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          AnimatedIconButton(
            icon: Icons.settings_outlined,
            onPressed: () => Get.to(() => const SettingsScreen()),
            color: isDark ? Colors.white : Colors.black,
            animationType: AnimationType.scale,
          ),
        ],
      ),
      body: GetBuilder<AuthController>(
        builder: (authController) {
          if (authController.currentUser == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading profile...'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const UserInfoCard(),
                _buildMenuSection(context),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final menuItems = [
      {'icon': Icons.shopping_bag_outlined, 'title': 'My Orders'},
      {'icon': Icons.location_on_outlined, 'title': 'Shipping Address'},
      {'icon': Icons.help_outline, 'title': 'Help Center'},
      {'icon': Icons.logout_outlined, 'title': 'Logout'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: menuItems.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(
                item['icon'] as IconData,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                item['title'] as String,
                style: AppTextStyle.withColor(
                  AppTextStyle.bodyMedium,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              onTap: () {
                if (item['title'] == 'Logout') {
                  _showLogoutDialog(context);
                } else if (item['title'] == 'My Orders') {
                  Get.to(() => MyOrdersScreen());
                } else if (item['title'] == 'Shipping Address') {
                  Get.to(() => ShippingAddressScreen());
                } else if (item['title'] == 'Help Center') {
                  Get.to(() => const HelpCenterScreen());
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout_rounded,
                color: Theme.of(context).primaryColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Logout',
              style: AppTextStyle.withColor(
                AppTextStyle.h3,
                Theme.of(context).textTheme.bodyLarge!.color!,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to logout?',
              textAlign: TextAlign.center,
              style: AppTextStyle.withColor(
                AppTextStyle.bodyMedium,
                isDark ? Colors.grey[400]! : Colors.grey[600]!,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AnimatedOutlinedButton(
                    text: 'Cancel',
                    onPressed: () => Get.back(),
                    borderColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    textColor: Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AnimatedElevatedButton(
                    text: 'Logout',
                    onPressed: () {
                      final AuthController authController =
                          Get.find<AuthController>();
                      authController.logout();
                      Get.offAll(() => SignInScreen());
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierColor: Colors.black54,
    );
  }
}
