import 'package:flutter/material.dart';
import 'package:yarnrates/component/drawer.dart';

import '../../Model/globals.dart';
import 'aboutus.dart';
import 'contactUs.dart';
import 'deliverSection.dart';
import 'mainSection.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var screenSize;
  var height;
  var width;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;

    return SafeArea(
      child: Scaffold(
        drawer: DrawerC(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // leadingWidth: ,
          // leading: Image.asset(
          //   'assets/YARNMARKETLOGO.png',
          //   // scale: 5,
          // ),
          // title: Image.asset(
          //   'assets/YARNMARKETLOGO.png',
          //   scale: 15,
          // ),
          actions: actionButtons(context),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              const MainSection(),
              const AboutUs(),
              DeliverSection(),
              ContactUs(),
            ],
          ),
        ),
      ),
    );
  }
}

actionButtons(context) {
  List<Widget> actions = [
    MaterialButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/homepage');
        },
        child: Wrap(
          children: [
            Icon(Icons.pages),
            Text("Products"),
          ],
        )),
    MaterialButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/analysis');
        },
        child: Wrap(
          children: [
            Icon(Icons.analytics),
            Text("Analysis"),
          ],
        )),
  ];
  if (globalUser != null) {
    // actions.add(
    //   MaterialButton(
    //       onPressed: () {
    //         Navigator.of(context).pushNamed('/addnew');
    //       },
    //       child: Wrap(
    //         children: [
    //           Icon(Icons.add),
    //           Text("Add New"),
    //         ],
    //       )),
    // );
    actions.add(
      MaterialButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/logout');
          },
          child: Wrap(
            children: [
              Icon(Icons.logout),
              Text("Logout"),
            ],
          )),
    );
  } else {
    actions.add(
      MaterialButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/login');
          },
          child: Wrap(
            children: [
              Icon(Icons.login),
              Text("Login"),
            ],
          )),
    );
  }
  return actions;
}
