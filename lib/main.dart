import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:rvchat/app_loader.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loaderW.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/landing/screens/landing_screen.dart';
import 'package:rvchat/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rvchat/utils/manage_camera.dart';
import 'package:rvchat/widgets/error.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'Intro_screens/onboarding_screen.dart';
import 'firebase_options.dart';
import 'g.dart';
import 'screens/mobile_layout_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await CameraManager.instance.init();
  MobileAds.instance.initialize();
  // await AppLoader.init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  ConsumerState<MyApp> createState() => _MyApp();
}

class _MyApp extends ConsumerState<MyApp> {
  bool? _isFirstRun;
  @override
  void initState() {
    _checkFirstRun();
    // TODO: implement initState
    super.initState();
  }

  void _checkFirstRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    setState(() {
      _isFirstRun = ifr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rvchat UI',
      onGenerateRoute: (settings) => generateRoute(settings),
      theme: ThemeData(
          scaffoldBackgroundColor: whiteW1,
          dividerTheme: DividerThemeData(
              color:
                  whiteW1.withOpacity(0.3) //  <--- change the divider's color
              )),
      home: _isFirstRun == true
          ? const OnBoardingScreen()
          : ref.watch(userDataAuthProvider).when(
              data: (user) {
                if (user == null) {
                  return const LandingScreen();
                }
                return const MobileLayoutScreen();
              },
              error: (err, trace) {
                return ErrorScreen(
                  error: err.toString(),
                );
              },
              loading: () => const LoaderW()),
    );
  }
}
