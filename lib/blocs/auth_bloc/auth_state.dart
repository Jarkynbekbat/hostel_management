part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLogedInState extends AuthState {
  final String email;
  final String password;
  AuthLogedInState({this.email, this.password});
}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState({@required this.message});
}
