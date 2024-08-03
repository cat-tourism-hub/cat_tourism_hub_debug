import 'package:cat_tourism_hub/core/constants/theme/values/app_theme.dart';
import 'package:cat_tourism_hub/users/presentation/sign_in.dart';
import 'package:cat_tourism_hub/business/presentation/sections/admin_panel/admin_panel.dart';
import 'package:cat_tourism_hub/business/presentation/sign_up.dart';
import 'package:cat_tourism_hub/business/presentation/splash.dart';
import 'package:cat_tourism_hub/firebase_options.dart';
import 'package:cat_tourism_hub/core/utils/auth_provider.dart';
import 'package:cat_tourism_hub/business/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/business/providers/product_provider.dart';
import 'package:cat_tourism_hub/users/providers/partners_provider.dart';
import 'package:cat_tourism_hub/users/presentation/homepage.dart';
import 'package:cat_tourism_hub/core/utils/snackbar_helper.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
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

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    redirect: (context, state) {
      final AuthenticationProvider authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final user = authProvider.user;
      final String? userRole = authProvider.role;

      // if (state.matchedLocation == '/sign-in' ||
      //     state.matchedLocation == '/business/sign-up') {
      //   return state.matchedLocation;
      // }

      // if (user != null) {
      //   if (userRole == AppStrings.businessAccount) {
      //     return '/business';
      //   }
      //   // else if (userRole == 'DOT')
      // } else {
      //   return '/sign-in';
      // }

      // return '/';
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
      return '/';
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'homepage',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/business',
        name: 'business',
        builder: (context, state) => const BusinessDashboard(),
      ),
      GoRoute(
        path: '/setup',
        name: 'setup',
        builder: (context, state) => const AdminPanel(),
      ),
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) => const SignIn(),
      ),
      GoRoute(
        path: '/business/sign-up',
        name: 'business-sign-up',
        builder: (context, state) => const SignUp(),
      ),
    ],
  );

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
        theme: AppTheme.themeData,
        routerConfig: _router,
      ),
    );
  }
}
