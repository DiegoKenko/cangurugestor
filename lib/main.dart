import 'package:cangurugestor/bloc/bloc_auth_event.dart';
import 'package:cangurugestor/bloc/bloc_auth_state.dart';
import 'package:cangurugestor/firebase_options.dart';
import 'package:cangurugestor/global.dart';
import 'package:cangurugestor/model/cuidador.dart';
import 'package:cangurugestor/model/gestor.dart';
import 'package:cangurugestor/model/responsavel.dart';
import 'package:cangurugestor/view/componentes/circular_progress.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/bloc/bloc_auth.dart';
import 'package:cangurugestor/view/componentes/tooltip_login.dart';
import 'package:cangurugestor/viewModel/bloc_gestor.dart';
import 'package:cangurugestor/viewModel/bloc_atividade.dart';
import 'package:cangurugestor/viewModel/bloc_consulta.dart';
import 'package:cangurugestor/viewModel/bloc_cuidador.dart';
import 'package:cangurugestor/viewModel/bloc_medicamento.dart';
import 'package:cangurugestor/viewModel/bloc_paciente.dart';
import 'package:cangurugestor/viewModel/bloc_responsavel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/view/telas/tela_login.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  ErrorWidget.builder = (details) => Text(
        details.exceptionAsString(),
        style: const TextStyle(
          fontSize: 20,
        ),
      );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(InitEvent())),
        BlocProvider(create: (context) => GestorBloc()),
        BlocProvider(create: (context) => CuidadorBloc(Cuidador())),
        BlocProvider(create: (context) => ResponsavelBloc(Responsavel())),
        BlocProvider(create: (context) => GestorBloc()),
      ],
      child: MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('pt', 'BR')],
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            color: corPad1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
            iconTheme: IconThemeData(color: corBranco),
          ),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: corPad1),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2.5, color: corPad1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: corPreto,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: corPad1,
                  width: 4,
                ),
              ),
            ),
            unselectedLabelColor: corPreto,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          primaryColor: corPad1,
          hoverColor: corPad3,
          fontFamily: GoogleFonts.raleway().fontFamily,
          colorScheme: const ColorScheme(
            error: Colors.red,
            background: corBranco,
            brightness: Brightness.light,
            primary: corPad1,
            onPrimary: corBranco,
            onSecondary: corBranco,
            onSurface: corBranco,
            onBackground: corBranco,
            onError: corBranco,
            secondary: corPad2,
            surface: corBranco,
          ),
        ),
        home: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ErrorAuthState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is FirstLoginAuthState) {
              firstLoginDialog(context);
            }
          },
          builder: (context, state) {
            /// precisa melhorar isso aqui
            if (state is LoggedInAuthState) {
              if (state.login.classe == EnumClasse.gestor) {
                context
                    .read<GestorBloc>()
                    .add(GestorLoginEvent(state.login.pessoa as Gestor));
              } else if (state.login.classe == EnumClasse.responsavel) {
                context.read<ResponsavelBloc>().add(
                    ResponsavelLoginEvent(state.login.pessoa as Responsavel));
              } else if (state.login.classe == EnumClasse.cuidador) {
                context
                    .read<CuidadorBloc>()
                    .add(CuidadorLoginEvent(state.login.pessoa as Cuidador));
              }
              return state.login.route;
            } else if (state is LoadingAuthState) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressCanguru(),
                ),
              );
            }
            return const TelaLogin();
          },
        ),
      ),
    );
  }

  Future<dynamic> firstLoginDialog(BuildContext context) {
    EnumClasse? enumClasse;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (enumClasse != null) {
                context.read<AuthBloc>().add(CreateLoginEvent(enumClasse!));
              }
              Navigator.of(context).pop();
            },
            child: const Text('Confirmar'),
          ),
        ],
        title: Column(
          children: const [
            Text('Bem vindo', style: TextStyle(fontSize: 15)),
            Text(
              'Selecione o seu perfil',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        content: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: TooltipClassePessoa(
                        tip:
                            'É de minha responsabilidade gerir cuidadores de idosos, e seus cuidados aos pacientes dos meus clientes.',
                        title: 'Gestor',
                      ),
                    ),
                    Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: EnumClasse.gestor,
                      fillColor: MaterialStateProperty.all(corPad1),
                      groupValue: enumClasse,
                      onChanged: (classe) {
                        setState(() {
                          enumClasse = classe as EnumClasse;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: TooltipClassePessoa(
                        tip:
                            'Sou um cuidador de pessoas. Sou responsável por um ou mais pacientes.',
                        title: 'Cuidador',
                      ),
                    ),
                    Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      fillColor: MaterialStateProperty.all(corPad1),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: EnumClasse.cuidador,
                      groupValue: enumClasse,
                      onChanged: (classe) {
                        setState(() {
                          enumClasse = classe as EnumClasse;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: TooltipClassePessoa(
                        tip:
                            'O paciente que necessita de cuidados é meu familiar ou conhecido, e eu sou o responsável por ele.',
                        title: 'Responsável',
                      ),
                    ),
                    Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: EnumClasse.responsavel,
                      fillColor: MaterialStateProperty.all(corPad1),
                      groupValue: enumClasse,
                      onChanged: (classe) {
                        setState(() {
                          enumClasse = classe as EnumClasse;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
