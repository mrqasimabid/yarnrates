import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yarnrates/Model/globals.dart';
import 'package:yarnrates/Model/tablerow.dart';
import 'package:yarnrates/Model/yarndatafunction.dart';
import 'package:yarnrates/component/datepickers.dart';
import 'package:yarnrates/component/listfunctions.dart';
import 'package:yarnrates/component/snackbar.dart';
import 'package:yarnrates/requests.dart';

import 'analysispagedisplay.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  var filter = {};
  List<YarnRow> table = [];

  bool loader = true;
  bool dataLoader = false;
  @override
  void initState() {
    var query = "select * from filters;";
    queryDB(query).then((value) {
      filter = process(jsonDecode(value));
      // query = "select suitable_name as name from suitable";
      // queryDB(query).then((value2) {
      // filter['suitableFor'] = processSuitable(jsonDecode(value2));
      // }).whenComplete(() {});
    }).whenComplete(() {});
    yarnRows().then((value) {
      table = value['table'];
    }).whenComplete(() {
      loader = false;
      print(filter);
      setState(() {});
    });

    super.initState();
  }

  bool disableBtn = true;
  validate() {
    if (rangeController.text.isNotEmpty && true
        // qualityController.text.isNotEmpty
        ) {
      disableBtn = false;
    } else {
      disableBtn = !false;
    }
    setState(() {});
  }

  getRange() {
    List range = rangeController.text.split('-');
    int start = int.parse(range[0]);
    int end = int.parse(range[1]);

    return [for (var i = start; i <= end; i++) i.toString()];
  }

  // qualityFilter(quality) {
  //   return table.where((element) => element.yarnFullQaulity.contains(quality));
  // }

  // suitableForFilter(suitable, table4) {
  //   List<YarnRow> table1 = table4;
  //   return table1
  //       .where((element) => element.suitableFor
  //           .toLowerCase()
  //           .contains(suitable.toString().toLowerCase()))
  //       .toList();
  // }

  rangeFilter(range, table2) {
    List<YarnRow> table3 = [];

    range.forEach((e) {
      List<YarnRow> rows = table2
          .where((element) =>
              element.yarnFullQaulity.split(' ')[0] == (e) ||
              element.yarnFullQaulity.split(' ')[0] == (e + 'S'))
          .toList();
      table3.addAll(rows);
    });
    return table3;
  }

  filterData() async {
    dataLoader = true;
    setState(() {});
    // String quality = qualityController.text;
    // String suitable = suitableController.text;
    // var qualityData = qualityFilter(quality);

    List range = getRange();
    // var table3 = rangeFilter(range, qualityData);
    var table3 = rangeFilter(range, table);

    // if (suitable.isNotEmpty) {
    // table3 = suitableForFilter(suitable, table3);
    // }

    if (table3.isNotEmpty) {
      var ids = [];
      table3.forEach((e) {
        ids.add(e.productID);
      });
      var query = "SELECT * FROM rates where product_id in $ids ";
      query = query.replaceAll('[', '(').replaceAll(']', ')');
      print(query);
      List<dynamic> rates = jsonDecode(await queryDB(query));

      if (dateController.text.isNotEmpty) {
        var dates = dateController.text.split(' to ');
        var from = DateTime.parse(dates[0]);
        var to = DateTime.parse(dates[1]);

        rates = rates.where((element) {
          var date = DateTime.parse(element['dated']);
          return date.isAfter(from) && date.isBefore(to);
        }).toList();
      }

      if (rates.isNotEmpty) {
        showSnackbar(
            key: pageKey, msg: "${rates.length} Records Found ", status: true);

        try {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  AnalysisDisplay(rates, table3)));
        } catch (ex) {
          print(ex);
        }
      } else {
        showSnackbar(
            key: pageKey,
            msg: "No data Found Between Date Range",
            status: false);
      }
    } else {
      showSnackbar(
          key: pageKey,
          msg: "No data found for selected Filter",
          status: false);
    }
    dataLoader = false;
    setState(() {});
  }

  var rangeController = TextEditingController();
  // var qualityController = TextEditingController();
  // var suitableController = TextEditingController();
  var dateController = TextEditingController();
  var pageKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    validate();
    return Scaffold(
      key: pageKey,
      appBar: AppBar(
        actions: [
          MaterialButton(
              disabledColor: Colors.grey,
              onPressed: disableBtn
                  ? null
                  : () {
                      filterData();
                    },
              child: const Icon(Icons.search))
        ],
        title: const Text("Analysis"),
        centerTitle: true,
      ),
      body: loader
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  dataLoader ? const LinearProgressIndicator() : Container(),
                  ListTile(
                    trailing: TextButton(
                      child: const Icon(Icons.cancel),
                      onPressed: () {
                        rangeController.text = "";
                        setState(() {});
                      },
                    ),
                    title: TextField(
                      readOnly: true,
                      onTap: () async {
                        dynamic d = await selectDropdown(
                            displayValue: '',
                            context: context,
                            data: jsonDecode(filter['ranges']
                                .toString()
                                .replaceAll("'", '"')),
                            setState: setState,
                            hint: "Select Range");
                        if (d != null) rangeController.text = d;

                        setState(
                          () {},
                        );
                      },
                      controller: rangeController,
                      decoration: const InputDecoration(
                        label: Text("Range"),
                      ),
                    ),
                  ),
                  // ListTile(
                  //   trailing: TextButton(
                  //     child: const Icon(Icons.cancel),
                  //     onPressed: () {
                  //       qualityController.text = "";
                  //       setState(() {});
                  //     },
                  //   ),
                  //   title: TextField(
                  //     readOnly: true,
                  //     onTap: () async {
                  //       dynamic d = await selectDropdown(
                  //           displayValue: '',
                  //           context: context,
                  //           data: jsonDecode(filter['quality_name']),
                  //           setState: setState,
                  //           hint: "Select Quality");
                  //       if (d != null) qualityController.text = d.toString();

                  //       setState(
                  //         () {},
                  //       );
                  //     },
                  //     controller: qualityController,
                  //     decoration: const InputDecoration(
                  //       label: Text("Quality"),
                  //     ),
                  //   ),
                  // ),
                  // ListTile(
                  //   trailing: TextButton(
                  //     child: const Icon(Icons.cancel),
                  //     onPressed: () {
                  //       suitableController.text = "";
                  //       setState(() {});
                  //     },
                  //   ),
                  //   title: TextField(
                  //     readOnly: true,
                  //     onTap: () async {
                  //       print(filter['suitableFor']);
                  //       dynamic d = await selectDropdown(
                  //           displayValue: '',
                  //           context: context,
                  //           data: filter['suitableFor'],
                  //           setState: setState,
                  //           hint: "Select Suitable");
                  //       if (d != null) suitableController.text = d.toString();

                  //       setState(
                  //         () {},
                  //       );
                  //     },
                  //     controller: suitableController,
                  //     decoration: const InputDecoration(
                  //       label: Text("Suitable For"),
                  //     ),
                  //   ),
                  // ),
                  ListTile(
                    trailing: TextButton(
                      child: const Icon(Icons.cancel),
                      onPressed: () {
                        dateController.text = "";
                        setState(() {});
                      },
                    ),
                    title: TextField(
                      readOnly: true,
                      onTap: () async {
                        dynamic d = await selectDateRange(context: context);
                        print(d);
                        d = processDate(d);
                        if (d != null) dateController.text = d.toString();
                        setState(
                          () {},
                        );
                      },
                      controller: dateController,
                      decoration: const InputDecoration(
                        label: Text("Date Range"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  processDate(d) {
    d = d.toString().split(' ');
    return d[0] + ' to ' + d[3];
  }
}
