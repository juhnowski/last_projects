import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:russian_leaders/bloc/auth/bloc.dart';
import 'package:russian_leaders/model/request_results.dart';
import 'package:russian_leaders/repository/user_repository.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => InitialLoginState();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoadingState();

      try {
        final result = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );
        if (result.error == AuthError.OK) {
          authenticationBloc.add(LoggedIn(result.token));
          yield InitialLoginState();
        } else {
          if (result.error == AuthError.CREDENTIALS) {
            yield LoginCredentialsFailureState(error: result.errorMessage);
          } else {
            yield LoginFailureState(error: result.errorMessage);
          }
        }
      } catch (error) {
        yield LoginFailureState(error: error.toString());
      }
    }
  }
}
