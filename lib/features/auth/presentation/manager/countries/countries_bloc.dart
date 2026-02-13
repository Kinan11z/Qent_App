import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/auth/data/model/params/countries_params.dart';
import 'package:qent_app/features/auth/data/repositories/auth_repository.dart';
import 'package:qent_app/features/auth/domain/entities/countries_entity.dart';
import 'package:qent_app/features/auth/domain/entities/country_entity.dart';

part 'countries_event.dart';
part 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  int get currentPage => _page;
  bool get hasMore => _hasMore;

  final List<CountryEntity> _countries = [];

  CountriesBloc() : super(CountriesInitial()) {
    on<GetCountriesEvent>(_onGetCountries);
  }

  Future<void> _onGetCountries(
    GetCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    // منع الطلبات المتكررة
    if (!_hasMore || _isLoading) return;

    _isLoading = true;

    // فقط للصفحة الأولى نعرض loading screen كامل
    if (_page == 1) {
      emit(GetCountriesLoading());
    } else {
      // للصفحات التانية، نبعث الحالة الحالية + مؤشر loading
      emit(GetCountriesLoadingMore(
        countriesEntity: CountriesEntity(
          data: List.from(_countries),
          currentPage: _page - 1,
          lastPage: null,
          nextPageUrl: null,
          hasMore: _hasMore,
        ),
      ));
    }

    final res = await getIt<AuthRepository>().getCountries(
      CountriesParams(
        body: CountriesParamsBody(page: _page),
      ),
    );

    _isLoading = false;

    res.fold(
      (l) => emit(GetCountriesError(errorMessage: l.errorMessage)),
      (r) {
        _countries.addAll(r.data ?? []);
        _hasMore = r.hasMore;
        _page++;

        emit(
          GetCountriesLoaded(
            countriesEntity: CountriesEntity(
              data: List.from(_countries),
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
}
