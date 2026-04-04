part of 'nearest_cars_bloc.dart';

sealed class NearestCarsState extends Equatable {
  const NearestCarsState();

  @override
  List<Object?> get props => [];
}

final class NearestCarsInitial extends NearestCarsState {}

class GetNearestCarsLoading extends NearestCarsState {}

class GetNearestCarsLoadingMore extends NearestCarsState {
  final NearestCarsEntity nearestCarsEntity;

  const GetNearestCarsLoadingMore({required this.nearestCarsEntity});

  @override
  List<Object?> get props => [nearestCarsEntity];
}

class GetNearestCarsLoaded extends NearestCarsState {
  final NearestCarsEntity nearestCarsEntity;

  const GetNearestCarsLoaded({required this.nearestCarsEntity});

  @override
  List<Object?> get props => [nearestCarsEntity];
}

class GetNearestCarsError extends NearestCarsState {
  final String? errorMessage;

  const GetNearestCarsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage ?? ''];
}
