import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/auth/data/model/params/login_params.dart';
import 'package:qent_app/features/auth/data/model/params/sign_up_params.dart';
import 'package:qent_app/features/auth/data/repositories/auth_repository.dart';
import 'package:qent_app/features/auth/domain/entities/login_entity.dart';
import 'package:qent_app/features/auth/domain/entities/sign_up_entity.dart';
import 'package:qent_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:qent_app/features/auth/domain/usecases/sign_up_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(SignUpLoading());
      final res =
          await SignUpUseCase(getIt<AuthRepository>()).call(event.signUpParams);
      emit(
        res.fold(
          (l) => SignUpError(errorMessage: l.errorMessage),
          (r) => SignUpLoaded(signUpEntity: r),
        ),
      );
    });
    on<LoginEvent>((event, emit) async {
      emit(LoginLoading());
      final res =
          await LoginUseCase(getIt<AuthRepository>()).call(event.loginParams);
      emit(
        res.fold(
          (l) => LoginError(errorMessage: l.errorMessage),
          (r) => LoginLoaded(loginEntity: r),
        ),
      );
    });
  }
}
