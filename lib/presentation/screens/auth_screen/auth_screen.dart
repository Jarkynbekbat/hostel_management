import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/auth_bloc/auth_bloc.dart';

import 'package:hostel_app/presentation/screens/home_screen/home_screen.dart';

class AuthScreen extends StatelessWidget {
  static String route = 'auth_screen';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) _showSnackBar(state, context);
          if (state is AuthLogedInState)
            Navigator.of(context).pushReplacementNamed(HomeScreen.route);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'введите email',
                ),
              ),
              TextField(
                controller: _passwordController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'введите пароль',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () async {
          String email = _emailController.text;
          String password = _passwordController.text;
          context
              .bloc<AuthBloc>()
              .add(AuthLoginEvent(email: email, password: password));
        },
      ),
    );
  }

  void _showSnackBar(AuthErrorState state, BuildContext context) {
    var snackBar =
        SnackBar(content: Text(state.message), duration: Duration(seconds: 2));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
