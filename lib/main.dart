import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/booking_bloc/booking_bloc.dart';
import 'package:hostel_app/blocs/home_bloc/home_bloc.dart';
import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';
import 'package:hostel_app/data/repositories/repository.dart';
import 'package:hostel_app/presentation/screens/auth_screen/auth_screen.dart';
import 'package:hostel_app/presentation/screens/guests_screen/guests_screen.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
// import 'blocs/living_bloc/living_bloc.dart';
import 'blocs/living_bloc/living_bloc.dart';
import 'presentation/screens/categories_screen/categories_screen.dart';
import 'presentation/screens/home_screen/home_screen.dart';
import 'presentation/screens/numbers_screen/all_numbers/all_numbers_screen.dart';
import 'presentation/screens/numbers_screen/booked_numbers/booked_numbers_screen.dart';
import 'presentation/screens/numbers_screen/busy_numbers/busy_numbers_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'presentation/screens/numbers_screen/free_numbers/free_numbers_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var user = await auth.currentUser();

  initializeDateFormatting().then(
    (_) => runApp(
      MyApp(initialRoute: user == null ? AuthScreen.route : HomeScreen.route),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({this.initialRoute});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Repository>(create: (context) => Repository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc()),
          BlocProvider(
            create: (context) => NumbersBloc(context.repository<Repository>()),
          ),
          BlocProvider(
            create: (context) => BookingBloc(context.repository<Repository>()),
          ),
          BlocProvider(
            create: (context) => LivingBloc(context.repository<Repository>()),
          ),
          BlocProvider(
            create: (context) => HomeBloc(context.repository<Repository>()),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData.dark(),
          routes: {
            AuthScreen.route: (_) => AuthScreen(),
            HomeScreen.route: (_) => HomeScreen(),
            AllNumbersScreen.route: (_) => AllNumbersScreen(),
            BusyNumbersScreen.route: (_) => BusyNumbersScreen(),
            BookedNumbersScreen.route: (_) => BookedNumbersScreen(),
            FreeNumbersScreen.route: (_) => FreeNumbersScreen(),
            GuestsScreen.route: (_) => GuestsScreen(),
            CategoriesScreen.route: (_) => CategoriesScreen(),
          },
          initialRoute: initialRoute,
          title: 'Управление гостиницей',
        ),
      ),
    );
  }
}
