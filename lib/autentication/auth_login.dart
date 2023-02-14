import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MethodLogin {
  MethodLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> stateChange() => _auth.authStateChanges();

  void logout() async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
    }
  }

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
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<Pessoa> loadUser() async {
    var cred = await getCredentials();
    Pessoa user =
        await FirestoreLogin().autenticarUsuarioEmail(cred.user!.email!);
    return user;
  }
}

class EmailSenhaLogin extends MethodLogin {
  final String email;
  final String senha;
  EmailSenhaLogin(this.email, this.senha);

  @override
  Future<Pessoa> loadUser() async {
    Pessoa user = await FirestoreLogin().autenticarUsuarioEmail(email);
    return user;
  }

  @override
  Future<void> logout() async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
    }
  }
}

class AppleIDLogin extends MethodLogin {}

class PhoneLogin extends MethodLogin {}

class AnonymousLogin extends MethodLogin {
  @override
  Future<Pessoa> loadUser() async {
    Pessoa user =
        await FirestoreLogin().autenticarUsuarioEmail('anonimo@inora.com.br');
    return user;
  }

  @override
  Future<void> logout() async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
    }
  }
}
