import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class InitialLoginState extends LoginState {
  @override
  String toString() => 'InitialLoginState';

  const InitialLoginState();
}

class LoginLoadingState extends LoginState {

  @override
  String toString() => 'LoginLoadingState';

  const LoginLoadingState();
}

class LoginFailureState extends LoginState {
  final String error;

  const LoginFailureState({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailureState { error: $error }';
}

class LoginCredentialsFailureState extends LoginState {
  final String error;

  const LoginCredentialsFailureState({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginCredentialsFailureState { error: $error }';
}
