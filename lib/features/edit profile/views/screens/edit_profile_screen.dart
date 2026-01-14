import 'package:ecommerce_ui/features/edit%20profile/views/widgets/profile_form.dart';
import 'package:ecommerce_ui/features/edit%20profile/views/widgets/profile_image.dart';
import 'package:ecommerce_ui/features/widgets/animated_icon_button.dart';
import 'package:ecommerce_ui/features/widgets/animation_types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: AnimatedIconButton(
          icon: Icons.arrow_back_ios,
          onPressed: () => Get.back(),
          color: isDark ? Colors.white : Colors.black,
          animationType: AnimationType.scale,
        ),
        title: Text(
          'Edit Profile',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),
            ProfileImage(),
            SizedBox(height: 32),
            ProfileForm()
          ],
        ),
      ),
    );
  }
}
