import 'dart:convert';
import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Constants/placeholders.dart';

class AdminNotifications {
  final int id;
  final String type;
  final String text;
  final String status;
  final String createdAt;
  final String username;
  String notificationStatus;

  AdminNotifications(
      {required this.id,
      required this.type,
      required this.text,
      required this.status,
      required this.createdAt,
      required this.username,
      required this.notificationStatus});

  factory AdminNotifications.fromJson(Map<String, dynamic> json) {
    return AdminNotifications(
      id: json['id'],
      type: json['type'],
      text: json['text'],
      status: json['status'],
      createdAt: json['created_at'],
      username: json['username'],
      notificationStatus: json['notification_status'],
    );
  }
}

class AdminNotificationAPI {
  Future<List<AdminNotifications>> getAdminNotification() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);

    Uri url = Uri.parse(
        'http://${PlaceHolderImages.ip}/app_db/Admin_actions/admin_panel/notifications/recieve_notification.php?token=$token');
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<AdminNotifications> notifications = jsonResponse
          .map((json) => AdminNotifications.fromJson(json))
          .toList();
      return notifications;
    } else {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String error = jsonResponse['error'];
      throw Exception(error);
    }
  }

  Future<void> updateNotificationStatus(
    int id,
    void Function(String) callback,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);
    Uri url = Uri.parse(
        'http://${PlaceHolderImages.ip}/app_db/Admin_actions/admin_panel/notifications/recieve_notification.php?token=$token');
    final response = await http.post(
      url,
      body: jsonEncode({
        "status": "read",
        "id": id,
      }),
    );
    if (response.statusCode == 200) {
      String jsonResponse = jsonDecode(response.body)['message'];
      callback(jsonResponse);
    } else {
      String jsonResponse = jsonDecode(response.body)['error'];
      callback(jsonResponse);
    }
  }

  Future<void> deleteNotification(
    int id,
    void Function(String) callback,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);
    Uri url = Uri.parse(
        'http://${PlaceHolderImages.ip}/app_db/Admin_actions/admin_panel/notifications/recieve_notification.php?token=$token');
    final response = await http.delete(
      url,
      body: jsonEncode({
        "id": id,
      }),
    );
    if (response.statusCode == 200) {
      String jsonResponse = jsonDecode(response.body)['message'];
      callback(jsonResponse);
    } else {
      String jsonResponse = jsonDecode(response.body)['error'];
      callback(jsonResponse);
    }
  }
}

class AdminNotificationProvider with ChangeNotifier {
  final List<AdminNotifications> _notifications = [];
  final List<AdminNotifications> _newNotifications = [];

  List<AdminNotifications> get notifications => _notifications;

  List<AdminNotifications> get newNotifications => _newNotifications;

  void initialNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString(PrefsKeys.userType);
    if (userType == 'admin') {
      try {
        List<AdminNotifications> notifications =
            await AdminNotificationAPI().getAdminNotification();
        _notifications.clear();
        for (var notification in notifications) {
          addNotification(notification);
        }
        showNewNotifications();
        notifyListeners();
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  void addNotification(AdminNotifications adminNotifications) {
    if (!isInList(adminNotifications)) {
      notifications.add(adminNotifications);
    }
    notifyListeners();
  }

  int notificationIndex(AdminNotifications adminNotifications) {
    return _notifications.indexOf(adminNotifications);
  }

  void removeNotification(AdminNotifications adminNotifications) {
    _notifications.removeAt(notificationIndex(adminNotifications));
    notifyListeners();
  }

  bool isInList(AdminNotifications adminNotifications) {
    return _notifications
        .any((notification) => notification.id == adminNotifications.id);
  }

  bool isInNewList(AdminNotifications adminNotifications) {
    return _newNotifications
        .any((notification) => notification.id == adminNotifications.id);
  }

  int newNotificationIndex(AdminNotifications adminNotifications) {
    return _newNotifications.indexOf(adminNotifications);
  }

  void onRead(AdminNotifications adminNotifications) {
    final int index = newNotificationIndex(adminNotifications);
    if (index != -1) {
      _newNotifications.removeAt(index);
      adminNotifications.notificationStatus = 'read';
      notifyListeners();
    }
  }

  void showNewNotifications() {
    _newNotifications.clear();
    List<AdminNotifications> newNotifications = _notifications
        .where((notification) =>
            notification.notificationStatus.toLowerCase() == 'new')
        .toList();
    _newNotifications.addAll(newNotifications);
    notifyListeners();
  }

  Future<void> loadOnFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool firstAdminInit = prefs.getBool(PrefsKeys.firstAdminInit) ?? true;
    String? userType = prefs.getString(PrefsKeys.userType);
    if (userType == 'admin' && firstAdminInit) {
      initialNotifications();
      prefs.setBool(PrefsKeys.firstAdminInit, false);
    }
    notifyListeners();
  }
}
