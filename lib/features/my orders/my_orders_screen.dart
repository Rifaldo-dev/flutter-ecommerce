import 'package:ecommerce_ui/features/my%20orders/model/order.dart';
import 'package:ecommerce_ui/features/my%20orders/widgets/order_card.dart';
import 'package:ecommerce_ui/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';

class MyOrdersScreen extends StatelessWidget {
  MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orderController = Get.find<OrderController>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
            'My Orders',
            style: AppTextStyle.withColor(
              AppTextStyle.h3,
              isDark ? Colors.white : Colors.black,
            ),
          ),
          bottom: TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey[600],
            indicatorColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList(context, OrderStatus.active),
            _buildOrderList(context, OrderStatus.completed),
            _buildOrderList(context, OrderStatus.cancelled),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, OrderStatus status) {
    final orderController = Get.find<OrderController>();

    return FutureBuilder<List<Order>>(
      future: orderController.getOrdersByStatus(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final orders = snapshot.data ?? [];

        if (orders.isEmpty) {
          return const Center(child: Text('No orders found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) => OrderCard(
            order: orders[index],
            onViewDetails: () {
              // Handle view details action
            },
          ),
        );
      },
    );
  }
}
