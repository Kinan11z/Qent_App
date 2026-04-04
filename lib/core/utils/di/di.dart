import 'package:get_it/get_it.dart';
import 'package:qent_app/core/dio/ConnectionListener.dart';
import 'package:qent_app/core/dio/factory.dart';
import 'package:qent_app/core/state/appstate.dart';
import 'package:qent_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:qent_app/features/auth/data/repositories/auth_repository.dart';
import 'package:qent_app/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:qent_app/features/auth/presentation/manager/countries/countries_bloc.dart';
import 'package:qent_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:qent_app/features/home/data/repositories/home_repository.dart';
import 'package:qent_app/features/home/presentation/manager/best_cars_bloc.dart';
import 'package:qent_app/features/home/presentation/manager/nearest_cars_bloc.dart';
import 'package:qent_app/features/home/presentation/manager/brand_bloc/brand_bloc.dart';

GetIt getIt = GetIt.instance;

setupServicesLocator(pref) {
  getIt.registerLazySingleton(DioFactory.create);
  getIt.registerLazySingleton(() => AuthRepository(getIt()));
  getIt.registerLazySingleton(() => HomeRepository(getIt()));
  getIt.registerLazySingleton(AuthBloc.new);
  getIt.registerLazySingleton(CountriesBloc.new);
  getIt.registerLazySingleton(BrandBloc.new);
  getIt.registerLazySingleton(BestCarsBloc.new);
  getIt.registerLazySingleton(NearestCarsBloc.new);
  getIt.registerLazySingleton(AuthRemoteDataSource.new);
  getIt.registerLazySingleton(HomeRemoteDataSource.new);
  getIt.registerLazySingleton(() => AppStateModel(pref));
  getIt.registerLazySingleton<ConnectionService>(ConnectionService.new);
}
