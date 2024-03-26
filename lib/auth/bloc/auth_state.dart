import 'package:echno_attendance/auth/services/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingMessage;
  const AuthState({
    required this.isLoading,
    this.loadingMessage = 'Please wait a while...',
  });
}

class AuthNotInitializedState extends AuthState {
  const AuthNotInitializedState({required super.isLoading});
}

class AuthRegistrationState extends AuthState {
  final Exception? exception;
  const AuthRegistrationState({
    required this.exception,
    required super.isLoading,
  });
}

class AuthLoggedInState extends AuthState {
  final AuthUser user;
  const AuthLoggedInState({
    required this.user,
    required super.isLoading,
  });
}

class AuthEmailNotVerifiedState extends AuthState {
  const AuthEmailNotVerifiedState({required super.isLoading});
}

class AuthForgotPasswordState extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthForgotPasswordState({
    required this.exception,
    required this.hasSentEmail,
    required super.isLoading,
  });
}

class AuthLoggedOutState extends AuthState with EquatableMixin {
  final Exception? exception;

  const AuthLoggedOutState({
    required this.exception,
    required super.isLoading,
    super.loadingMessage = null,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthPhoneLogInInitiatedState extends AuthState {
  const AuthPhoneLogInInitiatedState({required super.isLoading});
}
