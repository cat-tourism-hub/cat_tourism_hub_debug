import 'package:cat_tourism_hub/business/presentation/components/text_form_field.dart';
import 'package:cat_tourism_hub/core/components/feature_unavailable.dart';
import 'package:cat_tourism_hub/core/auth/auth_provider.dart';
import 'package:cat_tourism_hub/core/utils/app_constants.dart';
import 'package:cat_tourism_hub/core/utils/app_regex.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cat_tourism_hub/core/utils/snackbar_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool _isLoading = false;

  void initializeControllers() {
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) return;

    if (AppRegex.emailRegex.hasMatch(email)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
  }

  @override
  void initState() {
    initializeControllers();

    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider =
          Provider.of<AuthenticationProvider>(context, listen: false);

      final redirectUrl = (GoRouterState.of(context).extra
          as Map<String, dynamic>?)?['redirectUrl'];

      // Call signIn and check if an error was returned
      final errorMessage = await provider.signIn(
        emailController.text,
        passwordController.text,
      );

      if (errorMessage != null) {
        if (!mounted) return;
        SnackbarHelper.showSnackBar(errorMessage);
        return; // Exit if there's an error
      }

      // Wait until the role is fetched and updated, with a timeout
      final startTime = DateTime.now();
      while (provider.role == null) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (DateTime.now().difference(startTime).inSeconds > 5) {
          if (!mounted) return;
          SnackbarHelper.showSnackBar('Error authenticating account');
          return; // Exit if timeout occurs
        }
      }

      // Handle post-login redirection
      if (provider.role == AppStrings.businessAccount) {
        if (!mounted) return;
        context.go('/business');
      } else if (redirectUrl != null) {
        // Redirect to the intended page if provided
        if (!mounted) return;
        (kIsWasm || kIsWeb)
            ? context.go(redirectUrl)
            : context.push(redirectUrl);
      } else if (provider.role == 'User Account') {
        if (!mounted) return;
        (kIsWasm || kIsWeb)
            ? context.go('/dashboard')
            : context.push('/dashboard');
      } else {
        // Default fallback
        if (!mounted) return;
        (kIsWasm || kIsWeb) ? context.go('/') : context.push('/');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            height: MediaQuery.sizeOf(context).height * 1.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: Image.asset(
                  'assets/images/dot_catanduanes.jpg',
                ).image,
              ),
            ),
          ),
          Center(
            child: Card(
              color: const Color.fromARGB(207, 255, 255, 255),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: screenWidth < 1000
                      ? screenWidth * 0.9
                      : screenWidth * 0.5,
                  child: Padding(
                    padding: screenWidth < 1000
                        ? const EdgeInsets.all(10)
                        : const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 40.0, 0.0, 12.0),
                                child: Text(
                                  AppStrings.appName,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Welcome Back,',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                            ],
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppTextFormField(
                                  controller: emailController,
                                  labelText: AppStrings.email,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (_) =>
                                      _formKey.currentState?.validate(),
                                  validator: (value) {
                                    return value!.isEmpty
                                        ? AppStrings.pleaseEnterEmailAddress
                                        : AppConstants.emailRegex
                                                .hasMatch(value)
                                            ? null
                                            : AppStrings.invalidEmailAddress;
                                  },
                                ),
                                ValueListenableBuilder(
                                  valueListenable: passwordNotifier,
                                  builder: (_, passwordObscure, __) {
                                    return AppTextFormField(
                                      obscureText: passwordObscure,
                                      controller: passwordController,
                                      labelText: AppStrings.password,
                                      textInputAction: TextInputAction.done,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      onChanged: (_) =>
                                          _formKey.currentState?.validate(),
                                      validator: (value) {
                                        return value!.isEmpty
                                            ? AppStrings.pleaseEnterPassword
                                            : null;
                                      },
                                      suffixIcon: IconButton(
                                        onPressed: () => passwordNotifier
                                            .value = !passwordObscure,
                                        style: IconButton.styleFrom(
                                          minimumSize: const Size.square(48),
                                        ),
                                        icon: Icon(
                                          passwordObscure
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Develop the forgot password feature
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const FeatureUnavailable());
                                  },
                                  child: const Text(AppStrings.forgotPassword),
                                ),
                                const Gap(20),
                                ValueListenableBuilder(
                                  valueListenable: fieldValidNotifier,
                                  builder: (_, isValid, __) {
                                    return _isLoading
                                        ? LoadingAnimationWidget.discreteCircle(
                                            color: Theme.of(context)
                                                .indicatorColor,
                                            size: 40,
                                          )
                                        : FilledButton(
                                            onPressed: isValid
                                                ? () {
                                                    _login();
                                                  }
                                                : null,
                                            child: const Text(AppStrings.login),
                                          );
                                  },
                                ),
                                const Gap(20),
                                TextButton(
                                  onPressed: () async {
                                    // TODO: Develop the create account feature
                                    (kIsWasm || kIsWeb)
                                        ? context.go('/create-account')
                                        : context.push('/create-account');
                                  },
                                  child: const Text('Create Account'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      context.push('/business/sign-up'),
                                  child: const Text('Be a Partner'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
