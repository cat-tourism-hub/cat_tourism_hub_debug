import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  String? _role;
  String? _token;

  User? get user => _user;
  String? get role => _role;
  String? get token => _token;

  AuthenticationProvider() {
    try {
      _auth.authStateChanges().listen(_onAuthStateChanged);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
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

  Future signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
