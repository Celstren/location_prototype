import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_routes/bloc/directions_bloc/directions_bloc.dart';
import 'package:map_location_routes/data/external_models/directions_view_model.dart';
import 'package:map_location_routes/data/local_models/app_client.dart';
import 'package:map_location_routes/services/providers/directions_provider.dart';
import 'package:map_location_routes/services/repositories/directions_repository.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;
  late DirectionsBloc _directionsBloc;
  var _loading = false;

  @override
  void initState() {
    final _dio = Dio();
    final _client = AppClient(_dio);
    final _provider = DirectionsProvider(_client);
    final _repository = DirectionsRepository(_provider);
    _directionsBloc = DirectionsBloc(_repository);
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    _directionsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DirectionsBloc, DirectionsState>(
        builder: (BuildContext context, DirectionsState state) {
      DirectionsViewModel? _directionsViewModel;
      if (state is FetchDirectionsSuccessState) {
        _loading = false;
        _directionsViewModel = state.directionsViewModel;
      } else if (state is SetOriginSuccessState) {
        _loading = false;
        _directionsViewModel = null;
      } else if (state is FetchDirectionsLoadingState) {
        _loading = true;
      } else if (state is DirectionsErrorState) {
        _loading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
          ),
        );
      } else if (state is DirectionsConnectionErrorState) {
        _loading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
          ),
        );
      } else if (state is DirectionsUnauthorizedState) {
        _loading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hubo un problema con las credenciales'),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Google Maps'),
          actions: [
            if (_origin != null)
              TextButton(
                onPressed: () => _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _origin!.position,
                      zoom: 14.5,
                      tilt: 50.0,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.green,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                child: const Text('ORIGIN'),
              ),
            if (_destination != null)
              TextButton(
                onPressed: () => _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _destination!.position,
                      zoom: 14.5,
                      tilt: 50.0,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                child: const Text('DEST'),
              )
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) => _googleMapController = controller,
              markers: {
                if (_origin != null) _origin!,
                if (_destination != null) _destination!,
              },
              polylines: {
                if (_directionsViewModel != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 5,
                    points: _directionsViewModel.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },
              onLongPress: _addMarker,
            ),
            if (_directionsViewModel != null)
              Positioned(
                top: 20.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: Text(
                    '${_directionsViewModel.totalDistance}, ${_directionsViewModel.totalDuration}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (_loading)
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(.25),
                child: const Center(
                  child: Text(
                    'Cargando direcciones...',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          onPressed: () => _googleMapController.animateCamera(
            _directionsViewModel != null
                ? CameraUpdate.newLatLngBounds(
                    _directionsViewModel.bounds, 100.0)
                : CameraUpdate.newCameraPosition(_initialCameraPosition),
          ),
          child: const Icon(Icons.center_focus_strong),
        ),
      );
    });
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      );
      _destination = null;
      _directionsBloc.add(SetOriginEvent());
    } else {
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: pos,
      );
      _directionsBloc.add(FetchDirectionsEvent(
          origin: _origin!.position, destination: _destination!.position));
    }
  }
}
