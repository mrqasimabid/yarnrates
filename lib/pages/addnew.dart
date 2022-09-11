import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yarnrates/component/snackbar.dart';
import 'package:yarnrates/requests.dart';

import '../Model/globals.dart';

class AddNew extends StatefulWidget {
  const AddNew({Key? key}) : super(key: key);

  @override
  State<AddNew> createState() => _AddNewState();
}

List fields = [
  {
    'title': 'Mill',
    'controller': TextEditingController(),
    'data': 'mills',
    'save': 'mill_name',
    'field': 'mill_name'
  },
  {
    'title': 'Brand',
    'controller': TextEditingController(),
    'data': 'brand',
    'save': 'brand_name',
    'field': 'brand_name'
  },
  {
    'title': 'Nature',
    'controller': TextEditingController(),
    'save': 'nature_name',
    'data': 'nature',
    'field': 'nature_name'
  },
  {
    'title': 'Quality',
    'controller': TextEditingController(),
    'save': 'yarn_full_qaulity',
    'data': 'quality',
    'field': 'quality_name'
  },
  // {
  //   'title': 'Quality Name',
  //   'controller': TextEditingController(),
  //   'save': 'quality_name',
  //   'data': 'qualityname',
  //   'field': 'qualityname_name'
  // },
  // {
  //   'title': 'Suitable For',
  //   'controller': TextEditingController(),
  //   'data': 'suitable',
  //   'field': 'suitable_name',
  //   'save': 'suitable_for',
  // },
];

class _AddNewState extends State<AddNew> {
  bool loader = true;
  Future getData() async {
    var data = {};
    data['mills'] = await queryDB("SELECT * FROM mills");
    data['brand'] = await queryDB("SELECT * FROM brand");
    data['nature'] = await queryDB("SELECT * FROM nature");
    data['quality'] = await queryDB("SELECT * FROM quality");
    // data['qualityname'] = await queryDB("SELECT * FROM qualityname");
    // data['suitable'] = await queryDB("SELECT * FROM suitable");
    return data;
  }

  var data = {};
  @override
  void dispose() {
    reset();
    super.dispose();
  }

  reset() {
    for (var element in fields) {
      element['controller'].text = "";
    }
  }

  @override
  void initState() {
    getData().then((value) {
      data = value;
    }).whenComplete(() {
      loader = false;
      setState(() {});
    });

    super.initState();
  }

  final GlobalKey _pageKey = GlobalKey<ScaffoldState>();

  bool btnDisable = true;
  save() async {
    var f = {};
    var query =
        "INSERT INTO `product` (`mill_name`, `brand_name`, `nature_name`, `yarn_full_qaulity`) VALUES ";
    // "INSERT INTO `product` (`mill_name`, `brand_name`, `nature_name`, `yarn_full_qaulity`,`quality_name`, `suitable_for`) VALUES ";
    var vals = "(";
    int index = 0;
    for (var element in fields) {
      if (element['controller'].text.toString().isNotEmpty) {
        f[element['save']] = element['controller'].text;
        index++;
        if (index != fields.length) {
          vals = vals + "'" + element['controller'].text + "',";
        } else {
          vals = vals + "'" + element['controller'].text + "'";
        }
      }
    }

    vals = vals + ');';
    query += vals;
    var res = await insertDB(query);
    bool flag = res['status'] == "true";
    showSnackbar(key: _pageKey, msg: res['message'], status: flag);
    if (flag) {
      reset();
      setState(() {});
    }
  }

  validate() {
    bool flag = false;
    for (var element in fields) {
      if (element['controller'].text.toString().isEmpty) {
        flag = true;
      }
    }
    btnDisable = flag;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    validate();
    return Scaffold(
      key: _pageKey,
      appBar: AppBar(
        title: const Text("Add New Product"),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const AddNew(),
              ));
            },
            child: const Icon(Icons.refresh),
          ),
          MaterialButton(
            onPressed: btnDisable
                ? null
                : () {
                    save();
                  },
            child: const Icon(Icons.add),
            disabledColor: Colors.grey,
          )
        ],
      ),
      body: loader
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  ...fields.map((e) {
                    return TextField(
                      readOnly: true,
                      onTap: () async {
                        // print(data[e['data']].runtimeType);
                        dynamic d = await selectDropdown(
                            tablename: e['data'],
                            displayValue: e['field'],
                            context: context,
                            data: jsonDecode(data[e['data']]),
                            setState: setState,
                            hint: "Select ${e['title']}");
                        if (d != null) {
                          bool ok = true;
                          try {
                            e['controller'].text = d[e['field']];
                          } catch (e) {
                            ok = false;
                          }
                          if (!ok) {
                            e['controller'].text = d.toString();
                          }
                        }

                        setState(
                          () {},
                        );
                      },
                      controller: e['controller'],
                      decoration: InputDecoration(
                        label: Text(e['title']),
                      ),
                    );
                  }).toList()
                ]),
              ),
            ),
    );
  }
}
