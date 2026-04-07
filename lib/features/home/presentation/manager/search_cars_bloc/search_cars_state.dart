part of 'search_cars_bloc.dart';

sealed class SearchCarsState extends Equatable {
  const SearchCarsState();

  @override
  List<Object?> get props => [];
}

final class SearchCarsInitial extends SearchCarsState {}

class GetSearchCarsLoading extends SearchCarsState {}

class GetSearchCarsLoadingMore extends SearchCarsState {
  final SearchCarsEntity searchCarsEntity;

  const GetSearchCarsLoadingMore({required this.searchCarsEntity});

  @override
  List<Object?> get props => [searchCarsEntity];
}

class GetSearchCarsLoaded extends SearchCarsState {
  final SearchCarsEntity searchCarsEntity;

  const GetSearchCarsLoaded({required this.searchCarsEntity});

  @override
  List<Object?> get props => [searchCarsEntity];
}

class GetSearchCarsError extends SearchCarsState {
  final String? errorMessage;

  const GetSearchCarsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage ?? ''];
}
