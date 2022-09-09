import 'dart:async';
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
      home: const SplashScreen(),
      // AnimatedSplashScreen(
      //   duration: 3000,
      //   splash: Image.asset(
      //     'assets/yarnmarketlogo.png',
      //   ),
      //   splashTransition: SplashTransition.fadeTransition,
      //   // nextScreen: LoginScreen()
      //   nextScreen: const LandingPage(),
      // ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, anotherAnimation) {
            return const LandingPage();
          },
          transitionDuration: const Duration(milliseconds: 3000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                parent: animation, curve: Curves.fastLinearToSlowEaseIn);
            return SlideTransition(
              // scale: animation,
              position: Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                  .animate(animation),
              child: child,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(29, 0, 33, 44),
            Colors.white,
            Colors.white,
            Color.fromARGB(36, 0, 35, 65),
          ],
        ),
      ),
      child: Center(
        child: Image.asset('assets/yarnmarketlogo.png'),
      ),
    );
  }
}
