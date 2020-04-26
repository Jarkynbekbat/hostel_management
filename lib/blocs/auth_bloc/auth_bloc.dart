import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => AuthInitial();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      if (event is AuthLoginEvent) yield await _loginToState(auth, event);
      if (event is AuthSignupEvent) yield await _signupToState(auth, event);
      if (event is AuthLogoutEvent) auth.signOut();
    } catch (ex) {
      yield _onException(ex);
    }
  }

  AuthErrorState _onException(ex) {
    switch (ex.code) {
      case 'ERROR_WEAK_PASSWORD':
        return AuthErrorState(message: 'Слишком ненадежный пароль');
        break;
      case 'ERROR_INVALID_EMAIL':
        return AuthErrorState(message: 'Неверный email');
        break;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return AuthErrorState(message: 'Email уже зарегистрирован');
        break;
      case 'ERROR_WRONG_PASSWORD':
        return AuthErrorState(message: 'Не верный пароль');
        break;
      case 'ERROR_USER_NOT_FOUND':
        return AuthErrorState(message: 'Пользователь не найден');
        break;
      case 'ERROR_USER_DISABLED':
        return AuthErrorState(message: 'Пользователь был заблокирован');
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        return AuthErrorState(
            message: 'У вас не осталось попыток , попробуйте позже');
        break;
      default:
        return AuthErrorState(message: 'Упс ... что то пошло не так ...');
    }
  }

  Future<AuthLogedInState> _signupToState(auth, event) async {
    await auth.createUserWithEmailAndPassword(
        email: event.email, password: event.password);
    return AuthLogedInState(email: event.email, password: event.password);
  }

  Future<AuthLogedInState> _loginToState(auth, event) async {
    await auth.signInWithEmailAndPassword(
        email: event.email, password: event.password);
    return AuthLogedInState(email: event.email, password: event.password);
  }
}
