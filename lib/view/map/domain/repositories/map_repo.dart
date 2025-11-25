import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_user/view/map/data/models/map_search_address_model.dart';

abstract class MapRepository {
  Future<MapAddressModel> searchPlaces(String query);

  Future<Map<String, dynamic>> placeDetails(String placeId);

  Future<Map<String, dynamic>> drawRoutePolyline(LatLng origin,LatLng destination);
  Future<LatLng> snapToRoad(LatLng points);
}
