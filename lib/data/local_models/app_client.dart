import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:map_location_routes/data/local_models/custom_excepcion_model.dart';

class AppClient {
  final Dio _dio;

  AppClient(this._dio);

  Future<Response> get(String url, {Map<String, String>? queryParameters}) async {
    if (await checkConnection()) {
      throw CustomException(statusCode: -1, message: 'Hubo un problema de conexión. Revisar y volver a intentar');
    }
    return await _dio.get(url, queryParameters: queryParameters);
  }

  Future<bool> checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.none;
  }
}