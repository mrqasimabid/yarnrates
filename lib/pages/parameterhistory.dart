// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yarnrates/requests.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../component/chart.dart';
import '../component/parametershistorylist.dart';

class ParameterHistory extends StatefulWidget {
  String id;
  ParameterHistory(this.id, {Key? key}) : super(key: key);

  @override
  State<ParameterHistory> createState() => _ParameterHistoryState();
}

class _ParameterHistoryState extends State<ParameterHistory> {
  bool loader = true;
  List<dynamic> rates = [];
  bool noData = false;
  @override
  void initState() {
    super.initState();
    var q =
        "SELECT * from quality_parameters where product_id=${widget.id} order by dated desc";
    // q = "SELECT * from rates where product_id=5 order by dated desc";
    queryDB(q).then((value) {
      rates = jsonDecode(value);
      print(rates);
      if (rates.isEmpty) {
        noData = true;
      }
    }).whenComplete(() {
      loader = false;
      setState(() {});
    });
  }

  tabController() {
    return DefaultTabController(
        length: 1,
        initialIndex: 0,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const TabBar(
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: 'Parameter History'),
                  // Tab(text: 'Analysis'),
                  // Tab(text: 'Chart'),
                ],
              ),
              Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.5))),
                  child: TabBarView(children: <Widget>[
                    parametersHistory(rates),
                    // analysis(rates),
                    // chart()
                  ]))
            ]));
  }

  analysis(List<dynamic> rates) {
    return Container();
    double avg =
        rates.map((m) => m['rate_lbs']).reduce((a, b) => a + b) / rates.length;
    var maximumNumber = rates
        .map((m) => m['rate_lbs'])
        .reduce((value, element) => value > element ? value : element);
    var minimumNumber = rates
        .map((m) => m['rate_lbs'])
        .reduce((value, element) => value < element ? value : element);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Average"),
                Text(avg.ceil().toString()),
              ],
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Highest"),
                Text(maximumNumber.toString()),
              ],
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Lowest"),
                Text(minimumNumber.toString()),
              ],
            ),
          ),
          // ListTile(leading: Text("Avarage"), title: Text("232")),
        ],
      ),
    );
  }

  chart() {
    return Container();
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: charts.TimeSeriesChart(
                  createSampleData(rates),
                  animate: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Parameter History"),
          // title: const Text("Parameter History and Analysis"),
        ),
        body: noData
            ? const Center(
                child: Text("No Parameter History Found for This Product"))
            : loader
                ? const Center(child: CircularProgressIndicator())
                : tabController());
  }
}
