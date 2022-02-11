import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_routes/config/prod_config.dart';
import 'package:map_location_routes/data/external_models/directions_view_model.dart';
import 'package:map_location_routes/data/local_models/app_client.dart';
import 'package:map_location_routes/data/local_models/custom_excepcion_model.dart';

class DirectionsProvider {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final AppClient _dio;

  DirectionsProvider(this._dio);

  Future<DirectionsViewModel?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': ProdConfig.googleApiKey,
      },
    );

    if (response.statusCode == 200) {
      return DirectionsViewModel.fromMap(response.data);
    }
    throw CustomException(message: 'Hubo un problema al solicitar las direcciones: ${response.statusMessage}', statusCode: response.statusCode!);
  }
}