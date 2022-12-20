import 'package:cangurugestor/firebase_options.dart';
import 'package:cangurugestor/ui/componentes/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/ui/telas/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'global.dart' as global;

void main() async {
  global.idGestorGlobal = '';
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
    return MaterialApp(
      theme: ThemeData(
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
    );
  }
}
