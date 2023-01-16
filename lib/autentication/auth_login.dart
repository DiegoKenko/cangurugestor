import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MethodLogin {
  const MethodLogin();
}

class GoogleLogin extends MethodLogin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  Future<void> logout() async {
    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.signOut();
    }
    if (_auth.currentUser != null) {
      await _auth.signOut();
    }
  }

  Future<Gestor> loadUser() async {
/*     var cred = await getCredentials();
    Gestor gestor =
        await FirestoreLogin().autenticarUsuarioEmail(cred.user!.email!); */
    Gestor gestor =
        await FirestoreLogin().autenticarUsuarioEmail('dafl.andrade@gmail.com');
    if (gestor.id.isEmpty) {
      //logout();
    }
    return gestor;
  }
}
