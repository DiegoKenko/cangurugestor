import 'package:cangurugestor/firebase_options.dart';
import 'package:cangurugestor/view/componentes/styles.dart';
import 'package:cangurugestor/viewModel/provider_atividade.dart';
import 'package:cangurugestor/viewModel/provider_consulta.dart';
import 'package:cangurugestor/viewModel/provider_gestor.dart';
import 'package:cangurugestor/viewModel/provider_login.dart';
import 'package:cangurugestor/viewModel/provider_medicamento.dart';
import 'package:cangurugestor/viewModel/provider_paciente.dart';
import 'package:cangurugestor/viewModel/provider_responsavel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/view/telas/tela_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'global.dart' as global;

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
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: corPad1,
            iconTheme: const IconThemeData(color: corBranco),
          ),
          tabBarTheme: TabBarTheme(
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
              ),
            ),
            unselectedLabelColor: corPreto,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          primaryColor: corPad1,
          hoverColor: corPad3,
          errorColor: const Color.fromARGB(248, 238, 136, 127),
          canvasColor: corPad3,
          splashColor: const Color.fromARGB(255, 238, 163, 0),
          fontFamily: GoogleFonts.raleway().fontFamily,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: corPad1),
        ),
        home: const Scaffold(
          body: TelaLogin(),
        ),
      ),
    );
  }
}
