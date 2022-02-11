import 'package:flutter/cupertino.dart';
import 'package:map_location_routes/views/map_view/map_view.dart';

class AppRoutes {
  static const String map = '/map';

  static Map<String, WidgetBuilder> routes(RouteSettings settings) {
    return <String, WidgetBuilder>{
      map: (BuildContext context) => const MapView(),
    };
  }
}