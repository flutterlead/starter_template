import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:starter_template/main.dart';
import 'models/notification_info.dart';

abstract class NotificationHelperProtocol {
  Future<void> showNotification(NotificationInfo notificationData);

  Future<void> initialize();
}

class NotificationHelper implements NotificationHelperProtocol {
  static NotificationHelperProtocol instance = NotificationHelper._();
  static final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationHelper._();

  @override
  Future<void> showNotification(NotificationInfo notificationData) async {
    _localNotificationsPlugin.show(
      Random().nextInt(100000),
      notificationData.title,
      notificationData.subtitle,
      _getNotificationDetails(notificationData),
      payload: jsonEncode(notificationData.payLoad),
    );
  }

  @override
  Future<void> initialize() async {
    const iosSettings = DarwinInitializationSettings();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel_custom',
      'high_importance_channel_name',
      importance: Importance.max,
    );

    const AndroidNotificationChannel channelDefault = AndroidNotificationChannel(
      'default_channel',
      'default_channel_name',
      importance: Importance.none,
      enableLights: false,
      playSound: false,
      showBadge: false,
    );

    await _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    await _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channelDefault);

    await _localNotificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveBackgroundNotificationResponse: _handler,
      onDidReceiveNotificationResponse: _handler,
    );
  }

  static void _handler(NotificationResponse message) {
    Navigator.of(navigator.currentContext!).push(MaterialPageRoute(builder: (context) => const ScreenB()));
  }

  NotificationDetails _getNotificationDetails(NotificationInfo notificationInfo) {
    const iosNotificationDetails = DarwinNotificationDetails();

    final androidNotificationDetails = AndroidNotificationDetails(
      priority: Priority.high,
      importance: Importance.max,
      notificationInfo.channelId,
      notificationInfo.channelName,
      icon: '@mipmap/ic_launcher',
    );
    return NotificationDetails(
      iOS: iosNotificationDetails,
      android: androidNotificationDetails,
    );
  }
}
