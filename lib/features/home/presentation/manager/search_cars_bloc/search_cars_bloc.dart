import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/home/data/models/params/get_search_cars_params.dart';
import 'package:qent_app/features/home/data/repositories/home_repository.dart';
import 'package:qent_app/features/home/domain/entities/best_car_entity.dart';
import 'package:qent_app/features/home/domain/entities/search_cars_entity.dart';

part 'search_cars_event.dart';
part 'search_cars_state.dart';

class SearchCarsBloc extends Bloc<SearchCarsEvent, SearchCarsState> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  GetSearchCarsParamsBody? _activeFilters;

  int get currentPage => _page;
  bool get hasMore => _hasMore;
  GetSearchCarsParamsBody? get activeFilters => _activeFilters;

  final List<BestCarEntity> _searchCars = [];

  SearchCarsBloc() : super(SearchCarsInitial()) {
    on<GetSearchCarsEvent>(_onGetSearchCars);
    on<ResetSearchCarsEvent>(_onResetSearchCars);
  }

  Future<void> _onGetSearchCars(
    GetSearchCarsEvent event,
    Emitter<SearchCarsState> emit,
  ) async {
    final incomingFilters = event.getSearchCarsParams?.body;

    if (incomingFilters != null) {
      final shouldRefresh =
          event.refresh || !_hasSameFilters(incomingFilters, _activeFilters);

      if (shouldRefresh) {
        _resetPagination(clearFilters: false);
      }

      _activeFilters = incomingFilters;
    } else if (event.refresh) {
      _resetPagination();
    }

    if (!_hasMore || _isLoading) return;

    _isLoading = true;

    if (_page == 1) {
      emit(GetSearchCarsLoading());
    } else {
      emit(
        GetSearchCarsLoadingMore(
          searchCarsEntity: SearchCarsEntity(
            data: List.from(_searchCars),
            currentPage: _page - 1,
            lastPage: null,
            nextPageUrl: null,
            hasMore: _hasMore,
          ),
        ),
      );
    }

    final params = GetSearchCarsParams(
      body: (_activeFilters ?? GetSearchCarsParamsBody()).copyWith(
        page: _page,
      ),
    );

    final res = await getIt<HomeRepository>().getSearchCars(params);

    _isLoading = false;

    res.fold(
      (l) => emit(GetSearchCarsError(errorMessage: l.errorMessage)),
      (r) {
        _searchCars.addAll(r.data ?? []);
        _hasMore = r.hasMore;
        _page++;

        emit(
          GetSearchCarsLoaded(
            searchCarsEntity: SearchCarsEntity(
              data: List.from(_searchCars),
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

  Future<void> _onResetSearchCars(
    ResetSearchCarsEvent event,
    Emitter<SearchCarsState> emit,
  ) async {
    _resetPagination();
    emit(SearchCarsInitial());
  }

  void _resetPagination({bool clearFilters = true}) {
    _page = 1;
    _hasMore = true;
    _isLoading = false;
    _searchCars.clear();

    if (clearFilters) {
      _activeFilters = null;
    }
  }

  bool _hasSameFilters(
    GetSearchCarsParamsBody? first,
    GetSearchCarsParamsBody? second,
  ) {
    if (first == null && second == null) return true;
    return first?.hasSameFilters(second) ?? false;
  }
}
