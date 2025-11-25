// import 'dart:developer';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:rider_pay_user/main.dart';
// import 'package:rider_pay_user/utils/routes/routes_name.dart';
//
// // ✅ Same notification service as your working code
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// // ✅ Same channel configuration
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'app_channel',
//   'App Notifications',
//   description: 'This channel is used for important notifications.',
//   importance: Importance.max,
//   playSound: true,
//   sound: RawResourceAndroidNotificationSound('notification'),
//   enableVibration: true,
// );
//
// // ✅ Initialize Local Notifications (EXACTLY like your working code)
// Future<void> initLocalNotifications() async {
//   const AndroidInitializationSettings androidSettings =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
//     requestAlertPermission: true,
//     requestBadgePermission: true,
//     requestSoundPermission: true,
//   );
//
//   final InitializationSettings settings =
//   InitializationSettings(android: androidSettings, iOS: iosSettings);
//
//   await flutterLocalNotificationsPlugin.initialize(
//     settings,
//     onDidReceiveNotificationResponse: (details) {
//       log('Notification clicked: ${details.payload}');
//     },
//   );
//
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
// }
//
// // ✅ Background Handler (EXACTLY like your working code)
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // await Firebase.initializeApp();
//   log('📩 Background message received: ${message.messageId}');
//
//   // Initialize in background
//   await initLocalNotifications();
//
//   final notification = message.notification;
//   final data = message.data;
//
//   final title = notification?.title ?? data['title'] ?? 'New Notification';
//   final body = notification?.body ?? data['body'] ?? '';
//
//   if (title.isNotEmpty || body.isNotEmpty) {
//     await flutterLocalNotificationsPlugin.show(
//       message.hashCode,
//       title,
//       body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           importance: Importance.max,
//           priority: Priority.high,
//           playSound: true,
//           enableVibration: true,
//         ),
//         iOS: const DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       payload: message.data.toString(),
//     );
//   }
// }
//
// // ✅ FIXED Riverpod Provider
// final notificationProvider =
// StateNotifierProvider<NotificationNotifier, RemoteMessage?>(
//         (ref) => NotificationNotifier());
//
// class NotificationNotifier extends StateNotifier<RemoteMessage?> {
//   NotificationNotifier() : super(null) {
//     _init();
//   }
//
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   bool _isInitialized = false;
//
//   Future<void> _init() async {
//     if (_isInitialized) return;
//
//     try {
//       log('🚀 Initializing Riverpod notifications...');
//
//       // ✅ STEP 1: First initialize local notifications
//       await initLocalNotifications();
//
//       // ✅ STEP 2: Request permissions (EXACTLY like your working code)
//       NotificationSettings settings = await _messaging.requestPermission(
//         alert: true,
//         announcement: true,
//         badge: true,
//         carPlay: true,
//         criticalAlert: true,
//         provisional: true,
//         sound: true,
//       );
//
//       log('📱 Notification permission: ${settings.authorizationStatus}');
//
//       // ✅ STEP 3: Get FCM token
//       String? token = await _messaging.getToken();
//       log('🔥 FCM Token: $token');
//
//       // ✅ STEP 4: CRITICAL - Set foreground options (MISSING IN YOUR RIVERPOD CODE)
//       await _messaging.setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//
//       // ✅ STEP 5: Setup message handlers
//       _setupMessageHandlers();
//
//       _isInitialized = true;
//       log('✅ Riverpod notifications initialized successfully');
//
//     } catch (e) {
//       log('❌ Riverpod notification init error: $e');
//     }
//   }
//
//   void _setupMessageHandlers() {
//     // ✅ FOREGROUND MESSAGES - App is open
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       log('📩 FOREGROUND MESSAGE: ${message.messageId}');
//       log('📩 Data: ${message.data}');
//       log('📩 Notification: ${message.notification}');
//
//       // Show notification immediately
//       _showLocalNotification(message);
//
//       // Update state
//       state = message;
//
//       // Also show in-app notification (optional)
//       _showInAppSnackbar(message);
//     });
//
//     // ✅ BACKGROUND - App is in background, user taps notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log('📌 BACKGROUND TAP: ${message.messageId}');
//       _handleNotificationTap(message);
//       state = message;
//     });
//
//     // ✅ TERMINATED - App is closed, user taps notification
//     _messaging.getInitialMessage().then((RemoteMessage? message) {
//       if (message != null) {
//         log('🚀 TERMINATED STATE: App opened from notification');
//         _handleNotificationTap(message);
//         state = message;
//       }
//     });
//   }
//
//   // ✅ Show Local Notification (IMPROVED VERSION)
//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     try {
//       final notification = message.notification;
//       final data = message.data;
//
//       // Use the same logic as your working code
//       final title = notification?.title ?? data['title'] ?? 'Rider Pay';
//       final body = notification?.body ?? data['body'] ?? data['message'] ?? 'New notification';
//
//       log('🎯 Showing notification: $title - $body');
//
//       // Android Notification Details (SAME as your working code)
//       AndroidNotificationDetails androidNotificationDetails =
//       AndroidNotificationDetails(
//         channel.id,
//         channel.name,
//         channelDescription: "Channel Description",
//         importance: Importance.high,
//         priority: Priority.high,
//         playSound: true,
//         sound: channel.sound,
//         enableVibration: true,
//         showWhen: true,
//         autoCancel: true,
//       );
//
//       // iOS Notification Details (SAME as your working code)
//       DarwinNotificationDetails darwinNotificationDetails =
//       DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );
//
//       // Notification Details
//       NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails,
//         iOS: darwinNotificationDetails,
//       );
//
//       // Show notification (SAME as your working code)
//       await flutterLocalNotificationsPlugin.show(
//         message.hashCode,
//         title,
//         body,
//         notificationDetails,
//         payload: message.data.toString(),
//       );
//
//       log('✅ Riverpod notification shown successfully');
//
//     } catch (e) {
//       log('❌ Riverpod notification error: $e');
//     }
//   }
//
//   // ✅ Optional: Show in-app snackbar
//   void _showInAppSnackbar(RemoteMessage message) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (navigatorKey.currentContext != null) {
//         final title = message.notification?.title ?? 'New Notification';
//
//         ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
//           SnackBar(
//             content: Text('📱 $title'),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//     });
//   }
//
//   // ✅ Handle Notification Tap
//   void _handleNotificationTap(RemoteMessage message) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (navigatorKey.currentContext != null) {
//         final data = message.data;
//         final type = data['type'] ?? '';
//
//         log('📍 Handling notification tap: $type');
//
//         if (type == 'payment' || type == 'service_account') {
//           navigatorKey.currentState?.pushNamed(RouteName.notification);
//         } else if (type == 'ride') {
//           navigatorKey.currentState?.pushNamed(RouteName.rideDetails);
//         } else {
//           // Default navigation
//           navigatorKey.currentState?.pushNamed(RouteName.notification);
//         }
//       }
//     });
//   }
//
//   // ✅ Get FCM Token
//   Future<String?> getFCMToken() async {
//     try {
//       return await _messaging.getToken();
//     } catch (e) {
//       log('❌ Error getting FCM token: $e');
//       return null;
//     }
//   }
//
//   // ✅ Subscribe to topic
//   Future<void> subscribeToTopic(String topic) async {
//     try {
//       await _messaging.subscribeToTopic(topic);
//       log('✅ Subscribed to topic: $topic');
//     } catch (e) {
//       log('❌ Error subscribing to topic: $e');
//     }
//   }
//
//   // ✅ Unsubscribe from topic
//   Future<void> unsubscribeFromTopic(String topic) async {
//     try {
//       await _messaging.unsubscribeFromTopic(topic);
//       log('✅ Unsubscribed from topic: $topic');
//     } catch (e) {
//       log('❌ Error unsubscribing from topic: $e');
//     }
//   }
// }