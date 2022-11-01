import 'package:flutter/material.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/features/landing/screens/landing_screen.dart';
import 'package:rvchat/router.dart';
import 'package:rvchat/screens/mobile_layout_screen.dart';
import 'package:rvchat/screens/web_layout_screen.dart';
import 'package:rvchat/utils/responsive_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(color: appBarColor),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const LandingScreen(),
    );
  }
}
