part of 'best_cars_bloc.dart';

sealed class BestCarsState extends Equatable {
  const BestCarsState();

  @override
  List<Object?> get props => [];
}

final class BestCarsInitial extends BestCarsState {}

class GetBestCarsLoading extends BestCarsState {}

class GetBestCarsLoadingMore extends BestCarsState {
  final BestCarsEntity bestCarsEntity;

  const GetBestCarsLoadingMore({required this.bestCarsEntity});

  @override
  List<Object?> get props => [bestCarsEntity];
}

class GetBestCarsLoaded extends BestCarsState {
  final BestCarsEntity bestCarsEntity;

  const GetBestCarsLoaded({required this.bestCarsEntity});

  @override
  List<Object?> get props => [bestCarsEntity];
}

class GetBestCarsError extends BestCarsState {
  final String? errorMessage;

  const GetBestCarsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage ?? ''];
}
