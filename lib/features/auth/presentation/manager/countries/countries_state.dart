part of 'countries_bloc.dart';

sealed class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object> get props => [];
}

final class CountriesInitial extends CountriesState {}

class GetCountriesLoading extends CountriesState {}

// State جديد للـ pagination loading
class GetCountriesLoadingMore extends CountriesState {
  final CountriesEntity countriesEntity;

  const GetCountriesLoadingMore({required this.countriesEntity});

  @override
  List<Object> get props => [countriesEntity];
}

class GetCountriesLoaded extends CountriesState {
  final CountriesEntity countriesEntity;

  const GetCountriesLoaded({required this.countriesEntity});

  @override
  List<Object> get props => [countriesEntity];
}

class GetCountriesError extends CountriesState {
  final String? errorMessage;

  const GetCountriesError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage ?? ''];
}
