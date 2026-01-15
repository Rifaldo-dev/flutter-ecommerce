import 'package:get/get.dart';
import 'package:ecommerce_ui/features/notifications/models/notification_type.dart';
import 'package:ecommerce_ui/features/notifications/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _repository = NotificationRepository();

  final RxList<NotificationItem> _notifications = <NotificationItem>[].obs;
  final RxInt _unreadCount = 0.obs;

  List<NotificationItem> get notifications => _notifications;
  int get unreadCount => _unreadCount.value;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    _notifications.value = _repository.getNotifications();
    _updateUnreadCount();
  }

  void _updateUnreadCount() {
    _unreadCount.value =
        _notifications.where((notification) => !notification.isRead).length;
  }

  void markAsRead(int index) {
    if (index >= 0 && index < _notifications.length) {
      final notification = _notifications[index];
      _notifications[index] = NotificationItem(
        title: notification.title,
        message: notification.message,
        time: notification.time,
        type: notification.type,
        isRead: true,
      );
      _updateUnreadCount();
    }
  }

  void markAllAsRead() {
    _notifications.value = _notifications
        .map((notification) => NotificationItem(
              title: notification.title,
              message: notification.message,
              time: notification.time,
              type: notification.type,
              isRead: true,
            ))
        .toList();
    _updateUnreadCount();
    Get.snackbar(
      'Success',
      'All notifications marked as read',
      snackPosition: SnackPosition.TOP,
    );
  }

  void clearAll() {
    _notifications.clear();
    _updateUnreadCount();
    Get.snackbar(
      'Success',
      'All notifications cleared',
      snackPosition: SnackPosition.TOP,
    );
  }
}
