// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../requests.dart';

var globalUser;

var globalImage = 'https://mrqasimabid.pythonanywhere.com/static/yarn_images/';

MaterialColor? mainColor = Colors.blue;
List<MaterialColor> appColors = [
  Colors.teal,
  Colors.brown,
  Colors.blueGrey,
  Colors.green,
];

var cols = {
  'small': {
    'brand_name': 'Brand Name',
    'yarn_full_qaulity': 'Yarn Quality',
  },
  'all': {
    // 'quality_name': 'Quality',
    'mill_name': 'Spinning Mill',
    // 'suitable_for': 'Suitable For',
    'nature_name': 'Nature',
    'brand_name': 'Brand Name',
    'yarn_full_qaulity': 'Yarn Quality',
  },
};

millsDropdown(data) {
  List<DropdownMenuItem<dynamic>> drop = [];
  data.forEach((e) {
    drop.add(DropdownMenuItem<dynamic>(
      child: Text(e.name),
      value: e.id,
    ));
  });
  return drop;
}

tableCol() {
  List<DataColumn> l = [];
  cols['small']!.forEach((key, value) {
    l.add(DataColumn(
      label: SizedBox(
        width: 10,
        child: Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.visible,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      onSort: (index, b) {},
    ));
  });
  return l;
}

getSmallCol(data) {
  List<Widget> columns = [];
  cols['small']!.forEach((key, value) {
    columns.add(Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            data[key].toString(),
            style: const TextStyle(fontSize: 15),
          )
        ],
      ),
    ));
  });
  return columns;
}

tableDataRow(data, index) {
  var d = data[index].toMap();
  List<DataCell> cells = [];
  cols['small']!.forEach((key, value) {
    cells.add(
      DataCell(SizedBox(width: 80, child: Text(d[key])), onTap: () {}),
    );
  });

  return DataRow(
    cells: cells,
  );
}

Widget dropdownDialog({
  required String tablename,
  required BuildContext context,
  String? hint,
  String displayValue = 'name',
  required List<dynamic> data,
  required void Function(void Function() fn) setState,
}) {
  final GlobalKey key = GlobalKey<ScaffoldState>();

  List<dynamic> sortedList = data;
  bool searching = true;
  String currentText = '';
  bool saving = false;
  return StatefulBuilder(
    key: key,
    builder: (context, setState) {
      if (searching) {
        sortedList = data;
      }
      sortList(value) {
        value = value.toString().trim();
        currentText = value;
        if (value.length > 0) {
          setState(() {
            searching = false;
          });
          if (value.toString().isEmpty) {
            setState(() {
              sortedList = data;
            });
          } else {
            setState(() {
              try {
                sortedList = data
                    .where((element) => getDisplayValue(displayValue, element)
                        .toLowerCase()
                        .contains(value.toString().toLowerCase()))
                    .toList();
              } catch (err) {
                sortedList = data
                    .where((element) => getDisplayValue(displayValue, element)
                        .toLowerCase()
                        .contains(value.toString().toLowerCase()))
                    .toList();
              }
            });
          }
          if (sortedList.isEmpty) {
          } else {
          }
          setState(() {});
        }
      }

      return SizedBox(
        height: 330,
        width: 330,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              autofocus: true,
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                border: OutlineInputBorder(),
                prefixIcon: null,
                suffixIcon: Icon(
                  Icons.search,
                ),
              ),
              onChanged: (value) {
                sortList(value);
              },
            ),
            sortedList.isEmpty
                ? Center(
                    child: Column(
                  children: [
                    saving
                        ? const LinearProgressIndicator()
                        : MaterialButton(
                            onPressed: () async {
                              saving = true;
                              setState(() {});
                              String query =
                                  "INSERT INTO $tablename($displayValue) VALUE ('$currentText')";
                              var res = await insertDB(query);
                              if (res['status'] == "true") {
                                Navigator.of(context).pop(currentText);
                              }
                            },
                            child: const Icon(Icons.add)),
                  ],
                ))
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: sortedList.length,
                      itemBuilder: (BuildContext context, int index) {
                        try {
                          return ListTile(
                            leading: Text((index + 1).toString()),
                            title: Text(getDisplayValue(
                                displayValue, sortedList[index])),
                            onTap: () {
                              Navigator.pop(context, sortedList[index]);
                            },
                          );
                        } catch (err) {
                          rethrow;
                        }
                      },
                    ),
                  ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> selectDropdown({
  String tablename = '',
  required BuildContext context,
  dynamic data,
  String? hint,
  String displayValue = 'name',
  required void Function(void Function() fn) setState,
}) async {
  dynamic picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Text(hint!),
            content: dropdownDialog(
              tablename: tablename,
              context: context,
              data: data,
              displayValue: displayValue,
              setState: setState,
            ),
          );
        });
      });
  if (picked != null) {
    return picked;
  }
}

dynamic getDisplayValue(String propertyName, dynamic data) {
  try {
    var mapRep = (data is Map) ? data : data.toMap();
    if (mapRep.containsKey(propertyName)) {
      return mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  } catch (ex) {
    return data;
  }
}

dropdownTextField(data, name, context, setState, alter, tablename) {
  return TextField(
    readOnly: true,
    onTap: () async {
      dynamic d = await selectDropdown(
          tablename: tablename,
          context: context,
          data: data,
          setState: setState,
          hint: "Select $name");
      if (d != null) {
        alter.value = d.name;
        setState(
          () {},
        );
      }
    },
    decoration: InputDecoration(labelText: name, hintText: alter.value),
  );
}

isLoggedIn() async {
  var prefs = await SharedPreferences.getInstance();
  var flag = prefs.getBool('login');
  flag ??= false;
  return flag;
}

logout() async {
  var prefs = await SharedPreferences.getInstance();
  globalUser = null;
  await prefs.remove('user');
  return prefs.setBool('login', false);
}

loadData() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('user')) {
    var data = jsonDecode(prefs.getString('user')!);
    return data;
  } else {
    return null;
  }
}

TextStyle whiteText = const TextStyle(color: Colors.white);
