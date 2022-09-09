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
          centerTitle: true,
          backgroundColor: Colors.transparent,
          // leadingWidth: ,
          // leading: Image.asset(
          //   'assets/YARNMARKETLOGO.png',
          //   // scale: 5,
          // ),
          // title: Image.asset(
          //   'assets/YARNMARKETLOGO.png',
          //   scale: 13,
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
          children: const [
            Icon(Icons.pages),
            SizedBox(width: 5),
            Text(
              "Products",
              style: TextStyle(fontSize: 18),
            ),
          ],
        )),
    MaterialButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/analysis');
      },
      child: Wrap(
        children: const [
          Icon(Icons.analytics),
          SizedBox(width: 5),
          Text(
            "Analysis",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    ),
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
              SizedBox(width: 5),
              Text(
                "Logout",
                style: TextStyle(fontSize: 18),
              ),
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
              SizedBox(width: 5),
              Text(
                "Login",
                style: TextStyle(fontSize: 18),
              ),
            ],
          )),
    );
  }
  return actions;
}
