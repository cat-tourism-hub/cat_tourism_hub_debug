import 'dart:convert';

import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  String? _role;
  String? _token;

  User? get user => _user;
  String? get role => _role;
  String? get token => _token;

  String? _error;

  String? get error => _error;

  ValueNotifier<User?> currentUser = ValueNotifier(null);

  AuthenticationProvider() {
    try {
      _auth.authStateChanges().listen(_onAuthStateChanged);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    currentUser.value = _user;
    if (_user != null) {
      await _fetchUserRole();
      await _fetchIdToken();
    }
    notifyListeners();
  }

  Future<void> _fetchUserRole() async {
    if (_user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();

        _role = userDoc['role'];
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future _fetchIdToken() async {
    if (user != null) {
      try {
        _token = await user!.getIdToken();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _error = null;

      // Assume role fetching logic here, if necessary
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        _error = 'Incorrect email or password';
      } else if (e.code == 'user-not-found') {
        _error = 'No user found for that email';
      } else {
        _error = e.message ?? 'An unknown error occurred';
      }
    } catch (e) {
      _error = 'An error occurred. Please try again later.';
    } finally {
      notifyListeners();
    }
    return _error; // Return the error message, or null if no error
  }

  /// Function to sign out a user
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _role = null;
    _token = null;
    currentUser.value = null;
    notifyListeners();
  }

  Future createUser(String email, String password) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (!userCred.user!.emailVerified) {
        await createUserDoc(userCred.user?.uid);
      }
      return 'Please check email for verification';
    } catch (e) {
      rethrow;
    }
  }

  Future createUserDoc(userUid) async {
    try {
      var url = Uri.parse('${AppStrings.baseApiUrl}/add-user/$userUid');

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'role': 'User Account'}));
      if (response.statusCode == 201) {
        return 'User has been created';
      } else {
        return 'Failed to save changes';
      }
    } catch (e) {
      rethrow;
    }
  }
}
