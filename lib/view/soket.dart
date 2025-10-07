// import 'package:rider_pay/res/api_urls.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:flutter/foundation.dart';
//
//
// class SocketService {
//   static final SocketService _instance = SocketService._internal();
//   IO.Socket? _socket;
//   bool _isConnected = false;
//
//   factory SocketService() {
//     return _instance;
//   }
//
//   SocketService._internal();
//
//   void connect() {
//     try {
//       _socket = IO.io(
//         // ApiUrls.baseUrl,
//         "https://shubhride.codescarts.com",
//         IO.OptionBuilder()
//             .setTransports(['websocket'])
//             .enableForceNew()
//             .disableAutoConnect()
//             .build(),
//       );
//
//       _setupSocketListeners();
//
//       _socket!.connect();
//     } catch (e) {
//       debugPrint('Socket connection error: $e');
//     }
//   }
//
//   void _setupSocketListeners() {
//     _socket!.onConnect((_) {
//       _isConnected = true;
//       //hit initial emit if needed
//     });
//
//     _socket!.onDisconnect((_) {
//       _isConnected = false;
//       debugPrint('Disconnected from server');
//       _reconnectSocket();
//     });
//     _socket!.onConnectError((error) {
//       _isConnected = false;
//       debugPrint('Connection Error: $error');
//       _reconnectSocket();
//     });
//     _socket!.onError((error) {
//       _isConnected = false;
//       debugPrint('Error: $error');
//       _reconnectSocket();
//     });
//   }
//
//   /// reconnect socket
//   void _reconnectSocket() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (!_isConnected && _socket?.connected == false) {
//         _socket?.connect();
//       }
//     });
//   }
//
//   /// Join (tell server I am online)
//   Future<void> joinUser(String driverId,String lat,String lng) async {
//     if (_socket != null && _socket!.connected) {
//       _socket!.emit("location_update", { 'driver_id':driverId, 'latitude':lat, 'longitude':lng});
//     }
//   }
//
//   // Event listeners
//   /// message history
//   void onMessageHistory(Function(dynamic) callback) {
//     _socket!.on("driver_location", (data) => callback(data));
//   }
//
//   /// disconnect server
//   void onDisconnectServer(Function(dynamic) callback) {
//     _socket!.on("disconnect", (data) {
//       _socket?.disconnect();
//       _socket = null;
//       _isConnected = false;
//       return callback(data);
//     });
//   }
//
//   bool get isConnected => _isConnected;
//   IO.Socket? get socket => _socket;
// }