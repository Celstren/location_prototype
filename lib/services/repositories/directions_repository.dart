import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_routes/data/external_models/directions_view_model.dart';
import 'package:map_location_routes/services/providers/directions_provider.dart';

class DirectionsRepository {
  final DirectionsProvider _directionsProvider;

  DirectionsRepository(this._directionsProvider);

  Future<DirectionsViewModel?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) => _directionsProvider.getDirections(origin: origin, destination: destination);
}