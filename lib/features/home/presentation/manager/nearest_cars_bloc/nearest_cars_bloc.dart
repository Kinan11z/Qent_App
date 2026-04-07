import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/home/data/models/params/get_nearest_cars_params.dart';
import 'package:qent_app/features/home/data/repositories/home_repository.dart';
import 'package:qent_app/features/home/domain/entities/best_car_entity.dart';
import 'package:qent_app/features/home/domain/entities/nearest_cars_entity.dart';

part 'nearest_cars_event.dart';
part 'nearest_cars_state.dart';

class NearestCarsBloc extends Bloc<NearestCarsEvent, NearestCarsState> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  int get currentPage => _page;
  bool get hasMore => _hasMore;

  final List<BestCarEntity> _nearestCars = [];

  NearestCarsBloc() : super(NearestCarsInitial()) {
    on<GetNearestCarsEvent>(_onGetNearestCars);
    on<ResetNearestCarsEvent>(_onResetNearestCars);
  }

  Future<void> _onGetNearestCars(
    GetNearestCarsEvent event,
    Emitter<NearestCarsState> emit,
  ) async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;

    if (_page == 1) {
      emit(GetNearestCarsLoading());
    } else {
      emit(
        GetNearestCarsLoadingMore(
          nearestCarsEntity: NearestCarsEntity(
            data: List.from(_nearestCars),
            currentPage: _page - 1,
            lastPage: null,
            nextPageUrl: null,
            hasMore: _hasMore,
          ),
        ),
      );
    }

    final params = event.getNearestCarsParams ??
        GetNearestCarsParams(
          body: GetNearestCarsParamsBody(page: _page),
        );

    final res = await getIt<HomeRepository>().getNearestCars(params);

    _isLoading = false;

    res.fold(
      (l) => emit(GetNearestCarsError(errorMessage: l.errorMessage)),
      (r) {
        _nearestCars.addAll(r.data ?? []);
        _hasMore = r.hasMore;
        _page++;

        emit(
          GetNearestCarsLoaded(
            nearestCarsEntity: NearestCarsEntity(
              data: List.from(_nearestCars),
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

  Future<void> _onResetNearestCars(
    ResetNearestCarsEvent event,
    Emitter<NearestCarsState> emit,
  ) async {
    _page = 1;
    _hasMore = true;
    _isLoading = false;
    _nearestCars.clear();
    emit(NearestCarsInitial());
  }
}
