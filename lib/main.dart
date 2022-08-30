import 'dart:math';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yarnrates/Model/tablerow.dart';
import 'package:yarnrates/component/drawer.dart';
import 'package:yarnrates/pages/updateprice.dart';
import 'Model/globals.dart';
import 'Model/yarndatafunction.dart';
import 'component/main_list.dart';
import 'pages/product_detail.dart';
import 'pages/updatequalityparameters.dart';
import 'route_generator.dart';

dynamic data;
List<YarnRow> table = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      title: 'Yarn Rates',
      theme: ThemeData(primarySwatch: mainColor),
      onGenerateRoute: RouteGenerator.generateRoute,
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: Image.asset(
          'assets/yarn.png',
        ),
        splashTransition: SplashTransition.fadeTransition,
        // nextScreen: LoginScreen()
        nextScreen: const MyHomePage(title: 'Yarn Rates'),
      ),
    );
  }
}

splash() {
  return Center(
    child: Stack(
      children: [
        const Text(
          "Yarn Rates",
          style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontFamily: 'Anton'),
        ),
        Image.asset('assets/yarn.png'),
      ],
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  reload() {
    loader = true;
    setState(() {});
    yarnRows().then((v) {
      data = v;
      table = data['table'];
      loader = false;
      setState(() {});
    });
  }

  bool loader = true;
  @override
  void initState() {
    super.initState();
    reload();
  }

  var searchController = TextEditingController();
  Map<String, Map<String, dynamic>> filters = {
    'mills': {
      'value': '',
      'controller': TextEditingController(),
      'filter': 'mill_name'
    },
  };
  var c = TextEditingController();
  bool admin = false;
  bool flag = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const DrawerC(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          MaterialButton(
            onPressed: () {
              reload();
            },
            child: const Icon(
              Icons.refresh,
              // color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing: InkWell(
                    child: const Icon(Icons.cancel),
                    onTap: () {
                      table = data['table'];

                      searchController.text = '';

                      setState(() {});
                    },
                  ),
                  title: TextField(
                    onChanged: (value) {
                      List<YarnRow> t = data['table'];
                      var values = value.split(' ');
                      if (value.isEmpty) {
                      } else {
                        table = t.where((obj) {
                          var ele = obj.toMap().toString();
                          List<bool> flags = [];
                          for (var element in values) {
                            bool flag = ele
                                .toLowerCase()
                                .contains(element.toLowerCase());
                            flags.add(flag);
                          }
                          return !flags.contains(false);
                        }).toList();
                      }
                      setState(() {});
                    },
                    controller: searchController,
                    decoration: const InputDecoration(
                      label: Text("Search"),
                    ),
                  ),
                ),
              ),
              loader
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : listViewMode(size)
            ],
          ),
        ),
      ),
    );
  }

  listViewMode(size) {
    isLoggedIn().then((v) {
      // print(v);
      if (v == null) {
        v = false;
      }
      admin = v;
      flag = false;
      setState(() {});
    }).whenComplete(() {});
    return flag
        ? const CircularProgressIndicator()
        : SizedBox(
            height: size.height / 1.1,
            child: MainPageList(
              a: admin,
              r: reload,
              t: table,
            ),
          );
  }
}
