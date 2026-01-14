import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/controllers/navigation_controller.dart';
import 'package:ecommerce_ui/features/widgets/animated_icon_button.dart';
import 'package:ecommerce_ui/features/widgets/animation_types.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
        Get.put(NavigationController());
    final theme = Theme.of(context);

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color:
              theme.bottomNavigationBarTheme.backgroundColor ?? theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  Icons.home_outlined,
                  Icons.home,
                  'Home',
                  0,
                  navigationController,
                ),
                _buildNavItem(
                  context,
                  Icons.shopping_bag_outlined,
                  Icons.shopping_bag,
                  'Shopping',
                  1,
                  navigationController,
                ),
                _buildNavItem(
                  context,
                  Icons.favorite_outline,
                  Icons.favorite,
                  'Wishlist',
                  2,
                  navigationController,
                ),
                _buildNavItem(
                  context,
                  Icons.person_outline,
                  Icons.person,
                  'Account',
                  3,
                  navigationController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData outlineIcon,
    IconData filledIcon,
    String label,
    int index,
    NavigationController controller,
  ) {
    final isSelected = controller.currentIndex.value == index;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedIconButton(
              icon: isSelected ? filledIcon : outlineIcon,
              onPressed: () => controller.changeIndex(index),
              color: isSelected
                  ? theme.primaryColor
                  : theme.iconTheme.color?.withOpacity(0.6),
              size: 24,
              animationType: AnimationType.scale,
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? theme.primaryColor
                    : theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
