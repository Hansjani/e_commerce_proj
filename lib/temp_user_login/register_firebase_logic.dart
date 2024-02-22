import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

class FirebaseAuthService {
  final FirebaseAuth authentication = FirebaseAuth.instance;

  Future<User?> logIn(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await authentication.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      devtools.log(e.code);
    } catch (e) {
      devtools.log(e.toString());
    }
    return null;
  }

  Future<User?> logUp(String email, String password) async {
    try {
      final UserCredential userCredential =
          await authentication.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      devtools.log(e.code);
    } catch (e) {
      devtools.log(e.toString());
    }
    return null;
  }

  Future<User?> logOut() async {
    await authentication.signOut();
    return null;
  }
}
