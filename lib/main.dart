import 'dart:math';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yarnrates/Model/tablerow.dart';
import 'package:yarnrates/component/drawer.dart';
import 'package:yarnrates/pages/landing/landing_page.dart';
import 'Model/globals.dart';
import 'route_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globalUser = await loadData();
  if (globalUser == null) {
    await logout();
  }
  final ran = Random().nextInt(appColors.length);
  mainColor = appColors[ran];
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: mainColor,
    statusBarColor: mainColor,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // isLoggedIn().then((val) {
    //   flag = val;
    // });
    // print(flag);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yarn Market',
      theme: ThemeData(primarySwatch: mainColor),
      onGenerateRoute: RouteGenerator.generateRoute,
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: Image.asset(
          'assets/yarnmarketlogo.png',
        ),
        splashTransition: SplashTransition.fadeTransition,
        // nextScreen: LoginScreen()
        nextScreen: const LandingPage(),
      ),
    );
  }
}

splash() {
  return Center(
    child: Stack(
      children: [
        const Text(
          "Yarn Market",
          style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontFamily: 'Anton'),
        ),
        Image.asset('assets/yarnmarketlogo.png'),
      ],
    ),
  );
}
