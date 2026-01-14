import 'package:ecommerce_ui/controllers/auth_controller.dart';
import 'package:ecommerce_ui/controllers/theme_controller.dart';
import 'package:ecommerce_ui/controllers/product_controller.dart';
import 'package:ecommerce_ui/controllers/cart_controller.dart';
import 'package:ecommerce_ui/controllers/favorites_controller.dart';
import 'package:ecommerce_ui/controllers/order_controller.dart';
import 'package:ecommerce_ui/utils/app_themes.dart';
import 'package:ecommerce_ui/features/pages/splash_screen.dart';
import 'package:ecommerce_ui/config/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Test .env loading first
  print('=== TESTING .ENV LOADING ===');
  try {
    await dotenv.load(fileName: ".env");
    print('ENV loaded successfully');
    print('SUPABASE_URL: ${dotenv.env['SUPABASE_URL']}');
    print(
        'SUPABASE_ANON_KEY length: ${dotenv.env['SUPABASE_ANON_KEY']?.length ?? 0}');
    print(
        'SUPABASE_ANON_KEY starts with: ${dotenv.env['SUPABASE_ANON_KEY']?.substring(0, 20) ?? 'NULL'}...');
  } catch (e) {
    print('ENV loading error: $e');
  }

  // Initialize Supabase
  try {
    await SupabaseConfig.initialize();
  } catch (e) {
    print('Supabase init error: $e');
  }

  // Initialize Controllers
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(ProductController());
  Get.put(CartController());
  Get.put(FavoritesController());
  Get.put(OrderController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fashion Store',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeController.theme,
      defaultTransition: Transition.fade,
      home: SplashScreen(),
    );
  }
}
