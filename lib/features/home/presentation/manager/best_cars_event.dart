part of 'best_cars_bloc.dart';

sealed class BestCarsEvent extends Equatable {
  const BestCarsEvent();

  @override
  List<Object?> get props => [];
}

class GetBestCarsEvent extends BestCarsEvent {
  final GetBestCarsParams? getBestCarsParams;

  const GetBestCarsEvent({this.getBestCarsParams});

  @override
  List<Object?> get props => [getBestCarsParams];
}

class ResetBestCarsEvent extends BestCarsEvent {
  const ResetBestCarsEvent();
}
