import 'package:cangurugestor/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cangurugestor/ui/telas/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'global.dart' as global;

void main() async {
  global.idGestorGlobal = '';
  ErrorWidget.builder = (details) => Text(details.exceptionAsString());
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
        fontFamily: GoogleFonts.raleway().fontFamily,
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: TelaLogin(),
      ),
    );
  }
}
