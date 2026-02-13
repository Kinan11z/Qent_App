part of 'countries_bloc.dart';

sealed class CountriesEvent extends Equatable {
  const CountriesEvent();

  @override
  List<Object> get props => [];
}

class GetCountriesEvent extends CountriesEvent {
  final CountriesParams? countriesParams;

  const GetCountriesEvent({required this.countriesParams});
}
