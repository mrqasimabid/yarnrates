// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../Model/globals.dart';
import '../Model/tablerow.dart';
import '../pages/product_detail.dart';
import '../pages/updateprice.dart';
import '../pages/updatequalityparameters.dart';

class MainPageList extends StatefulWidget {
  late List<YarnRow> table = [];
  late Function reload;
  late bool admin;
  MainPageList({Key? key, t, r, a}) : super(key: key) {
    table = t;
    reload = r;
    admin = a;
  }

  @override
  State<MainPageList> createState() => _MainPageListState();
}

class _MainPageListState extends State<MainPageList> {
  ScrollController? controller;
  List<YarnRow> items = [];

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    items = List.generate(30, (index) => widget.table[index]);
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    // print(controller!.position.extentAfter);

    if (controller!.position.atEdge) {
      // if (controller!.position.extentAfter < 500) {
      setState(() {
        if (!((items.length + 30) > widget.table.length)) {
          items.addAll(List.generate(30, (index) => widget.table[index]));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.1,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  controller: controller!,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var e = widget.table[index];
                    // return Text(index.toString());
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage('assets/yarnPics/' +
                                ((widget.table.indexOf(e) % 25 + 1)
                                    .toString()) +
                                '.jpg'),
                            // radius: 25,
                          ),
                          collapsedBackgroundColor: mainColor,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [...getSmallCol(e.toMap())],
                          ),
                          children: [
                            Card(
                              color: mainColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/yarnPics/' +
                                          ((widget.table.indexOf(e) % 25 + 1)
                                              .toString()) +
                                          '.jpg'),
                                      fit: BoxFit.cover,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.black38,
                                        BlendMode.dstATop,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      ...e
                                          .toMap()
                                          .entries
                                          .map((el) => Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      cols['all']![el.key]!,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        // backgroundColor: mainColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      el.value.toString(),
                                                      // style: TextStyle(
                                                      //   backgroundColor: mainColor,
                                                      // ),
                                                    ),
                                                  ]))
                                          .toList(),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              MaterialButton(
                                                color: Colors.red[900],
                                                child: Text("Price History",
                                                    style: whiteText),
                                                onPressed: () {
                                                  Map<String, String> m = {};
                                                  m['id'] =
                                                      e.productID.toString();
                                                  Navigator.of(context)
                                                      .pushNamed('/history',
                                                          arguments: m);
                                                },
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              MaterialButton(
                                                color: Colors.blue[900],
                                                child: Text("Parameter History",
                                                    style: whiteText),
                                                onPressed: () {
                                                  Map<String, String> m = {};
                                                  m['id'] =
                                                      e.productID.toString();
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          '/parameterhistory',
                                                          arguments: m);
                                                },
                                              ),
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                          ),
                                          !widget.admin
                                              ? Container()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                      MaterialButton(
                                                        color:
                                                            Colors.yellow[900],
                                                        child: Text(
                                                            "Update Price",
                                                            style: whiteText),
                                                        onPressed: () async {
                                                          var status =
                                                              await Navigator.of(
                                                                      context)
                                                                  .push(
                                                            MaterialPageRoute<
                                                                String>(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  UpdatePrice(
                                                                row: e,
                                                              ),
                                                            ),
                                                          );
                                                          if (status != null &&
                                                              status ==
                                                                  "refresh") {
                                                            widget.reload();
                                                          }
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      MaterialButton(
                                                        color:
                                                            Colors.green[900],
                                                        child: Text(
                                                            "Update Quality Parameters",
                                                            style: whiteText),
                                                        onPressed: () async {
                                                          var status =
                                                              await Navigator.of(
                                                                      context)
                                                                  .push(
                                                            MaterialPageRoute<
                                                                String>(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  UpdateQualityParameters(
                                                                row: e,
                                                              ),
                                                            ),
                                                          );
                                                          if (status != null &&
                                                              status ==
                                                                  "refresh") {
                                                            widget.reload();
                                                          }
                                                        },
                                                      ),
                                                    ]),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MaterialButton(
                                                color: Colors.cyan[900],
                                                child: Text("Details",
                                                    style: whiteText),
                                                onPressed: () async {
                                                  List<YarnRow> recommendations = widget
                                                      .table
                                                      .where((element) =>
                                                          element.natureName ==
                                                              e.natureName &&
                                                          element.suitableFor ==
                                                              e.suitableFor &&
                                                          element.qualityName ==
                                                              e.qualityName &&
                                                          element.productID !=
                                                              e.productID)
                                                      .toList();

                                                  await Navigator.of(context)
                                                      .push(
                                                    MaterialPageRoute<String>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProductDetails(
                                                              a: widget.admin,
                                                              r: widget.reload,
                                                              e: e,
                                                              recommendations:
                                                                  recommendations),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    );
                  }),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextButton(
            //       onPressed: () {
            //         setState(() {
            //           var count = items.length - widget.table.length;
            //           if (count > 0)
            //             items.addAll(
            //                 List.generate(30, (index) => widget.table[index]));
            //           print("adding");
            //         });
            //       },
            //       child: const Text("Show More")),
            // )
          ],
        ),
      ),
    );
  }
}
