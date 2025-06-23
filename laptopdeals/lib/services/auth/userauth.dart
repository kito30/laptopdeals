import 'package:firebase_auth/firebase_auth.dart';

import 'authresult.dart';

class UserAuth {
  final FirebaseAuth firebaseAuth;
  UserAuth({required this.firebaseAuth});
  Future<AuthResult> registerUser(String email, String password) async {
    // check for invalid input
    if (email.isEmpty || !email.contains('@') || password.isEmpty) {
      return AuthResult(
        user: null,
        error: FirebaseAuthException(code: 'Invalid email or password'),
      );
    }
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(user: result.user, error: null);
    } on FirebaseAuthException catch (err) {
      return AuthResult(user: null, error: err);
    }
  }

  Future<AuthResult> loginUser(String email, String password) async {
    // check for invalid input
    if (email.isEmpty || !email.contains('@') || password.isEmpty) {
      return AuthResult(
        user: null,
        error: FirebaseAuthException(code: 'Invalid email or password'),
      );
    }
    try {
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(user: result.user, error: null);
    } on FirebaseAuthException catch (err) {
      return AuthResult(user: null, error: err);
    }
  }
}
