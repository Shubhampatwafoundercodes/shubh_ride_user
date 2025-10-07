// abstract class BaseApiServices {
//   Future<dynamic> get(String url, {Map<String, dynamic>? queryParams, Map<String, String>? headers});
//   Future<dynamic> post(String url, {dynamic body, Map<String, String>? headers});
// }



abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);
  Future<dynamic> getPostApiResponse(String url, dynamic data);
}