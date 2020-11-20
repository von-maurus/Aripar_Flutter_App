// Colors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryColors {
  static final blue = Color(0xFF0D47A1);
  static final purple = Color(0xFF5117AC);
  static final amber = Color(0xFFFF8F00);
  static final white = Color(0xFFFFFFFF);
  static final pink = Color(0xFFF5638B);
  static final darkGrey = Color(0xFF212121);
}

final deliveryGradients = [
  // cambiar a azul oscuro
  DeliveryColors.purple,
  DeliveryColors.blue
];

final _borderLight = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(
    color: DeliveryColors.amber,
    width: 2,
    style: BorderStyle.solid,
  ),
);

// final _borderDark = OutlineInputBorder(
//   borderRadius: BorderRadius.circular(10),
//   borderSide: BorderSide(
//     color: DeliveryColors.purple,
//     width: 2,
//     style: BorderStyle.solid,
//   ),
// );

final lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    color: DeliveryColors.blue,
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headline6: TextStyle(
        fontSize: 20,
        color: DeliveryColors.purple,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  canvasColor: DeliveryColors.white,
  accentColor: DeliveryColors.purple,
  bottomAppBarColor: DeliveryColors.purple,
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: DeliveryColors.white,
    displayColor: DeliveryColors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: _borderLight,
    enabledBorder: _borderLight,
    labelStyle: TextStyle(color: DeliveryColors.purple),
    focusedBorder: _borderLight,
    contentPadding: EdgeInsets.zero,
    hintStyle: GoogleFonts.poppins(
      color: DeliveryColors.purple,
      fontSize: 10,
    ),
  ),
  iconTheme: IconThemeData(
    color: DeliveryColors.purple,
  ),
);

// final darkTheme = ThemeData(
//   appBarTheme: AppBarTheme(
//     color: DeliveryColors.purple,
//     textTheme: GoogleFonts.poppinsTextTheme().copyWith(
//       headline6: TextStyle(
//         fontSize: 20,
//         color: DeliveryColors.white,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   ),
//   bottomAppBarColor: Colors.transparent,
//   canvasColor: DeliveryColors.grey,
//   scaffoldBackgroundColor: DeliveryColors.dark,
//   accentColor: DeliveryColors.white,
//   textTheme: GoogleFonts.poppinsTextTheme().apply(
//     bodyColor: DeliveryColors.green,
//     displayColor: DeliveryColors.green,
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     border: _borderDark,
//     enabledBorder: _borderDark,
//     contentPadding: EdgeInsets.zero,
//     focusedBorder: _borderDark,
//     labelStyle: TextStyle(color: DeliveryColors.white),
//     fillColor: DeliveryColors.grey,
//     filled: true,
//     hintStyle: GoogleFonts.poppins(
//       color: DeliveryColors.white,
//       fontSize: 10,
//     ),
//   ),
//   iconTheme: IconThemeData(
//     color: DeliveryColors.white,
//   ),
// );
