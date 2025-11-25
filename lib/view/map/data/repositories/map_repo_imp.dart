import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_user/helper/network/base_api_service.dart';
import 'package:rider_pay_user/helper/network/network_api_service_http.dart';
import 'package:rider_pay_user/res/api_urls.dart';
import 'package:rider_pay_user/view/map/data/models/map_search_address_model.dart';
import 'package:rider_pay_user/view/map/domain/repositories/map_repo.dart';

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepositoryImpl(NetworkApiServices(ref));
});

class MapRepositoryImpl implements MapRepository {
  final BaseApiServices api;
  MapRepositoryImpl(this.api);

  @override
  Future<MapAddressModel> searchPlaces(String query) async {
    final url =
        "${MapUrls.baseUrl}${MapUrls.searchPlaceUrl}?input=$query&key=${MapUrls.mapKey}&components=country:in";
    final data = await api.getGetApiResponse(url);
    return MapAddressModel.fromJson(data);
  }

  @override
  Future<Map<String, dynamic>> placeDetails(String placeId) async {
    final url =
        "${MapUrls.baseUrl}${MapUrls.placeDetailsUrl}?placeid=$placeId&key=${MapUrls.mapKey}";
    final data = await api.getGetApiResponse(url);
    return data;
  }

  @override
  Future<Map<String, dynamic>> drawRoutePolyline(
    LatLng origin,
    LatLng destination,
  ) async {
    String url =
        "${MapUrls.baseUrl}${MapUrls.drawRouteUrl}?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${MapUrls.mapKey}&mode=driving";
    final data = await api.getGetApiResponse(url);
    return data;
  }

  @override
  Future<LatLng> snapToRoad(LatLng point) async {
    final url = "https://roads.googleapis.com/v1/snapToRoads?path=${point.latitude},${point.longitude}&key=${MapUrls.mapKey}&interpolate=false";
    final data = await api.getGetApiResponse(url);
    if (data['snappedPoints'] != null && data['snappedPoints'].isNotEmpty) {
      final snapped = data['snappedPoints'][0]['location'];
      return LatLng(snapped['latitude'], snapped['longitude']);
    }
    return point;
  }
}
