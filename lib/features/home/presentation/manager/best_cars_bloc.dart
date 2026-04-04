import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/home/data/models/params/get_best_cars_params.dart';
import 'package:qent_app/features/home/data/repositories/home_repository.dart';
import 'package:qent_app/features/home/domain/entities/best_car_entity.dart';
import 'package:qent_app/features/home/domain/entities/best_cars_entity.dart';

part 'best_cars_event.dart';
part 'best_cars_state.dart';

class BestCarsBloc extends Bloc<BestCarsEvent, BestCarsState> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  int get currentPage => _page;
  bool get hasMore => _hasMore;

  final List<BestCarEntity> _bestCars = [];

  BestCarsBloc() : super(BestCarsInitial()) {
    on<GetBestCarsEvent>(_onGetBestCars);
    on<ResetBestCarsEvent>(_onResetBestCars);
  }

  Future<void> _onGetBestCars(
    GetBestCarsEvent event,
    Emitter<BestCarsState> emit,
  ) async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;

    if (_page == 1) {
      emit(GetBestCarsLoading());
    } else {
      emit(
        GetBestCarsLoadingMore(
          bestCarsEntity: BestCarsEntity(
            data: List.from(_bestCars),
            currentPage: _page - 1,
            lastPage: null,
            nextPageUrl: null,
            hasMore: _hasMore,
          ),
        ),
      );
    }

    final params = event.getBestCarsParams ??
        GetBestCarsParams(
          body: GetBestCarsParamsBody(page: _page),
        );

    final res = await getIt<HomeRepository>().getBestCars(params);

    _isLoading = false;

    res.fold(
      (l) => emit(GetBestCarsError(errorMessage: l.errorMessage)),
      (r) {
        _bestCars.addAll(r.data ?? []);
        _hasMore = r.hasMore;
        _page++;

        emit(
          GetBestCarsLoaded(
            bestCarsEntity: BestCarsEntity(
              data: List.from(_bestCars),
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

  Future<void> _onResetBestCars(
    ResetBestCarsEvent event,
    Emitter<BestCarsState> emit,
  ) async {
    _page = 1;
    _hasMore = true;
    _isLoading = false;
    _bestCars.clear();
    emit(BestCarsInitial());
  }
}
