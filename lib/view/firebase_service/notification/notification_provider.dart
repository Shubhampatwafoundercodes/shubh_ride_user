// import 'dart:developer';
// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:rider_pay_user/main.dart';
// import 'package:rider_pay_user/utils/routes/routes_name.dart';
//
// // ✅ Initialize Flutter Local Notifications Plugin
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// // ✅ Notification Channel (HIGH PRIORITY)
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // DIFFERENT CHANNEL ID
//   'High Importance Notifications',
//   description: 'This channel is used for important notifications.',
//   importance: Importance.max,
//   priority: Priority.high,
//   playSound: true,
//   sound: RawResourceAndroidNotificationSound('notification'),
//   enableVibration: true,
//   vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
//   showBadge: true,
//   ledColor: Colors.blue,
// );
//
// // ✅ Initialize Local Notifications
// Future<void> initLocalNotifications() async {
//   try {
//     log('🔔 Initializing local notifications...');
//
//     // Android Settings
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     // iOS Settings
//     final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: (id, title, body, payload) async {
//         log('📱 iOS Local Notification: $title - $body');
//       },
//     );
//
//     final InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         log('🎯 Notification clicked: ${response.payload}');
//         // Handle notification click if needed
//       },
//     );
//
//     // Create notification channel for Android
//     final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
//     flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//
//     if (androidPlugin != null) {
//       await androidPlugin.createNotificationChannel(channel);
//       log('✅ Android notification channel created');
//     }
//
//     log('✅ Local notifications initialized successfully');
//   } catch (e) {
//     log('❌ Local notifications initialization error: $e');
//   }
// }
//
// // ✅ Background Message Handler
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   log('📩 BACKGROUND: Message received - ${message.messageId}');
//
//   // Initialize in background
//   await initLocalNotifications();
//
//   final notification = message.notification;
//   final data = message.data;
//
//   final title = notification?.title ?? data['title'] ?? 'Rider Pay';
//   final body = notification?.body ?? data['body'] ?? data['message'] ?? 'New notification';
//
//   if (title.isNotEmpty || body.isNotEmpty) {
//     try {
//       await flutterLocalNotificationsPlugin.show(
//         DateTime.now().millisecondsSinceEpoch.remainder(100000),
//         title,
//         body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channelDescription: channel.description,
//             importance: Importance.max,
//             priority: Priority.high,
//             playSound: true,
//             enableVibration: true,
//             styleInformation: BigTextStyleInformation(body),
//           ),
//           iOS: const DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//         ),
//         payload: message.data.toString(),
//       );
//       log('✅ Background notification shown');
//     } catch (e) {
//       log('❌ Background notification error: $e');
//     }
//   }
// }
//
// // ✅ Riverpod Provider
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
//       log('🚀 INITIALIZING RIVERPOD NOTIFICATIONS...');
//
//       // ✅ STEP 1: Initialize local notifications FIRST
//       await initLocalNotifications();
//
//       // ✅ STEP 2: Request permissions with detailed options
//       NotificationSettings settings = await _messaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//
//       log('📱 Permission status: ${settings.authorizationStatus}');
//
//       // ✅ STEP 3: Get FCM token
//       String? token = await _messaging.getToken();
//       log('🔥 FCM TOKEN: $token');
//
//       // ✅ STEP 4: CRITICAL - Enable auto init
//       await _messaging.setAutoInitEnabled(true);
//
//       // ✅ STEP 5: CRITICAL - Set foreground presentation options
//       await _messaging.setForegroundNotificationPresentationOptions(
//         alert: true, // MUST BE TRUE
//         badge: true, // MUST BE TRUE
//         sound: true, // MUST BE TRUE
//       );
//
//       // ✅ STEP 6: Setup message listeners
//       _setupMessageListeners();
//
//       // ✅ STEP 7: Token refresh listener
//       _messaging.onTokenRefresh.listen((newToken) {
//         log('🔄 Token refreshed: $newToken');
//       });
//
//       _isInitialized = true;
//       log('✅ RIVERPOD NOTIFICATIONS INITIALIZED SUCCESSFULLY');
//
//     } catch (e) {
//       log('❌ RIVERPOD INIT ERROR: $e');
//     }
//   }
//
//   void _setupMessageListeners() {
//     // ✅ FOREGROUND MESSAGES - App is open
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       log('📩 FOREGROUND MESSAGE RECEIVED');
//       log('📩 Message ID: ${message.messageId}');
//       log('📩 Data: ${message.data}');
//       log('📩 Notification Title: ${message.notification?.title}');
//       log('📩 Notification Body: ${message.notification?.body}');
//
//       // Update state immediately
//       state = message;
//
//       // Show local notification
//       await _showLocalNotification(message);
//
//       // Show in-app notification
//       _showInAppNotification(message);
//     });
//
//     // ✅ BACKGROUND - App is in background
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log('📌 BACKGROUND TAPPED: ${message.messageId}');
//       state = message;
//       _handleNotificationTap(message);
//     });
//
//     // ✅ TERMINATED - App is closed
//     _checkInitialMessage();
//   }
//
//   Future<void> _checkInitialMessage() async {
//     try {
//       RemoteMessage? initialMessage = await _messaging.getInitialMessage();
//       if (initialMessage != null) {
//         log('🚀 APP OPENED FROM TERMINATED STATE');
//         state = initialMessage;
//         _handleNotificationTap(initialMessage);
//       }
//     } catch (e) {
//       log('❌ Initial message error: $e');
//     }
//   }
//
//   // ✅ IMPROVED Local Notification Method
//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     try {
//       log('🎯 ATTEMPTING TO SHOW LOCAL NOTIFICATION...');
//
//       final notification = message.notification;
//       final data = message.data;
//
//       // Extract title and body
//       final title = notification?.title ?? data['title'] ?? 'Rider Pay';
//       final body = notification?.body ?? data['body'] ?? data['message'] ?? 'You have a new notification';
//
//       log('🎯 Notification Content - Title: $title, Body: $body');
//
//       // Android Notification Details
//       const androidDetails = AndroidNotificationDetails(
//         'high_importance_channel', // SAME CHANNEL ID
//         'High Importance Notifications', // SAME CHANNEL NAME
//         channelDescription: 'This channel is used for important notifications.',
//         importance: Importance.max,
//         priority: Priority.high,
//         playSound: true,
//         sound: RawResourceAndroidNotificationSound('notification'),
//         enableVibration: true,
//         vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
//         showWhen: true,
//         autoCancel: true,
//         styleInformation: BigTextStyleInformation(body),
//       );
//
//       // iOS Notification Details
//       const iosDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );
//
//       final details = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );
//
//       // Generate unique ID
//       final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
//
//       // Show notification
//       await flutterLocalNotificationsPlugin.show(
//         id,
//         title,
//         body,
//         details,
//         payload: message.data.toString(),
//       );
//
//       log('✅ LOCAL NOTIFICATION SHOWN SUCCESSFULLY - ID: $id');
//
//     } catch (e) {
//       log('❌ LOCAL NOTIFICATION FAILED: $e');
//     }
//   }
//
//   void _showInAppNotification(RemoteMessage message) {
//     try {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (navigatorKey.currentContext != null) {
//           final title = message.notification?.title ?? 'Rider Pay';
//
//           // Show snackbar
//           ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   Icon(Icons.notifications, color: Colors.white),
//                   SizedBox(width: 10),
//                   Expanded(child: Text(title)),
//                 ],
//               ),
//               backgroundColor: Colors.green[700],
//               behavior: SnackBarBehavior.floating,
//               margin: EdgeInsets.all(10),
//               duration: Duration(seconds: 3),
//               action: SnackBarAction(
//                 label: 'View',
//                 textColor: Colors.white,
//                 onPressed: () => _handleNotificationTap(message),
//               ),
//             ),
//           );
//
//           log('📱 In-app notification shown');
//         }
//       });
//     } catch (e) {
//       log('❌ In-app notification error: $e');
//     }
//   }
//
//   void _handleNotificationTap(RemoteMessage message) {
//     try {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (navigatorKey.currentContext != null) {
//           final data = message.data;
//           final type = data['type'] ?? '';
//
//           log('📍 HANDLING NOTIFICATION TAP: $type');
//
//           if (type == 'payment' || type == 'service_account') {
//             navigatorKey.currentState?.pushNamed(RouteName.notification);
//           } else if (type == 'ride') {
//             navigatorKey.currentState?.pushNamed(RouteName.rideDetails);
//           } else {
//             navigatorKey.currentState?.pushNamed(RouteName.notification);
//           }
//         }
//       });
//     } catch (e) {
//       log('❌ Notification tap error: $e');
//     }
//   }
//
//   // ✅ Get FCM Token
//   Future<String?> getFCMToken() async {
//     try {
//       return await _messaging.getToken();
//     } catch (e) {
//       log('❌ Token error: $e');
//       return null;
//     }
//   }
//
//   // ✅ Check if notifications are enabled
//   Future<bool> isNotificationsEnabled() async {
//     final settings = await _messaging.getNotificationSettings();
//     return settings.authorizationStatus == AuthorizationStatus.authorized;
//   }
//
//   // ✅ Subscribe to topic
//   Future<void> subscribeToTopic(String topic) async {
//     try {
//       await _messaging.subscribeToTopic(topic);
//       log('✅ Subscribed to topic: $topic');
//     } catch (e) {
//       log('❌ Topic subscribe error: $e');
//     }
//   }
//
//   // ✅ Unsubscribe from topic
//   Future<void> unsubscribeFromTopic(String topic) async {
//     try {
//       await _messaging.unsubscribeFromTopic(topic);
//       log('✅ Unsubscribed from topic: $topic');
//     } catch (e) {
//       log('❌ Topic unsubscribe error: $e');
//     }
//   }
// }