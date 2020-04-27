import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:hostel_app/presentation/screens/auth_screen/auth_screen.dart';
import 'package:hostel_app/presentation/screens/categories_screen/categories_screen.dart';
import 'package:hostel_app/presentation/screens/guests_screen/guests_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/make_sure_dialog.dart';

class MyDrawer extends StatelessWidget {
  final String email;
  final String post;
  const MyDrawer({this.email, this.post});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              child: Container(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              direction: Axis.vertical,
              children: <Widget>[
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceEvenly,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 35.0,
                      child: Text(email[0].toUpperCase()),
                      // backgroundColor: Colors.blue,
                    ),
                    SizedBox(width: 40.0),
                    Text(post)
                  ],
                ),
                Text(email),
              ],
            ),
          )),
          _buildMenuItem(
            leading: Icons.people,
            title: 'Гости',
            subtitle: 'управление данными',
            onTap: () => Navigator.of(context).pushNamed(GuestsScreen.route),
          ),
          Divider(height: 1),
          _buildMenuItem(
            leading: Icons.category,
            title: 'Категории',
            subtitle: 'управление данными',
            onTap: () =>
                Navigator.of(context).pushNamed(CategoriesScreen.route),
          ),
          Divider(height: 1),
          _buildMenuItem(
              leading: Icons.scatter_plot,
              title: 'Услуги',
              onTap: null,
              subtitle: 'в разработке'),
          Divider(height: 1),
          _buildMenuItem(
              leading: Icons.exit_to_app,
              title: 'Выйти',
              subtitle: 'выход из учетной записи',
              onTap: () async {
                bool result = await showMakeSureDialog(
                  context: context,
                  title: 'Выход',
                  content: 'Вы уверены что хотите выйти?',
                  ok: 'выйти',
                  onOk: () {},
                );
                if (result) {
                  context.bloc<AuthBloc>().add(AuthLogoutEvent());
                  Navigator.of(context).pushReplacementNamed(AuthScreen.route);
                }
              }),
          Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      {String title, Function onTap, String subtitle, IconData leading}) {
    return ListTile(
      leading: Icon(leading),
      title: Text(title),
      subtitle: Text(subtitle ?? ''),
      onTap: onTap,
    );
  }
}
