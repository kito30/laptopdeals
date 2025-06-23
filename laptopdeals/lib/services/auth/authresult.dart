import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final User? user;

  //for debugging
  final FirebaseAuthException? error;

  AuthResult({this.user, this.error});
}
