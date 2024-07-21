import 'package:cat_tourism_hub/auth/sign_in.dart';
import 'package:cat_tourism_hub/business/sections/admin_panel.dart';
import 'package:cat_tourism_hub/business/sign_up.dart';
import 'package:cat_tourism_hub/business/splash.dart';
import 'package:cat_tourism_hub/firebase_options.dart';
import 'package:cat_tourism_hub/auth/auth_provider.dart';
import 'package:cat_tourism_hub/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/providers/product_provider.dart';
import 'package:cat_tourism_hub/providers/partners_provider.dart';
import 'package:cat_tourism_hub/users/homepage.dart';
import 'package:cat_tourism_hub/utils/snackbar_helper.dart';
import 'package:cat_tourism_hub/values/strings.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
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
  // await FirebaseAppCheck.instance.activate(
  //   // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
  //   // argument for `webProvider`
  //   webProvider: ReCaptchaV3Provider('cattourismhub'),
  //   // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Safety Net provider
  //   // 3. Play Integrity provider
  //   androidProvider: AndroidProvider.debug,
  //   // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Device Check provider
  //   // 3. App Attest provider
  //   // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
  //   appleProvider: AppleProvider.appAttest,
  // );

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
            builder: (context, state) => const AdminPanel()),
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
        ChangeNotifierProvider(create: (_) => PartnerAcctProvider()),
        ChangeNotifierProvider(create: (_) => PartnersProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: SnackbarHelper.key,
        title: AppStrings.appName,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          cardTheme: const CardTheme(
              color: Color.fromARGB(255, 247, 247, 247),
              shadowColor: Color.fromARGB(255, 41, 102, 233),
              elevation: 3),
          textTheme: const TextTheme(
              headlineLarge: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
              headlineMedium: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
              headlineSmall: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              labelLarge: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              labelMedium: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
              labelSmall: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.normal),
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
