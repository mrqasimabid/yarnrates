// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yarnrates/Model/globals.dart';
import 'package:yarnrates/Model/tablerow.dart';
import 'package:yarnrates/component/datepickers.dart';
import 'package:yarnrates/component/snackbar.dart';
import 'package:yarnrates/requests.dart';

import '../component/parametershistorylist.dart';

class UpdateQualityParameters extends StatefulWidget {
  UpdateQualityParameters({Key? key, this.row, this.productID})
      : super(key: key);
  YarnRow? row;
  String? productID;
  @override
  State<UpdateQualityParameters> createState() => _UpdatePriceState();
}

List<dynamic> parameters = [];
bool loader = true;
bool priceData = false;

class _UpdatePriceState extends State<UpdateQualityParameters> {
  Future previousPrice() async {
    var data = {};
    data['parameters'] = await queryDB(
        "Select * from quality_parameters where product_id=${widget.row!.productID}");
    return data;
  }

  refresh() {
    previousPrice().then((value) {
      parameters = jsonDecode(value['parameters']);
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
    allowSave = false;
    controllers.forEach((key, value) {
      if (value.text.isNotEmpty) {
        allowSave = true;
      } else {}
    });

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
        "INSERT INTO `quality_parameters` ( `dated`, `product_id`, `cf`, `cf%`, `strength`, `strenght%`, `single_yarn_strenght`,`single_yarn_strenght%`, `thick`, `thin`, `neps`, `warping`) VALUES ('${selectedDate.toString().split(".")[0]}', ${widget.row!.productID}, ${controllers['cf']!.text}, ${controllers['cf%']!.text}, ${controllers['strength']!.text},  ${controllers['strength%']!.text},${controllers['singleyarnstrength']!.text}, ${controllers['singleyarnstrength%']!.text}, ${controllers['thick']!.text}, ${controllers['thin']!.text}, ${controllers['neps']!.text},${controllers['warpings']!.text});";
    var res = await insertDB(query);
    bool flag = res['status'] == "true";
    showSnackbar(key: _pageKey, msg: res['message'], status: flag);
    if (flag) {
      reset();
    }
  }

  reset() {
    selectedDate = DateTime.now();
    controllers.forEach((key, value) {
      value.text = "";
    });
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    validate();
    return Scaffold(
        key: _pageKey,
        appBar: AppBar(
          title: const Text("Quality Parameters"),
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
                Tab(text: 'Update Parameters'),
                Tab(text: 'History'),
              ],
            ),
            Expanded(
              child: TabBarView(children: <Widget>[
                form(row, context, setState),
                parametersHistory(parameters),
              ]),
            ),
          ]));
}

form(row, context, setState) {
  return SingleChildScrollView(
    child: Column(
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
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: formFields(setState, context),
        ),
      ],
    ),
  );
}

var controllers = {
  'cf': TextEditingController(text: '0'),
  'cf%': TextEditingController(text: '0'),
  'strength': TextEditingController(text: '0'),
  'strength%': TextEditingController(text: '0'),
  'singleyarnstrength': TextEditingController(text: '0'),
  'singleyarnstrength%': TextEditingController(text: '0'),
  'thick': TextEditingController(text: '0'),
  'thin': TextEditingController(text: '0'),
  'neps': TextEditingController(text: '0'),
  'warpings': TextEditingController(text: '0'),
};
getField(title, controller, fun) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (c) {
          fun(() {});
        },
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          label: Text(title),
        ),
      ),
    ),
  );
}

getDateField(context, fun) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
    child: TextField(
      textAlign: TextAlign.center,
      controller: dateController,
      readOnly: true,
      onTap: () async {
        DateTime? date = await selectDate(context: context, date: selectedDate);
        if (date != null) {
          fun(() {
            selectedDate = date;
            dateController.text = selectedDate.toString().split(' ')[0];
          });
        }
      },
      decoration: const InputDecoration(labelText: "Date "),
    ),
  );
}

formFields(setState, context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      getDateField(context, setState),
      Row(
        children: [
          getField("CF", controllers['cf'], setState),
          getField("CF%", controllers['cf%'], setState),
        ],
      ),
      Row(
        children: [
          getField("Strength", controllers['strength'], setState),
          getField("Strength%", controllers['strength%'], setState),
        ],
      ),
      Row(
        children: [
          getField("Single Yarn Strength", controllers['singleyarnstrength'],
              setState),
          getField("Single Yarn Strength%", controllers['singleyarnstrength%'],
              setState),
        ],
      ),
      Row(
        children: [
          getField("Thick", controllers['thick'], setState),
          getField("Thin", controllers['thin'], setState),
        ],
      ),
      Row(
        children: [
          getField("Neps", controllers['neps'], setState),
          getField("Warping", controllers['warpings'], setState),
        ],
      ),
    ],
  );
}
