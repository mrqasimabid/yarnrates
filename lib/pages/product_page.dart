
import 'package:flutter/material.dart';

import '../Model/globals.dart';
import '../Model/tablerow.dart';
import '../Model/yarndatafunction.dart';
import '../component/main_list.dart';
dynamic data;
List<YarnRow> table = [];
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
      // drawer: const DrawerC(),
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
