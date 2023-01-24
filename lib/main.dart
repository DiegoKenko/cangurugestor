import 'package:cangurugestor/firebase_options.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/viewModel/provider_atividade.dart';
import 'package:cangurugestor/viewModel/provider_consulta.dart';
import 'package:cangurugestor/viewModel/provider_cuidador.dart';
import 'package:cangurugestor/viewModel/provider_gestor.dart';
import 'package:cangurugestor/viewModel/provider_login.dart';
import 'package:cangurugestor/viewModel/provider_medicamento.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:cangurugestor/viewModel/provider_responsavel.dart';
import 'package:cangurugestor/viewModel/provider_tarefas.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/view/telas/tela_login.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => GestorProvider()),
        ChangeNotifierProvider(create: (context) => ResponsavelProvider()),
        ChangeNotifierProvider(create: (context) => PacienteProvider()),
        ChangeNotifierProvider(create: (context) => MedicamentoProvider()),
        ChangeNotifierProvider(create: (context) => ConsultaProvider()),
        ChangeNotifierProvider(create: (context) => AtividadeProvider()),
        ChangeNotifierProvider(create: (context) => TarefasProvider()),
        ChangeNotifierProvider(create: (context) => CuidadorProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('pt', 'BR')],
        theme: ThemeData(
          backgroundColor: corBranco,
          appBarTheme: const AppBarTheme(
            color: corPad1,
            iconTheme: IconThemeData(color: corBranco),
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: corPreto,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: corPad1,
                  width: 3,
                ),
                left: BorderSide(
                  color: corPad1,
                  width: 1,
                ),
                right: BorderSide(
                  color: corPad1,
                  width: 1,
                ),
                top: BorderSide(
                  color: corPad1,
                  width: 0.5,
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
        ),
        home: const Scaffold(
          body: TelaLogin(),
        ),
      ),
    );
  }
}
