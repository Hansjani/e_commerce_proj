import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppNotifications {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final _fcmNotification = FirebaseMessaging.instance;

  static void userInit() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(PrefsKeys.userName);
    log('user : ${username.toString()}');
    if(username != null){
      bool isInit = prefs.getBool(PrefsKeys.firstNotificationInit) ?? true;
      log('user first init : $isInit');
      if(isInit){
        log('first init');
        await _init(username);
        await prefs.setBool(PrefsKeys.firstNotificationInit, false);
      }else{
        log('not first init');
      }
    }else{
      log('no user');
    }
  }

  static _logout() async {
    final url = Uri.parse('http://192.168.29.184/app_db/init.php');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "fcmToken": null,
          "username": null,
        }),
        headers: {"Content-Type": "application/json"},
      );
      print(response.body);
      if (response.statusCode == 200) {
        _tokenSent = true; // Mark token as sent
      } else {
        throw Exception('Failed to send FCM token');
      }
    } catch (e) {
      print('Error sending FCM token: $e');
    }
  }

  static _init(String username) async {
    await _initializeFCM(username);
    _createChannel();
  }

  static Future<void> _initializeFCM(String username) async {
    await _fcmNotification.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final fcmToken = await _fcmNotification.getToken();
    if (fcmToken != null) {
      await _sendTokenToAPI(fcmToken,username);
    }
  }

  static bool _tokenSent = false;

  static bool get tokenSent => _tokenSent;

  static Future<void> _sendTokenToAPI(String fcmToken, String username) async {
    if (_tokenSent) {
      return;
    }
    final url = Uri.parse('http://192.168.29.184/app_db/init.php');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "fcmToken": fcmToken,
          "username": username,
        }),
        headers: {"Content-Type": "application/json"},
      );
      print(response.body);
      if (response.statusCode == 200) {
        _tokenSent = true; // Mark token as sent
      } else {
        throw Exception('Failed to send FCM token');
      }
    } catch (e) {
      print('Error sending FCM token: $e');
    }
  }

  static final List<String> _adminTopics = [
    'admin_notification',
    'order_item_update',
    'user_register',
  ];

   static final List<String> _userTopics = [
    'order_update_notification',
    'new_item_notification',
  ];

  static void subscribeToTopic(String userType) async {
    if (userType == 'admin') {
      for (var topic in _adminTopics) {
        await _fcmNotification.subscribeToTopic(topic);
      }
    } else {
      for (var topic in _userTopics) {
        await _fcmNotification.subscribeToTopic(topic);
      }
    }
  }

  static void unSubscribeAll(String userType) async {
    await _logout();
    if (userType == 'admin') {
      for (var topic in _adminTopics) {
        await _fcmNotification.unsubscribeFromTopic(topic);
      }
    } else {
      for (var topic in _userTopics) {
        await _fcmNotification.unsubscribeFromTopic(topic);
      }
    }
  }

  static void _createChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );
    _notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
            ),
          ),
        );
      }
    });
  }
}
