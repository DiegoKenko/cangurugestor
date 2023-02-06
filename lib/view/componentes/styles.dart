import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kHintTextStyle = TextStyle(
  color: const Color(0xFF527DAA),
  fontFamily: GoogleFonts.raleway().fontFamily,
);

final kInputStyle = TextStyle(
  color: corPad1,
  letterSpacing: 1.3,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: GoogleFonts.raleway().fontFamily,
);

final kTextStyleHeader = TextStyle(
  color: corPreto,
  letterSpacing: 1.3,
  fontSize: 15,
  fontFamily: GoogleFonts.raleway().fontFamily,
);

final kTituloStyle = TextStyle(
  color: corPreto,
  letterSpacing: 1.7,
  fontSize: 18,
  fontFamily: GoogleFonts.raleway().fontFamily,
);
final kTituloStyleVerde = TextStyle(
  color: corPad1,
  letterSpacing: 3,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  fontFamily: GoogleFonts.raleway().fontFamily,
);

final kSubTituloStyle = TextStyle(
  color: corPreto,
  letterSpacing: 1.7,
  fontSize: 18,
  fontFamily: GoogleFonts.raleway().fontFamily,
);

final kLabelStyle = TextStyle(
  color: corPad1,
  fontSize: 16,
  letterSpacing: 2.5,
  fontWeight: FontWeight.normal,
  fontFamily: GoogleFonts.raleway().fontFamily,
);

final kLabelLogin = TextStyle(
  color: corPad1,
  fontSize: 17,
  letterSpacing: 2.3,
  fontWeight: FontWeight.bold,
  fontFamily: GoogleFonts.raleway().fontFamily,
);

final kNameStyle = TextStyle(
  color: corBranco,
  fontSize: 15,
  wordSpacing: 2,
  letterSpacing: 3,
  fontWeight: FontWeight.bold,
  fontFamily: GoogleFonts.raleway().fontFamily,
);
final kTitleAppBarStyle = TextStyle(
  color: corBranco,
  fontSize: 18,
  wordSpacing: 2,
  letterSpacing: 2,
  fontFamily: GoogleFonts.raleway().fontFamily,
);
final kSubtitleAppBarStyle = TextStyle(
  color: corPreto,
  fontSize: 14,
  wordSpacing: 2,
  letterSpacing: 2,
  fontFamily: GoogleFonts.raleway().fontFamily,
);

final kSubtitleReportStyle = TextStyle(
  color: corPreto,
  fontSize: 16,
  wordSpacing: 2,
  letterSpacing: 2,
  fontFamily: GoogleFonts.raleway().fontFamily,
);

final kBoxDecorationStyle = BoxDecoration(
  borderRadius: BorderRadius.circular(5.0),
  border: Border.all(
    color: corPad1.withOpacity(0.4),
    width: 1.0,
  ),
);

final kBoxDecorationSetPaciente = BoxDecoration(
  borderRadius: BorderRadius.circular(5.0),
  border: Border.all(
    color: corPad3.withOpacity(0.4),
    width: 2.0,
  ),
  color: corPad1,
);

final kBoxDecorationSetMedicamento = BoxDecoration(
  borderRadius: BorderRadius.circular(5.0),
  border: Border.all(
    color: corPad1.withOpacity(0.4),
    width: 2.0,
  ),
  color: corPad3,
);

final kBoxDecorationLogin = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  border: Border.all(
    color: corPad1,
    width: 1.0,
  ),
);

final kBoxDecorationDropDown = BoxDecoration(
  border: Border.all(color: corPad1),
  borderRadius: BorderRadius.circular(20),
);

final kEditTarefaTextStyle = TextStyle(
  color: corPad1,
  fontSize: 17,
  fontFamily: GoogleFonts.raleway().fontFamily,
);

final kTabStyle = TextStyle(
  color: corPad1,
  fontSize: 17,
  fontFamily: GoogleFonts.raleway().fontFamily,
);

const corPad1 = Color(0xFF00A99D);
const corPad2 = Color(0xFF4D87FC);
const corPad3 = Color.fromARGB(255, 253, 253, 253);
const corPreto = Color.fromARGB(255, 0, 0, 0);
const corBranco = Color.fromARGB(255, 255, 255, 255);
const corTex2 = Color.fromARGB(255, 3, 3, 2);
const corBgr2 = Color.fromARGB(255, 240, 223, 208);

const kIconPaciente = Icon(
  Icons.person,
  color: corPreto,
);

const kIconCuidador = Icon(
  Icons.settings,
  color: corPreto,
);
const kIconResponsavel = Icon(
  Icons.settings,
  color: corPreto,
);

const kIconMedicamento = Icon(
  Icons.local_hospital,
  color: corPreto,
);

const kIconAtividade = Icon(
  Icons.accessibility,
  color: corPreto,
);

const kIconConsulta = Icon(
  Icons.schedule,
  color: corPreto,
);
