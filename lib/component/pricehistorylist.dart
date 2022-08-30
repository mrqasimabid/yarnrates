import 'package:flutter/material.dart';

priceHistory(rates) {
  var rateCols = [
    {'rate_lbs': 'Rate'},
    {'dated': 'Date'},
  ];
  return rates.length == 0
      ? Center(
          child: Text("No Price History Found"),
        )
      : SingleChildScrollView(
          child: Column(children: [
            ...rates.map((e) {
              e = e as Map<String, dynamic>;
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...rateCols.map((eee) {
                      return Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: eee.entries.map((ee) {
                            return Column(children: [
                              Text(
                                ee.value.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                e[ee.key].toString(),
                                style: TextStyle(fontSize: 15),
                              )
                            ]);
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
          ]),
        );
}
