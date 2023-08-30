import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> stateChange() => _auth.authStateChanges();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> getCredentials() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<User?> loadUser() async {
    var cred = await getCredentials();
    return cred.user;
  }
}

class AppleLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> stateChange() => _auth.authStateChanges();
}
