import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/models.dart';
import 'database.dart';

class AuthServices {
  GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', "https://www.googleapis.com/auth/userinfo.profile"]);
  User? _firebaseUser;
  AuthCredential? _phoneAuthCredential;
  int? _code;

  static String? _verificationId;
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  Future<void> getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser;
  }

  UserAuth? userFromFirebaseUser(User? user) {
    return user != null ? UserAuth(uid: user.uid) : null;
  }

  Stream<UserAuth?> get user {
    return FirebaseAuth.instance
        .authStateChanges()
        //.map((FirebaseUser user)=>_userFromFirebaseUser(user)) same as the code below
        .map(userFromFirebaseUser);
  }

  static Future<void> signOut({required BuildContext context}) async {
    // Disable persistence on web platforms
    // await FirebaseAuth.instance.setPersistence(Persistence.NONE);
    final GoogleSignIn googleSignIn = GoogleSignIn();
    // firebaseUser = await await FirebaseAuth.instance.currentUser;
    // this._firebaseUser = await await _auth.currentUser();
    // if (GoogleSignIn().currentUser != null) {
    //   await GoogleSignIn().signOut();
    // }

    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('failed to disconnect on signout $e');
    }
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print("a user is logged in: " + user.displayName.toString());
    } else {
      print("Username" + " there is no user");
    }

    await FirebaseAuth.instance.signOut();
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }

      await FirebaseAuth.instance.signOut();

      await googleSignIn.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        AuthServices.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
      print('Signout not working');
    }
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            AuthServices.customSnackBar(
              content: 'The account already exists with a different credential',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            AuthServices.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          AuthServices.customSnackBar(
            content: 'Error occurred using Google Sign In. Try again.',
          ),
        );
      }
    }
    if (user != null) {
      DatabaseService().newUser(user);
    }

    return user;
  }
}
