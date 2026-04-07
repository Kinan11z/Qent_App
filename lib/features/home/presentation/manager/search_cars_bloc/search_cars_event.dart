part of 'search_cars_bloc.dart';

sealed class SearchCarsEvent extends Equatable {
  const SearchCarsEvent();

  @override
  List<Object?> get props => [];
}

class GetSearchCarsEvent extends SearchCarsEvent {
  final GetSearchCarsParams? getSearchCarsParams;
  final bool refresh;

  const GetSearchCarsEvent({
    this.getSearchCarsParams,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [getSearchCarsParams, refresh];
}

class ResetSearchCarsEvent extends SearchCarsEvent {
  const ResetSearchCarsEvent();
}
