import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_user/view/map/data/models/map_search_address_model.dart';
import 'package:rider_pay_user/view/map/domain/repositories/map_repo.dart';
// ignore: unused_import
import 'package:rider_pay_user/view/map/presentation/controller/map_controller.dart';
import 'package:rider_pay_user/view/map/presentation/controller/state/map_state.dart' show LocationType;



class MapNotifierState {
  final bool isLoadingSearch;
  final bool isLoadingDetails;
  final MapAddressModel? mapAddressData;
  final Map<String, dynamic>? placeDetailsData;

  MapNotifierState({
    required this.isLoadingSearch,
    required this.isLoadingDetails,
    this.mapAddressData,
    this.placeDetailsData,
  });

  factory MapNotifierState.initial() => MapNotifierState(
    isLoadingSearch: false,
    isLoadingDetails: false,
    mapAddressData: null,
    placeDetailsData: null,
  );

  MapNotifierState copyWith({
    bool? isLoadingSearch,
    bool? isLoadingDetails,
    MapAddressModel? mapAddressData,
    Map<String, dynamic>? placeDetailsData,
  }) {
    return MapNotifierState(
      isLoadingSearch: isLoadingSearch ?? this.isLoadingSearch,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      mapAddressData: mapAddressData,
      placeDetailsData: placeDetailsData ?? this.placeDetailsData,
    );
  }
}

class MapNotifier extends StateNotifier<MapNotifierState>{
  final MapRepository _mapRepository;
  final Ref ref;
  MapNotifier(this._mapRepository, this.ref):super(MapNotifierState.initial());

  void resetSearchPlacesData() {
    state = state.copyWith(mapAddressData: null);
  }

  /// Search Places API
  Future<void> searchPlaces(String query) async {
    state = state.copyWith(isLoadingSearch: true, mapAddressData: null);
    try {
      final result = await _mapRepository.searchPlaces(query);
      state = state.copyWith(isLoadingSearch: false, mapAddressData: result);
    } catch (e) {
      state = state.copyWith(isLoadingSearch: false);
      debugPrint('Search error: $e');
    }
  }

  /// Place Details Api
  Future<LatLng?> placeDetails({
    required String placeId,
     LocationType? type,

}) async {
    state = state.copyWith(isLoadingDetails: true);
    try {
      final result = await _mapRepository.placeDetails(placeId);
      final lat = result['result']['geometry']['location']['lat'];
      final lng = result['result']['geometry']['location']['lng'];
      final latLng = LatLng(lat, lng);
      state = state.copyWith(isLoadingDetails: false, placeDetailsData: result,);
      return latLng;
    } catch (e) {
      state = state.copyWith(isLoadingDetails: false);
      debugPrint('Place details error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> drawRoutePolyline(
      LatLng origin, LatLng destination) async {
    try {
      final data =await _mapRepository.drawRoutePolyline(origin, destination);
      return data;
    } catch (e) {
      debugPrint("Polyline API error: $e");
      return null;
    }
  }
  /// Reset place details
  void resetPlaceDetails() {
    state = state.copyWith(placeDetailsData: null);
  }

}