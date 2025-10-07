// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:rider_pay/helper/network/api_exception.dart';
//
// import 'package:rider_pay/helper/network/base_api_service.dart';
//
//
// class DioApiServices extends BaseApiServices {
//   final Dio _dio = Dio(
//     BaseOptions(
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//       headers: {"Content-Type": "application/json"},
//     ),
//   );
//
//   @override
//   Future getGetApiResponse(String url) async {
//     try {
//       final uri = Uri.parse(url);
//
//       final response =
//       await _dio.get(uri.origin + uri.path, queryParameters: uri.queryParameters);
//
//       if (kDebugMode) {
//         print("GET Api Url: $url");
//         print("Query Params: ${uri.queryParameters}");
//       }
//       return _returnResponse(response);
//     } on SocketException {
//       throw FetchDataException("No Internet Connection");
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     }
//   }
//
//   @override
//   Future getPostApiResponse(String url, dynamic data) async {
//     try {
//       final uri = Uri.parse(url);
//
//       final response = await _dio.post(
//         uri.origin + uri.path,
//         data: data,
//         queryParameters: uri.queryParameters,
//       );
//
//       if (kDebugMode) {
//         print("POST Api Url: $url");
//         print("Body: $data");
//         print("Query Params: ${uri.queryParameters}");
//       }
//       return _returnResponse(response);
//     } on SocketException {
//       throw FetchDataException("No Internet Connection");
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     }
//   }
//
//   dynamic _returnResponse(Response response) {
//     switch (response.statusCode) {
//       case 200:
//         return response.data;
//       case 400:
//         throw BadRequestException(response.data.toString());
//       case 401:
//       case 403:
//       case 404:
//         throw UnauthorisedException(response.data.toString());
//       case 500:
//       default:
//         throw FetchDataException(
//             "Error occurred with StatusCode: ${response.statusCode}");
//     }
//   }
//
//   AppException _handleDioError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.sendTimeout:
//       case DioExceptionType.receiveTimeout:
//         return FetchDataException("Request Timeout");
//       case DioExceptionType.badResponse:
//         return FetchDataException(
//             "Invalid Response: ${error.response?.statusCode}");
//       case DioExceptionType.cancel:
//         return FetchDataException("Request Cancelled");
//       default:
//         return FetchDataException("Unexpected Error: ${error.message}");
//     }
//   }
// }
