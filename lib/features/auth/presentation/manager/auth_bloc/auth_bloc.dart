import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/auth/data/model/params/forgot_password_params.dart';
import 'package:qent_app/features/auth/data/model/params/login_params.dart';
import 'package:qent_app/features/auth/data/model/params/request_verify_code_params.dart';
import 'package:qent_app/features/auth/data/model/params/sign_up_params.dart';
import 'package:qent_app/features/auth/data/repositories/auth_repository.dart';
import 'package:qent_app/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:qent_app/features/auth/domain/entities/login_entity.dart';
import 'package:qent_app/features/auth/domain/entities/request_verify_code_entity.dart';
import 'package:qent_app/features/auth/domain/entities/sign_up_entity.dart';
import 'package:qent_app/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:qent_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:qent_app/features/auth/domain/usecases/request_verify_code_use_case.dart';
import 'package:qent_app/features/auth/domain/usecases/sign_up_use_case.dart';

import '../../../data/model/params/confirm_reset_password_params.dart';
import '../../../data/model/params/confirm_verify_code_params.dart';
import '../../../domain/entities/confirm_reset_password_entity.dart';
import '../../../domain/entities/confirm_verify_code_entity.dart';
import '../../../domain/usecases/confirm_reset_password_use_case.dart';
import '../../../domain/usecases/confirm_verify_code_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    //******    Sign Up *** **** */

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

    //******    Login *** **** */

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

    //******    Forgot Password *** **** */

    on<ForgotPasswordEvent>((event, emit) async {
      emit(ForgotPasswordLoading());
      final res = await ForgotPasswordUseCase(getIt<AuthRepository>())
          .call(event.forgotPasswordParams);
      emit(
        res.fold(
          (l) => ForgotPasswordError(errorMessage: l.errorMessage),
          (r) => ForgotPasswordLoaded(forgotPasswordEntity: r),
        ),
      );
    });

    //******    Request Verify Code *** **** */

    on<RequestVerifyCodeEvent>((event, emit) async {
      emit(RequestVerifyCodeLoading());
      final res = await RequestVerifyCodeUseCase(getIt<AuthRepository>())
          .call(event.requestVerifyCodeParams);
      emit(
        res.fold(
          (l) => RequestVerifyCodeError(errorMessage: l.errorMessage),
          (r) => RequestVerifyCodeLoaded(requestVerifyCodeEntity: r),
        ),
      );
    });
    //******    Confirm Verify Code *** **** */

    on<ConfirmVerifyCodeEvent>((event, emit) async {
      emit(ConfirmVerifyCodeLoading());
      final res = await ConfirmVerifyCodeUseCase(getIt<AuthRepository>())
          .call(event.confirmVerifyCodeParams);
      emit(
        res.fold(
          (l) => ConfirmVerifyCodeError(errorMessage: l.errorMessage),
          (r) => ConfirmVerifyCodeLoaded(confirmVerifyCodeEntity: r),
        ),
      );
    });
    //******    Confirm Reset Password Code *** **** */

    on<ConfirmResetPasswordEvent>((event, emit) async {
      emit(ConfirmResetPasswordLoading());
      final res = await ConfirmResetPasswordUseCase(getIt<AuthRepository>())
          .call(event.confirmResetPasswordParams);
      emit(
        res.fold(
          (l) => ConfirmResetPasswordError(errorMessage: l.errorMessage),
          (r) => ConfirmResetPasswordLoaded(confirmResetPasswordEntity: r),
        ),
      );
    });
  }
}
