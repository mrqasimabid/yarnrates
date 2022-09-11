// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yarnrates/Model/globals.dart';
import 'package:yarnrates/Model/tablerow.dart';
import 'package:yarnrates/component/confirmation.dart';
import 'package:yarnrates/component/datepickers.dart';
import 'package:yarnrates/component/pricehistorylist.dart';
import 'package:yarnrates/component/snackbar.dart';
import 'package:yarnrates/requests.dart';

class UpdatePrice extends StatefulWidget {
  UpdatePrice({Key? key, this.row, this.productID}) : super(key: key);
  YarnRow? row;
  String? productID;
  @override
  State<UpdatePrice> createState() => _UpdatePriceState();
}

List<dynamic> prices = [];
bool loader = true;
bool priceData = false;

class _UpdatePriceState extends State<UpdatePrice> {
  Future previousPrice() async {
    var data = {};
    data['prices'] = await queryDB(
        "Select * from rates where product_id=${widget.row!.productID}");
    return data;
  }

  refresh() {
    previousPrice().then((value) {
      prices = jsonDecode(value['prices']);
    }).whenComplete(() {
      loader = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  bool allowSave = false;
  validate() {
    if (updateController.text.isEmpty) {
      allowSave = false;
    } else {
      allowSave = true;
    }
    setState(() {});
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }

  final GlobalKey _pageKey = GlobalKey<ScaffoldState>();

  update() async {
    var query =
        "INSERT INTO `rates` (`product_id`, `dated`, `rate_lbs`) VALUES (${widget.row!.productID}, '${selectedDate.toString().split(".")[0]}', ${updateController.text});";
    var res = await insertDB(query);
    bool flag = res['status'] == "true";
    showSnackbar(key: _pageKey, msg: res['message'], status: flag);
    if (flag) {
      reset();
    }
  }

  reset() {
    selectedDate = DateTime.now();
    updateController.text = "";
    refresh();
  }

  removeData() async {
    showSnackbar(key: _pageKey, msg: "Deleting Product", status: true);

    var query =
        "Delete from product where product_id = ${widget.row!.productID};";
    var res = await insertDB(query);
    bool flag = res['status'] == "true";
    if (flag) {
      showSnackbar(key: _pageKey, msg: "Deleting Rates", status: true);
      var query =
          "Delete from rates where product_id = ${widget.row!.productID};";
      var res = await insertDB(query);
      bool flag = res['status'] == "true";
      if (flag) {
        Navigator.of(context).pop("refresh");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    validate();
    return Scaffold(
        key: _pageKey,
        appBar: AppBar(
          title: const Text("Update Price"),
          actions: [
            MaterialButton(
                disabledColor: Colors.grey,
                color: Colors.green[500],
                onPressed: !allowSave
                    ? null
                    : () {
                        update();
                      },
                child: const Icon(Icons.add)),
            MaterialButton(
                color: Colors.red[700],
                onPressed: () async {
                  bool flag = await confirmationDialog(context);
                  flag ? removeData() : null;
                },
                child: const Icon(Icons.delete_forever)),
          ],
        ),
        body: loader
            ? const Center(child: CircularProgressIndicator())
            : tabController(widget.row, context, setState));
  }
}

var updateController = TextEditingController();
var dateController = TextEditingController(text: DateTime.now().toString());
DateTime selectedDate = DateTime.now();

tabController(row, context, setState) {
  return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TabBar(
              labelColor: mainColor,
              unselectedLabelColor: Colors.black,
              tabs: const [
                Tab(text: 'Update Price'),
                Tab(text: 'History'),
              ],
            ),
            Expanded(
              child: TabBarView(children: <Widget>[
                form(row, context, setState),
                priceHistory(prices),
              ]),
            ),
          ]));
}

form(row, context, setState) {
  return Column(
    children: [
      Card(
        color: mainColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
      ),
      Padding(
        padding: const EdgeInsets.all(30),
        child: formFields(setState, context),
      ),
    ],
  );
}

formFields(setState, context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextField(
        onChanged: (c) {
          setState(() {});
        },
        controller: updateController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          label: Text("Price"),
        ),
      ),
      TextField(
        textAlign: TextAlign.center,
        controller: dateController,
        readOnly: true,
        onTap: () async {
          DateTime? date =
              await selectDate(context: context, date: selectedDate);
          if (date != null) {
            setState(() {
              selectedDate = date;
              dateController.text = selectedDate.toString().split(' ')[0];
            });
          }
        },
        decoration: const InputDecoration(labelText: "Date "),
      )
    ],
  );
}
