import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/home/data/models/params/get_brands_params.dart';
import 'package:qent_app/features/home/data/repositories/home_repository.dart';
import 'package:qent_app/features/home/domain/entities/brand_entity.dart';
import 'package:qent_app/features/home/domain/entities/brands_entity.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  int get currentPage => _page;
  bool get hasMore => _hasMore;

  final List<BrandEntity> _brands = [];

  BrandBloc() : super(BrandInitial()) {
    on<GetBrandsEvent>(_onGetBrands);
    on<ResetBrandsEvent>(_onResetBrands);
  }

  Future<void> _onGetBrands(
    GetBrandsEvent event,
    Emitter<BrandState> emit,
  ) async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;

    if (_page == 1) {
      emit(GetBrandsLoading());
    } else {
      emit(
        GetBrandsLoadingMore(
          brandsEntity: BrandsEntity(
            data: List.from(_brands),
            currentPage: _page - 1,
            lastPage: null,
            nextPageUrl: null,
            hasMore: _hasMore,
          ),
        ),
      );
    }

    final params = event.getBrandsParams ?? GetBrandsParams(
      body: GetBrandsParamsBody(page: _page),
    );

    final res = await getIt<HomeRepository>().getBrands(params);

    _isLoading = false;

    res.fold(
      (l) => emit(GetBrandsError(errorMessage: l.errorMessage)),
      (r) {
        _brands.addAll(r.data ?? []);
        _hasMore = r.hasMore;
        _page++;

        emit(
          GetBrandsLoaded(
            brandsEntity: BrandsEntity(
              data: List.from(_brands),
              currentPage: r.currentPage,
              lastPage: r.lastPage,
              nextPageUrl: r.nextPageUrl,
              hasMore: _hasMore,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onResetBrands(
    ResetBrandsEvent event,
    Emitter<BrandState> emit,
  ) async {
    _page = 1;
    _hasMore = true;
    _isLoading = false;
    _brands.clear();
    emit(BrandInitial());
  }
}
