import 'package:flutter/material.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';

class SaleBanner extends StatefulWidget {
  const SaleBanner({super.key});

  @override
  State<SaleBanner> createState() => _SaleBannerState();
}

class _SaleBannerState extends State<SaleBanner> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Main content
          isSmallScreen ? _buildVerticalLayout() : _buildHorizontalLayout(),

          // Close button - responsive positioning
          Positioned(
            top: isSmallScreen ? -6 : -8,
            right: isSmallScreen ? -6 : -8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isVisible = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: isSmallScreen ? 14 : 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Vertical layout for small screens
  Widget _buildVerticalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get Your',
              style: AppTextStyle.withColor(
                AppTextStyle.bodyMedium,
                Colors.white,
              ),
            ),
            Text(
              'Special Sale',
              style: AppTextStyle.withColor(
                AppTextStyle.withWeight(
                  AppTextStyle.h3,
                  FontWeight.bold,
                ),
                Colors.white,
              ),
            ),
            Text(
              'Up to 40%',
              style: AppTextStyle.withColor(
                AppTextStyle.bodyMedium,
                Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Button - full width on small screens
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: Text(
              'Shop Now',
              style: AppTextStyle.buttonMedium,
            ),
          ),
        ),
      ],
    );
  }

  // Horizontal layout for larger screens
  Widget _buildHorizontalLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get Your',
                style: AppTextStyle.withColor(
                  isMediumScreen ? AppTextStyle.bodyLarge : AppTextStyle.h3,
                  Colors.white,
                ),
              ),
              Text(
                'Special Sale',
                style: AppTextStyle.withColor(
                  AppTextStyle.withWeight(
                    isMediumScreen ? AppTextStyle.h3 : AppTextStyle.h2,
                    FontWeight.bold,
                  ),
                  Colors.white,
                ),
              ),
              Text(
                'Up to 40%',
                style: AppTextStyle.withColor(
                  isMediumScreen ? AppTextStyle.bodyLarge : AppTextStyle.h3,
                  Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: isMediumScreen ? 12 : 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(
              horizontal: isMediumScreen ? 12 : 16,
              vertical: isMediumScreen ? 10 : 12,
            ),
          ),
          child: Text(
            'Shop Now',
            style: isMediumScreen
                ? AppTextStyle.bodyMedium
                : AppTextStyle.buttonMedium,
          ),
        ),
      ],
    );
  }
}
