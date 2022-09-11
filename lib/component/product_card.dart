// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../Model/globals.dart';
import '../Model/tablerow.dart';

class ProductCard extends StatelessWidget {
  late YarnRow row;
  ProductCard({Key? key, required YarnRow e}) : super(key: key) {
    row = e;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: mainColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...row
                .toMap()
                .entries
                .map((el) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cols['all']![el.key]!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(el.value.toString()),
                        ]))
                .toList(),
          ],
        ),
      ),
    );
  }
}
