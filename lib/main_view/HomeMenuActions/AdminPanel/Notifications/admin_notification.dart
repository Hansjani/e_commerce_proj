import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_notification_api.dart';
import 'package:flutter/material.dart';

class AdminNotification extends StatelessWidget {
  const AdminNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder(
        future: AdminNotificationAPI().getAdminNotification(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<AdminNotifications> notifications = snapshot.data!;
            if (notifications.isEmpty) {
              return const Center(
                child: Text('No notifications'),
              );
            } else {
              return AdminNotificationWidget(notifications: notifications);
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class AdminNotificationWidget extends StatelessWidget {
  const AdminNotificationWidget({
    super.key,
    required this.notifications,
  });

  final List<AdminNotifications> notifications;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        AdminNotifications notification = notifications[index];
        return AdminNotificationItem(
          notifications: notifications,
          notification: notification,
          index: index,
        );
      },
    );
  }
}

class AdminNotificationItem extends StatelessWidget {
  const AdminNotificationItem({
    super.key,
    required this.notifications,
    required this.notification,
    required this.index,
  });

  final int index;
  final List<AdminNotifications> notifications;
  final AdminNotifications notification;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notifications[index].id),
      onDismissed: (direction) {
        AdminNotificationAPI().deleteNotification(
          notification.id,
          (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            );
          },
        );
      },
      child: Card(
        child: ListTile(
          title: Text('Notification type : ${notification.type}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Text : ${notification.text}'),
              Text('Admin action : ${notification.status}'),
              Text('Notification status : ${notification.notificationStatus}'),
            ],
          ),
        ),
      ),
    );
  }
}
