part of 'directions_bloc.dart';

abstract class DirectionsState extends Equatable {}

class DirectionsUninitializedState extends DirectionsState {
  @override
  List<Object?> get props => [];
}

class FetchDirectionsLoadingState extends DirectionsState {
  @override
  List<Object?> get props => [];
}

class FetchDirectionsSuccessState extends DirectionsState {

  final DirectionsViewModel directionsViewModel;

  FetchDirectionsSuccessState({required this.directionsViewModel});

  @override
  List<Object?> get props => [directionsViewModel];
}

class SetOriginSuccessState extends DirectionsState {
  @override
  List<Object?> get props => [];
}

class DirectionsErrorState extends DirectionsState {
  final String message;
  final String errorCode;

  DirectionsErrorState({this.message = '',this.errorCode = ''});

  @override
  List<Object?> get props => [message];
}

class DirectionsConnectionErrorState extends DirectionsState {
  final String message;

  DirectionsConnectionErrorState({this.message = ''});

  @override
  List<Object?> get props => [message];
}

class DirectionsUnauthorizedState extends DirectionsState {
  final String message;
  final String errorCode;

  DirectionsUnauthorizedState({this.message = '',this.errorCode = ''});

  @override
  List<Object?> get props => [message];
}