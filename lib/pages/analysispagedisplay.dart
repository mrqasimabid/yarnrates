// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:yarnrates/Model/globals.dart';
import 'package:yarnrates/component/pricehistorylist.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../component/chart.dart';

class AnalysisDisplay extends StatefulWidget {
  var rows;
  var table;
  AnalysisDisplay(this.rows, this.table, {Key? key}) : super(key: key);

  @override
  State<AnalysisDisplay> createState() => _AnalysisDisplayState();
}

class _AnalysisDisplayState extends State<AnalysisDisplay> {
  List<dynamic> rates = [];
  List<dynamic> table = [];

  tabController() {
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TabBar(
                labelColor: mainColor,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(text: 'Details'),
                  Tab(text: 'Analysis'),
                  Tab(text: 'Chart'),
                ],
              ),
              Expanded(
                child: TabBarView(
                    children: <Widget>[details(), analysis(rates), chart()]),
              )
            ]));
  }

  details() {
    List<Widget> widgets = [];
    try {
      for (var e in table) {
        List rows = rates
            .where((element) => element['product_id'] == e.productID)
            .toList();
        Widget w = Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
                textColor: Colors.white,
                collapsedTextColor: Colors.white,
                collapsedBackgroundColor: mainColor,
                title: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ...e
                            .toMap()
                            .entries
                            .map((el) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        cols['all']![el.key]!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Flexible(
                                        child: Text(
                                          el.value.toString(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ]))
                            .toList(),
                      ],
                    ),
                  ),
                ),
                children: [
                  priceHistory(rows),
                ]));
        widgets.add(w);
      }
    } catch (ex) {
      ex;
    }
    return SingleChildScrollView(child: Column(children: widgets));
  }

  analysis(List<dynamic> rates) {
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
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }

  chart() {
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
    rates = widget.rows;
    table = widget.table;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Analysis Display"),
        ),
        body: tabController());
  }
}
