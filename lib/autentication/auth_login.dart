import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cangurugestor/model/login_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MethodLogin {
  MethodLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool userLogged = false;

  void userStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      userLogged = user != null;
    });
  }

  void logout() {}
  void login() {}
  void loadUser() {}
}

class GoogleLogin extends MethodLogin {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> getCredentials() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> logout() async {
    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
    }
    if (_auth.currentUser != null) {
      await _auth.signOut();
    }
  }

  @override
  Future<LoginUser> loadUser() async {
    var cred = await getCredentials();
    LoginUser user =
        await FirestoreLogin().autenticarUsuarioEmail(cred.user!.email!);

    if (user.id.isEmpty) {
      //logout();
    }
    return user;
  }
}

class EmailSenhaLogin extends MethodLogin {}

class AppleIDLogin extends MethodLogin {}

class PhoneLogin extends MethodLogin {}

class AnonymousLogin extends MethodLogin {}
