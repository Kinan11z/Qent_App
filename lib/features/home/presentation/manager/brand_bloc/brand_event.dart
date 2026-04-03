part of 'brand_bloc.dart';

sealed class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object?> get props => [];
}

class GetBrandsEvent extends BrandEvent {
  final GetBrandsParams? getBrandsParams;

  const GetBrandsEvent({this.getBrandsParams});

  @override
  List<Object?> get props => [getBrandsParams];
}

class ResetBrandsEvent extends BrandEvent {
  const ResetBrandsEvent();
}
