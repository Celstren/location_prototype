part of 'directions_bloc.dart';

abstract class DirectionsEvent extends Equatable {}

class FetchDirectionsEvent extends DirectionsEvent {

  final LatLng origin;
  final LatLng destination;

  FetchDirectionsEvent({required this.origin, required this.destination});

  @override
  String toString() => json.encode({
    'origin': origin,
    'destination': destination,
  });

  @override
  List<Object?> get props => [origin, destination];
}

class SetOriginEvent extends DirectionsEvent {
  @override
  List<Object?> get props => [];
}