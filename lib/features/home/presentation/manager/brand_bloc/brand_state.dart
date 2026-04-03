part of 'brand_bloc.dart';

sealed class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object?> get props => [];
}

final class BrandInitial extends BrandState {}

class GetBrandsLoading extends BrandState {}

class GetBrandsLoadingMore extends BrandState {
  final BrandsEntity brandsEntity;

  const GetBrandsLoadingMore({required this.brandsEntity});

  @override
  List<Object?> get props => [brandsEntity];
}

class GetBrandsLoaded extends BrandState {
  final BrandsEntity brandsEntity;

  const GetBrandsLoaded({required this.brandsEntity});

  @override
  List<Object?> get props => [brandsEntity];
}

class GetBrandsError extends BrandState {
  final String? errorMessage;

  const GetBrandsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage ?? ''];
}
