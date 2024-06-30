import 'package:cat_tourism_hub/auth/sign_in.dart';
import 'package:cat_tourism_hub/business/sections/setup.dart';
import 'package:cat_tourism_hub/business/sign_up.dart';
import 'package:cat_tourism_hub/business/splash.dart';
import 'package:cat_tourism_hub/firebase_options.dart';
import 'package:cat_tourism_hub/auth/auth_provider.dart';
import 'package:cat_tourism_hub/providers/establishment_provider.dart';
import 'package:cat_tourism_hub/providers/hotel_rooms_provider.dart';
import 'package:cat_tourism_hub/users/homepage.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setPathUrlStrategy();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
      redirect: (context, state) {
        final AuthenticationProvider provider =
            Provider.of<AuthenticationProvider>(context, listen: false);
        final user = provider.user;
        final String? userRole = provider.role;

        if (user == null && state.matchedLocation == '/sign-in') {
          return '/sign-in';
        }
        if (user == null && state.matchedLocation == '/business/sign-up') {
          return '/business/sign-up';
        }
        // Role-based redirects
        if (user != null && userRole == AppStrings.businessAccount) {
          return '/business';
        }
        // if (userRole == UserRole.operator &&
        //     state.matchedLocation != '/operator') {
        //   return '/operator';
        // }
        // if (userRole == UserRole.client && state.matchedLocation != '/client') {
        //   return '/client';
        // }

        return '/';
      },
      routes: [
        GoRoute(
            path: '/',
            name: 'homepage',
            builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/business',
          name: 'business',
          builder: (context, state) => const BusinessDashboard(),
        ),
        GoRoute(
            path: '/setup',
            name: 'setup',
            builder: (context, state) => const Setup()),
        GoRoute(
            path: '/sign-in',
            name: 'sign-in',
            builder: (context, state) => const SignIn()),
        GoRoute(
            path: '/business/sign-up',
            name: 'business sign-up',
            builder: (context, state) => const SignUp()),
      ]);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => EstablishmentProvider()),
        ChangeNotifierProvider(create: (_) => HotelProvider()),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: ThemeData(
          textTheme: const TextTheme(
              headlineMedium: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              headlineLarge: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              headlineSmall: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              labelLarge: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              labelMedium: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              labelSmall: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              bodyMedium: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
              bodyLarge: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
              bodySmall: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.normal)),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 58, 123, 183)),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
