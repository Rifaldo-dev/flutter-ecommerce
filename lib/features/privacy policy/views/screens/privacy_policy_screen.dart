import 'package:ecommerce_ui/features/privacy%20policy/views/widgets/info_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;

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
          'Privacy Policy',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoSection(
                title: 'Information We Collect',
                content: 'We collect information that you provide directly to us, including name, email address, and shipping information.',
              ),
              const InfoSection(
                title: 'How We Use Your Information',
                content: 'We use the information we collect to provide, maintain, and improve our services, process your transactions, and send you updates.',
              ),
              const InfoSection(
                title: 'Information Sharing',
                content: 'We do not sell or share your personal information with third parties except as described in this policy.',
              ),
              const InfoSection(
                title: 'Data Security',
                content: 'We implement appropriate security measures to protect your personal information from unauthorized access or disclosure.',
              ),
              const InfoSection(
                title: 'Your Rights',
                content: 'You have the right to access, correct, or delete your personal information. Contact us to exercise these rights.',
              ),
              const InfoSection(
                title: 'Cookie Policy',
                content: 'We use cookies and similar technologies to enhance your experience and collect usage information.',
              ),
              const SizedBox(height: 24),
              Text(
                'Last updated: March 2024',
                style: AppTextStyle.withColor(
                  AppTextStyle.bodySmall,
                  isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
