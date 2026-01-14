import 'package:ecommerce_ui/features/checkout/widgets/address_card.dart';
import 'package:ecommerce_ui/features/checkout/widgets/checkout_bottom_bar.dart';
import 'package:ecommerce_ui/features/checkout/widgets/order_summary_card.dart';
import 'package:ecommerce_ui/features/checkout/widgets/payment_method_card.dart';
import 'package:ecommerce_ui/features/order%20confirmation/screens/order_confirmation_screen.dart';
import 'package:ecommerce_ui/controllers/order_controller.dart';
import 'package:ecommerce_ui/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orderController = Get.find<OrderController>();
    final cartController = Get.find<CartController>();

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
          'Checkout',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Shipping Address'),
            const SizedBox(height: 16),
            const AddressCard(),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Payment Method'),
            const SizedBox(height: 16),
            const PaymentMethodCard(),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Order Summary'),
            const SizedBox(height: 16),
            const OrderSummaryCard(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => CheckoutBottomBar(
            totalAmount: cartController.totalAmount,
            onPlaceOrder: orderController.isLoading
                ? null
                : () async {
                    // Create order in database
                    final order = await orderController.createOrderFromCart();

                    if (order != null) {
                      // Navigate to confirmation screen
                      Get.to(
                        () => OrderConfirmationScreen(
                          orderNumber: order.orderNumber,
                          totalAmount: order.totalAmount,
                        ),
                        transition: Transition.fadeIn,
                      );
                    }
                  },
          )),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyle.withColor(
        AppTextStyle.h3,
        Theme.of(context).textTheme.bodyLarge!.color!,
      ),
    );
  }
}
