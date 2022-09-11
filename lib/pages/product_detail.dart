// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:yarnrates/component/main_list.dart';
import 'package:yarnrates/component/product_card.dart';

import '../Model/tablerow.dart';

class ProductDetails extends StatefulWidget {
  late YarnRow row;
  late bool admin;
  late Function reload;
  List<YarnRow> alike = [];
  ProductDetails(
      {Key? key,
      required YarnRow e,
      required List<YarnRow> recommendations,
      a,
      r})
      : super(key: key) {
    reload = r;
    admin = a;

    row = e;
    alike = recommendations;
  }
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Product Details'),
          bottom: const TabBar(
            tabs: [
              Tab(
                  icon: Icon(Icons.production_quantity_limits),
                  text: "Product"),
              Tab(icon: Icon(Icons.recommend), text: "Recommendations")
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                ProductCard(e: widget.row),
                ListTile(
                    title: Text(widget.alike.isNotEmpty
                        ? "There are total ${widget.alike.length.toString()} alike Product"
                        : "No alike product"))
              ],
            ),
            MainPageList(
              a: widget.admin,
              r: widget.reload,
              t: widget.alike,
            )
          ],
        ),
      ),
    );
  }
}
