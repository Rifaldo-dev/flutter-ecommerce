import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/controllers/auth_controller.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';
import 'package:ecommerce_ui/features/widgets/animated_button.dart';
import 'package:ecommerce_ui/features/edit%20profile/views/screens/edit_profile_screen.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<AuthController>(
      builder: (authController) {
        final user = authController.currentUser;

        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Profile Image
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    backgroundImage: user.profileImageUrl != null
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null
                        ? Text(
                            _getInitials(user.fullName),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : null,
                  ),
                  if (user.isLoggedIn)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).cardColor,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // User Name
              Text(
                user.fullName,
                style: AppTextStyle.withColor(
                  AppTextStyle.h2,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // User Email
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user.email,
                      style: AppTextStyle.withColor(
                        AppTextStyle.bodySmall,
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Phone Number (if available)
              if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        user.phoneNumber!,
                        style: AppTextStyle.withColor(
                          AppTextStyle.bodySmall,
                          isDark ? Colors.grey[400]! : Colors.grey[600]!,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Edit Profile Button
              AnimatedElevatedButton(
                text: 'Edit Profile',
                icon: const Icon(Icons.edit_outlined,
                    size: 18, color: Colors.white),
                onPressed: () => Get.to(() => const EditProfileScreen()),
                backgroundColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                width: double.infinity,
              ),
            ],
          ),
        );
      },
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
}
