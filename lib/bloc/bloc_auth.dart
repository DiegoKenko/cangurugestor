import 'package:cangurugestor/autentication/auth_login.dart';
import 'package:cangurugestor/bloc/bloc_auth_event.dart';
import 'package:cangurugestor/bloc/bloc_auth_state.dart';
import 'package:cangurugestor/firebaseUtils/fire_cuidador.dart';
import 'package:cangurugestor/firebaseUtils/fire_gestor.dart';
import 'package:cangurugestor/firebaseUtils/fire_login.dart';
import 'package:cangurugestor/firebaseUtils/fire_responsavel.dart';
import 'package:cangurugestor/firebaseUtils/firebase_auth_constants.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/login.dart';
import 'package:cangurugestor/model/pessoa.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAtuthState()) {
    on<InitEvent>((event, emit) {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        add(
          LoginEvent(
            user.providerData[0].methodLogin,
          ),
        );
      } else {
        emit(NotLoggedInAuthState(state.login));
      }
    });

    on<LoginEvent>(
      (event, emit) async {
        emit(LoadingAuthState(state.login));
        User? user;
        Login login = Login();
        if (event.methodAuthID == EnumMethodAuthID.google) {
          final GoogleLogin googleLogin = GoogleLogin();
          user = await googleLogin.loadUser();
          login = Login.init(login.pessoa, state.login.user);
        } else if (event.methodAuthID == EnumMethodAuthID.apple) {}

        if (user == null) {
          emit(
            ErrorAuthState('Não foi possível fazer o login!', state.login),
          );
        } else {
          login.pessoa =
              await FirestoreLogin().autenticarUsuarioEmail(user.email!);
          if (login.pessoa.id.isEmpty) {
            login.pessoa = Pessoa.fromUser(user);
            emit(FirstLoginAuthState(login));
          } else {
            emit(LoggedInAuthState(login));
          }
        }
      },
    );

    on<CreateLoginEvent>((event, emit) async {
      emit(LoadingAuthState(state.login));
      if (event.classeEscolhida == EnumClasse.gestor) {
        state.login.pessoa = await FirestoreGestor().create(state.login.pessoa);
      } else if (event.classeEscolhida == EnumClasse.cuidador) {
        state.login.pessoa = await FirestoreCuidador()
            .create(Cuidador.fromPessoa(state.login.pessoa));
      } else if (event.classeEscolhida == EnumClasse.responsavel) {
        state.login.pessoa = await FirestoreResponsavel()
            .create(Responsavel.fromPessoa(state.login.pessoa));
      }
      emit(LoggedInAuthState(state.login));
    });

    on<LogoutEvent>(
      (event, emit) async {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(
            ErrorAuthState('Não foi possível fazer o logout!', state.login),
          );
        } else {
          if (user.providerData[0].methodLogin == EnumMethodAuthID.google) {
            await GoogleLogin().logout();
          } else if (user.providerData[0].methodLogin ==
              EnumMethodAuthID.apple) {
          } else {
            emit(
              ErrorAuthState('Não foi possível fazer o logout!', state.login),
            );
          }
          emit(NotLoggedInAuthState(state.login));
        }
      },
    );
  }
}
