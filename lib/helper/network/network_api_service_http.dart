// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rider_pay_user/helper/network/api_exception.dart';
import 'package:rider_pay_user/helper/network/base_api_service.dart';

import '../../view/share_pref/user_provider.dart' show userProvider;


// class NetworkApiServices extends BaseApiServices {
//   @override
//   Future getGetApiResponse(String url) async {
//     dynamic responseJson;
//     try {
//       final response = await http.get(Uri.parse(url))
//           .timeout(const Duration(seconds: 10));
//
//       if (kDebugMode) {
//         print('GET Api Url : $url');
//       }
//       responseJson = returnRequest(response);
//     } on SocketException {
//       throw FetchDataException('No Internet Connection');
//     }
//     return responseJson;
//   }
//
//   @override
//   Future getPostApiResponse(String url, dynamic data) async {
//     dynamic responseJson;
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json; charset=UTF-8'},
//         body: jsonEncode(data),
//       ).timeout(const Duration(seconds: 10));
//
//       if (kDebugMode) {
//         print('POST Api Url : $url');
//       }
//       responseJson = returnRequest(response);
//     } on SocketException {
//       throw FetchDataException('No Internet Connection');
//     }
//     return responseJson;
//   }
//
//   dynamic returnRequest(http.Response response) {
//     switch (response.statusCode) {
//       case 200:
//         final responseJson = jsonDecode(response.body);
//         if (kDebugMode) {
//           print('Response 200: $responseJson');
//         }
//         return responseJson;
//       case 400:
//         throw BadRequestException(response.body.toString());
//       case 404:
//         throw UnauthorisedException(response.body.toString());
//       case 500:
//       default:
//         throw FetchDataException(
//           'Error occurred while communicating with server, StatusCode: ${response.statusCode}',
//         );
//     }
//   }
// }


class NetworkApiServices extends BaseApiServices {
  final Ref _ref;
  NetworkApiServices(this._ref);
  /// GET request
  Map<String, String> _getHeadersWithToken() {
    final user = _ref.read(userProvider);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (user != null && user.token.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${user.token}';
    }
    return headers;
  }

  @override
  Future<Map<String, dynamic>> getGetApiResponse(String url, {Map<String, String>? headers}) async {
    try {
      // final requestHeaders = {
      //   'Content-Type': 'application/json; charset=UTF-8',
      //   if (headers != null) ...headers,
      // };
      final requestHeaders = _getHeadersWithToken();
      if (headers != null) {
        requestHeaders.addAll(headers);
      }
      final response = await http
          .get(Uri.parse(url), headers: requestHeaders)
          .timeout(const Duration(seconds: 10));

      return _returnRequest(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out');
    }
  }

  /// POST request
  @override
  Future<Map<String, dynamic>> getPostApiResponse(String url, dynamic data, {Map<String, String>? headers}) async {
    try {
      // final requestHeaders = {
      //   'Content-Type': 'application/json; charset=UTF-8',
      //   if (headers != null) ...headers,
      // };
      final requestHeaders = _getHeadersWithToken();
      if (headers != null) {
        requestHeaders.addAll(headers);
      }
      final response = await http
          .post(
        Uri.parse(url),
        headers: requestHeaders,
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 10));

      return _returnRequest(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request timed out');
    }
  }

  Map<String, dynamic> _returnRequest(http.Response response) {
    final status = response.statusCode;
    dynamic responseJson;

    try {
      responseJson = jsonDecode(response.body);
    } catch (_) {
      responseJson = response.body;
    }

    if (kDebugMode) {
      debugPrint('Status: $status, Response: $responseJson', wrapWidth: 1024);
    }

    switch (status) {
      case 200:
      case 201:
      case 202:
        return Map<String, dynamic>.from(responseJson);

      case 400:
        throw BadRequestException(responseJson.toString());

      case 401:
      case 403:
        _ref.read(userProvider.notifier).clearUser();
        throw UnauthorisedException("Unauthorised: $responseJson");

      case 404:
        throw NotFoundException("Resource not found: $responseJson");

      case 408:
        throw RequestTimeoutException("Request Timeout: $responseJson");

      case 409:
        throw ConflictException("Conflict: $responseJson");

      case 429:
        throw TooManyRequestsException("Too Many Requests: $responseJson");

      case 500:
        throw FetchDataException("Internal Server Error: $responseJson");

      case 502:
        throw FetchDataException("Bad Gateway: $responseJson");

      case 503:
        throw FetchDataException("Service Unavailable: $responseJson");

      case 504:
        throw FetchDataException("Gateway Timeout: $responseJson");

      default:
        throw FetchDataException("Unexpected Error. StatusCode: $status, Response: $responseJson");
    }
  }
}

