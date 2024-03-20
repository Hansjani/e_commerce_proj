import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

class FirebaseAuthService {
  final FirebaseAuth authentication = FirebaseAuth.instance;

  Future<User?> logIn(String email, String password) async {
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

  Future<String?> currentUserEmail() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.email.toString();
  }

  Future<String?> currentUserName() async {
    final currentUserName = FirebaseAuth.instance.currentUser;
    return currentUserName?.displayName.toString();
  }

  Future<String?> currentUserId() async {
    final currentUserId = FirebaseAuth.instance.currentUser;
    return currentUserId?.uid.toString();
  }

  Future<String?> changePassword() async {
    final currentUserId = FirebaseAuth.instance.currentUser;
    return currentUserId?.uid.toString();
  }

  Future<String?> currentUserPhone() async {
    final currentUserPhone = FirebaseAuth.instance.currentUser;
    return currentUserPhone?.phoneNumber.toString();
  }

  Future<void> updateUserProfile(String displayName) async {
    User? user = authentication.currentUser;

    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.reload(); // Reload the user data
    }
  }

  Future<void> updateUserDetails(String userId, String username,
      String phoneNumber) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('users').doc(userId).set({
      'username': username,
      'phoneNumber': phoneNumber,
    }, SetOptions(merge: true));
  }

  Future<void> updateUsernameAndPhone(String phoneNumber,
      String username) async {
    User? user = authentication.currentUser;
    if (user != null) {
      await updateUserDetails(user.uid, username, phoneNumber);
    }
  }

  Future<String?> getUsername(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('username')) {
        return userData['username'] as String?;
      } else {
        return null;
      }
    } catch (error) {
      devtools.log('Error fetching username: $error');
      return null;
    }
  }

  Future<String?> getPhoneNumber(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('phoneNumber')) {
        return userData['phoneNumber'] as String?;
      } else {
        return null;
      }
    } catch (error) {
      devtools.log('Error fetching phone number: $error');
      return null;
    }
  }

  Future<String?> gottenUsername() async {
    User? user = authentication.currentUser;
    String? userId = user?.uid;
    if (userId != null) {
      return getUsername(userId);
    } else {
      return null;
    }
  }
  Future<String?> gottenPhoneNumber() async {
    User? user = authentication.currentUser;
    String? userId = user?.uid;
    if (userId != null) {
      return getPhoneNumber(userId);
    } else {
      return null;
    }
  }
}