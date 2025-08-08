import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/signup_user.dart';
import '../../domain/usecases/logout_user.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';
import 'package:ecommerce_app/core/error/failure.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final SignUpUser signUpUser;
  final LogoutUser logoutUser;

  AuthBloc({
    required this.loginUser,
    required this.signUpUser,
    required this.logoutUser,
  }) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      final result = await loginUser(LoginParams(
        email: event.email,
        password: event.password,
      ));

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());

      final result = await signUpUser(SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ));

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());

      final result = await logoutUser(NoParams());

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(Unauthenticated()),
      );
    });

    on<AuthCheckRequested>((event, emit) async {
      // Optional: implement token persistence later
      emit(Unauthenticated()); // For now, default to logged out
    });
  }
}
