import 'package:cat_tourism_hub/business/presentation/components/text_form_field.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cat_tourism_hub/core/utils/app_constants.dart';
import 'package:cat_tourism_hub/core/utils/app_regex.dart';
import 'package:cat_tourism_hub/core/auth/auth_provider.dart';
import 'package:cat_tourism_hub/core/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> verifyPasswordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController verifyPasswordController;
  bool _isLoading = false;
  bool _isDisposed = false;

  void initializeControllers() {
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
    verifyPasswordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
    verifyPasswordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;
    final verifyPassword = verifyPasswordController.text;

    // Validate each field independently
    if (AppRegex.emailRegex.hasMatch(email) &&
        _isPasswordValid(password) &&
        password == verifyPassword) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }

    // Rebuild UI to show updated checklist status
    setState(() {});
  }

  /// Function to check if the password is valid by checking if it has the
  /// following condition
  bool _isPasswordValid(String password) {
    // Check for at least 8 characters, 1 uppercase letter, and 1 special character
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) && // At least one uppercase letter
        RegExp(r'[!@#\$&*~?><]')
            .hasMatch(password); // At least one special character
  }

  // Individual checks for the password checklist
  bool _hasMinLength(String password) => password.length >= 8;
  bool _hasUppercase(String password) => RegExp(r'[A-Z]').hasMatch(password);
  bool _hasSpecialChar(String password) =>
      RegExp(r'[!@#\$&*~?><]').hasMatch(password);

  /// The function to Add the account to firebase Auth
  Future createAccount() async {
    /// Checks if the UI is disposed and return since there will
    /// be no UI to display the result
    if (_isDisposed) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final result = await authProvider.createUser(
          emailController.text, passwordController.text);

      SnackbarHelper.showSnackBar(result.toString());
    } catch (e) {
      final error = e.toString().split("] ")[1];
      SnackbarHelper.showSnackBar(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
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
    _isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                color: const Color.fromARGB(240, 255, 255, 255),
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 40.0, 0.0, 12.0),
                                    child: Text(
                                      AppStrings.appName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge,
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
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (_) =>
                                            _formKey.currentState?.validate(),
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? AppStrings
                                                  .pleaseEnterEmailAddress
                                              : AppConstants.emailRegex
                                                      .hasMatch(value)
                                                  ? null
                                                  : AppStrings
                                                      .invalidEmailAddress;
                                        },
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: passwordNotifier,
                                        builder: (_, passwordObscure, __) {
                                          return AppTextFormField(
                                            obscureText: passwordObscure,
                                            controller: passwordController,
                                            labelText: AppStrings.password,
                                            textInputAction:
                                                TextInputAction.done,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            onChanged: (_) => _formKey
                                                .currentState
                                                ?.validate(),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return AppStrings
                                                    .pleaseEnterPassword;
                                              }
                                              if (!_isPasswordValid(value)) {
                                                return 'Password must be at least 8 characters long, include an uppercase letter, and a special symbol.';
                                              }
                                              return null;
                                            },
                                            suffixIcon: IconButton(
                                              onPressed: () => passwordNotifier
                                                  .value = !passwordObscure,
                                              style: IconButton.styleFrom(
                                                minimumSize:
                                                    const Size.square(48),
                                              ),
                                              icon: Icon(
                                                passwordObscure
                                                    ? Icons
                                                        .visibility_off_outlined
                                                    : Icons.visibility_outlined,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: verifyPasswordNotifier,
                                        builder:
                                            (_, verifyPasswordObscure, __) {
                                          return AppTextFormField(
                                            obscureText: verifyPasswordObscure,
                                            controller:
                                                verifyPasswordController,
                                            labelText:
                                                AppStrings.verifyPassword,
                                            textInputAction:
                                                TextInputAction.done,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            onChanged: (_) => _formKey
                                                .currentState
                                                ?.validate(),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return AppStrings
                                                    .pleaseEnterPassword;
                                              }
                                              if (value !=
                                                  passwordController.text) {
                                                return 'Passwords do not match';
                                              }
                                              return null;
                                            },
                                            suffixIcon: IconButton(
                                              onPressed: () =>
                                                  verifyPasswordNotifier.value =
                                                      !verifyPasswordObscure,
                                              style: IconButton.styleFrom(
                                                minimumSize:
                                                    const Size.square(48),
                                              ),
                                              icon: Icon(
                                                verifyPasswordObscure
                                                    ? Icons
                                                        .visibility_off_outlined
                                                    : Icons.visibility_outlined,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      _buildPasswordChecklist(),
                                      ValueListenableBuilder(
                                        valueListenable: fieldValidNotifier,
                                        builder: (_, isValid, __) {
                                          return _isLoading
                                              ? LoadingAnimationWidget
                                                  .discreteCircle(
                                                  color: Theme.of(context)
                                                      .indicatorColor,
                                                  size: 40,
                                                )
                                              : FilledButton(
                                                  onPressed: isValid
                                                      ? () {
                                                          createAccount();
                                                        }
                                                      : null,
                                                  child: const Text(
                                                      'Create Account'),
                                                );
                                        },
                                      ),
                                    ]),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordChecklist() {
    final password = passwordController.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChecklistItem("At least 8 characters", _hasMinLength(password)),
        _buildChecklistItem(
            "Contains uppercase letter", _hasUppercase(password)),
        _buildChecklistItem("Contains special character (e.g., !@#\$&*)",
            _hasSpecialChar(password)),
      ],
    );
  }

  Widget _buildChecklistItem(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.circle,
          color: isValid ? Colors.green : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
