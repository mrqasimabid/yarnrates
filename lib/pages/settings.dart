import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yarnrates/component/listfunctions.dart';
import 'package:yarnrates/requests.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool loader = true;
  var filter = {};

  @override
  void initState() {
    var query = "select * from filters;";
    queryDB(query).then((value) {
      filter = process(jsonDecode(value));
    }).whenComplete(() {
      loader = false;
      setState(() {});
    });

    super.initState();
  }

  bool _isSelected = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          centerTitle: true,
        ),
        body: InputChip(
          padding: const EdgeInsets.all(2.0),
          avatar: CircleAvatar(
            backgroundColor: Colors.pink.shade600,
            child: const Text('FD'),
          ),
          label: Text(
            'Flutter Devs',
            style: TextStyle(color: _isSelected ? Colors.white : Colors.black),
          ),
          selected: _isSelected,
          selectedColor: Colors.blue.shade600,
          onSelected: (bool selected) {
            setState(() {
              _isSelected = selected;
            });
          },
          onDeleted: () {},
        ));
  }
}
