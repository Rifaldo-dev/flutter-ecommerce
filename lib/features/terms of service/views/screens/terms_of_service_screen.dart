import 'package:ecommerce_ui/features/privacy%20policy/views/widgets/info_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
          'Terms of Service',
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
                title: 'Welcome to Fashion Store',
                content: 'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement.',
              ),
              const InfoSection(
                title: 'Account Registration',
                content: 'To use certain features of the application, you must register for an account. You agree to provide accurate information and keep it updated.',
              ),
              const InfoSection(
                title: 'User Responsibilities',
                content: 'You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
              ),
              const InfoSection(
                title: 'Privacy Policy',
                content: 'Your privacy is important to us. Please review our Privacy Policy to understand how we collect and use your information.',
              ),
              const InfoSection(
                title: 'Intellectual Property',
                content: 'All content included in this application is the property of Fashion Store or its content suppliers and protected by international copyright laws.',
              ),
              const InfoSection(
                title: 'Termination',
                content: 'We reserve the right to terminate or suspend your account and access to our services at our sole discretion, without notice.',
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
