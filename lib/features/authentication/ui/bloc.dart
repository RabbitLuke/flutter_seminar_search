import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_seminar_search/constants.dart';
import 'package:flutter_seminar_search/features/authentication/index.dart';
import 'package:flutter_seminar_search/features/authentication/service/auth_service.dart';

// Authentication State
class AuthState {}

class AuthInitial extends AuthState {}

class AuthAuthenticatedUser extends AuthState {}

class AuthAuthenticatedHost extends AuthState {}

class AuthUnauthenticated extends AuthState {}

// Authentication Events
abstract class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent(this.email, this.password);
}

class AuthLogoutEvent extends AuthEvent {}

// Authentication BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final storage = const FlutterSecureStorage();
  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthInitial()); // Show loading state

      final isAuthenticated =
          await authService.authenticate(event.email, event.password);
      if (isAuthenticated) {
        final isHost = await storage.read(key: ApiConstants.isHost);

        if (isHost == "true") {
          emit(AuthAuthenticatedHost());
        } else {
          emit(AuthAuthenticatedUser());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    });
    on<AuthLogoutEvent>((event, emit) async {
      await authService.logout();
      emit(AuthUnauthenticated());
    });
  }
}
