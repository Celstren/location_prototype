import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_routes/data/external_models/directions_view_model.dart';
import 'package:map_location_routes/data/local_models/custom_excepcion_model.dart';
import 'package:map_location_routes/services/repositories/directions_repository.dart';

part 'directions_event.dart';
part 'directions_state.dart';

class DirectionsBloc extends Bloc<DirectionsEvent, DirectionsState> {

  final DirectionsRepository _directionsRepository;

  DirectionsBloc(this._directionsRepository) : super(DirectionsUninitializedState()) {
    on<FetchDirectionsEvent>(_onFetchDirectionsEvent);
    on<SetOriginEvent>(_onResetDirectionsEvent);
  }

  void _onFetchDirectionsEvent(FetchDirectionsEvent event, Emitter<DirectionsState> emit) async {
    try {
      emit(FetchDirectionsLoadingState());
      var directions = await _directionsRepository.getDirections(origin: event.origin, destination: event.destination);
      emit(FetchDirectionsSuccessState(directionsViewModel: directions!));
    } on CustomException catch (e) {
      if (e.statusCode == -1) {
        emit(DirectionsConnectionErrorState(message: e.toString()));
      } else if (e.statusCode == 401) {
        emit(DirectionsUninitializedState());
      } else {
        emit(DirectionsErrorState(message: e.toString(), errorCode: e.statusCode.toString()));
      }
    } catch (e) {
      emit(DirectionsErrorState(message: e.toString()));
    }
  }

  void _onResetDirectionsEvent(SetOriginEvent event, Emitter<DirectionsState> emit) {
    emit(SetOriginSuccessState());
  }
}