import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:record_admin/models/User.dart';

class AuthProvider with ChangeNotifier {
  UserModel _user;
  UserModel get user => _user;
  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  Future<void> signUp(UserModel user) async {
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(result.user.uid)
        .set(user.toJson());
  }
}
