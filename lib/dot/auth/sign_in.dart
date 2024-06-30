import 'package:cat_tourism_hub/values/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class DotSignIn extends StatefulWidget {
  const DotSignIn({super.key});

  @override
  State<DotSignIn> createState() => _DotSignInState();
}

class _DotSignInState extends State<DotSignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  late bool passwordVisibility;

  @override
  void initState() {
    super.initState();
    passwordVisibility = false;
  }

  @override
  void dispose() {
    super.dispose();
    emailAddressFocusNode?.dispose();
    emailController.dispose();

    passwordFocusNode?.dispose();
    passwordController.dispose();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.message!.contains('auth/invalid-email')) {
        return 'Invalid email address.';
      } else if (e.message!.contains('auth/network-request-failed')) {
        return 'Slow Internet Connection.';
      } else if (e.message!.contains('firebase_auth/invalid-credential')) {
        return 'Invalid Email or Password.';
      } else if (e.message!.contains('auth/too-many-requests')) {
        return 'Too many login attempts. Try again later.';
      } else {
        return 'Unknown error. Try again later.';
      }
    }
  }

  // Future<String?> _signupUser(SignupData data) async {
  //   try {
  //     await auth.createUserWithEmailAndPassword(
  //       email: data.name!,
  //       password: data.password!,
  //     );
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.message!.contains('auth/email-already-in-use')) {
  //       return 'Email already exist.';
  //     } else if (e.message!.contains('auth/invalid-email')) {
  //       return 'Invalid email.';
  //     } else {
  //       return 'Unknown error. Try again later.';
  //     }
  //   }
  // }

  Future<String?> _recoverPassword(String name) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
      return null;
    } catch (error) {
      return 'Error sending password reset email: $error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: FlutterLogin(
          headerWidget: Padding(
            padding: const EdgeInsets.only(top: 6.0, bottom: 12),
            child: Text(appName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge),
          ),
          theme: LoginTheme(
              primaryColor: const Color.fromARGB(75, 255, 255, 255),
              buttonTheme: const LoginButtonTheme(
                  backgroundColor: Color.fromARGB(255, 92, 169, 231)),
              textFieldStyle: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
              bodyStyle: const TextStyle(fontFamily: 'Poppins'),
              cardTheme:
                  const CardTheme(color: Color.fromARGB(220, 97, 255, 118))),
          onLogin: _authUser,
          onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacementNamed('/dot');
          },
          onRecoverPassword: _recoverPassword,
          messages: LoginMessages(
            recoverPasswordDescription:
                'Recovery procedure will be sent to the email.',
            recoverPasswordSuccess: 'Email sent successfully.',
          ),
        ),
      ),
    );
  }
}
