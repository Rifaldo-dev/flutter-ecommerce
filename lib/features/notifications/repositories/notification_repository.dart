import 'package:ecommerce_ui/features/notifications/models/notification_type.dart';

class NotificationRepository {
  List<NotificationItem> getNotifications() {
    return const[
      NotificationItem(
        title: 'Order Confirmed!',
        message: 'Your order #12345 has been confirmed and is being processed.',
        time: '2 minutes ago',
        type: NotificationType.order,
      ),
      NotificationItem(
        title: 'Special Offer!',
        message: 'Get 20% off on all shoes this weekend!',
        time: '1 hour ago',
        type: NotificationType.promo,
        isRead: true,
      ),
      NotificationItem(
        title: 'Out for Delivery',
        message: 'Your order #12344 is out for delivery.',
        time: '3 hours ago',
        type: NotificationType.delivery,
        isRead: true,
      ),
      NotificationItem(
        title: 'Payment Successful',
        message: 'Payment for order #12345 was successful.',
        time: '5 hours ago',
        type: NotificationType.payment,
        isRead: true,
      ),
    ];
  }
}
