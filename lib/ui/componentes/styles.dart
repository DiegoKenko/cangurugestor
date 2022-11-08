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

final kInputStyle2 = TextStyle(
  color: corPreto,
  letterSpacing: 1.3,
  fontSize: 20,
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
  color: corPreto,
  fontSize: 15,
  wordSpacing: 2,
  letterSpacing: 3,
  fontWeight: FontWeight.bold,
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

const corPad1 = Color(0xFF00A99D);
const corPad2 = Color(0xFF4D87FC);
const corPad3 = Color.fromARGB(255, 253, 253, 253);
const corPreto = Color.fromARGB(255, 0, 0, 0);
const corTex2 = Color.fromARGB(255, 3, 3, 2);
const corBgr2 = Color.fromARGB(255, 240, 223, 208);
