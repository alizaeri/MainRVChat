//palette.dart
import 'package:flutter/material.dart';

class MyColors {
  static const MaterialColor primaryWhite = MaterialColor(
    0xffff004e, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffff004e), //10%
      100: Color(0xffff004e), //20%
      200: Color(0xffff004e), //30%
      300: Color(0xffff004e), //40%
      400: Color(0xffff004e), //50%
      500: Color(0xffff004e), //60%
      600: Color(0xffff004e), //70%
      700: Color(0xffff004e), //80%
      800: Color(0xffff004e), //90%
      900: Color(0xffff004e), //100%
    },
  );
}
