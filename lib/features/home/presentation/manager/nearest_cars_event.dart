part of 'nearest_cars_bloc.dart';

sealed class NearestCarsEvent extends Equatable {
  const NearestCarsEvent();

  @override
  List<Object?> get props => [];
}

class GetNearestCarsEvent extends NearestCarsEvent {
  final GetNearestCarsParams? getNearestCarsParams;

  const GetNearestCarsEvent({this.getNearestCarsParams});

  @override
  List<Object?> get props => [getNearestCarsParams];
}

class ResetNearestCarsEvent extends NearestCarsEvent {
  const ResetNearestCarsEvent();
}
