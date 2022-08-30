import 'package:flutter/material.dart';

import '../Model/globals.dart';

parametersHistory(rates) {
  var parameterCols = {
    'cf': 'CF',
    'cf%': 'CF%',
    'strength': 'Strength',
    'strenght%': 'Strenght%',
    'single_yarn_strenght': 'Single Yarn Strenght',
    'single_yarn_strenght%': 'Single Yarn Strenght%',
    'thick': 'Thick',
    'thin': 'Thin',
    'neps': 'Neps',
    'warping': 'Warping',
    'dated': 'Date',
  };
  return rates.length == 0
      ? const Center(
          child: Text("No History Found"),
        )
      : SingleChildScrollView(
          child: Column(children: [
            ...rates.map((e) {
              e = e as Map<String, dynamic>;
              e.remove('id');
              e.remove('product_id');
              return ListTile(
                title: Card(
                  color: mainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ...parameterCols.entries.map((el) {
                          print(parameterCols[el.key]);
                          print(el.value);
                          // return Container();
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  el.value.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(e[el.key].toString()),
                              ]);
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ]),
        );
}
