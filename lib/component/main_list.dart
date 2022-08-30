import 'package:flutter/material.dart';

import '../Model/globals.dart';
import '../Model/tablerow.dart';
import '../pages/product_detail.dart';
import '../pages/updateprice.dart';
import '../pages/updatequalityparameters.dart';

class MainPageList extends StatelessWidget {
  late List<YarnRow> table = [];
  late Function reload;
  late bool admin;
  MainPageList({Key? key, t, r, a}) : super(key: key) {
    table = t;
    reload = r;
    admin = a;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: table
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/yarnPics/' +
                          ((table.indexOf(e) % 25 + 1).toString()) +
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
                                    ((table.indexOf(e) % 25 + 1).toString()) +
                                    '.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                cols['all']![el.key]!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
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
                                            m['id'] = e.productID.toString();
                                            Navigator.of(context).pushNamed(
                                                '/history',
                                                arguments: m);
                                          },
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        MaterialButton(
                                          color: Colors.blue[900],
                                          child: Text("Parameter History",
                                              style: whiteText),
                                          onPressed: () {
                                            Map<String, String> m = {};
                                            m['id'] = e.productID.toString();
                                            Navigator.of(context).pushNamed(
                                                '/parameterhistory',
                                                arguments: m);
                                          },
                                        ),
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                    ),
                                    !admin
                                        ? Container()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                                MaterialButton(
                                                  color: Colors.yellow[900],
                                                  child: Text("Update Price",
                                                      style: whiteText),
                                                  onPressed: () async {
                                                    var status =
                                                        await Navigator.of(
                                                                context)
                                                            .push(
                                                      MaterialPageRoute<String>(
                                                        builder: (BuildContext
                                                                context) =>
                                                            UpdatePrice(
                                                          row: e,
                                                        ),
                                                      ),
                                                    );
                                                    if (status != null &&
                                                        status == "refresh") {
                                                      reload();
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                MaterialButton(
                                                  color: Colors.green[900],
                                                  child: Text(
                                                      "Update Quality Parameters",
                                                      style: whiteText),
                                                  onPressed: () async {
                                                    var status =
                                                        await Navigator.of(
                                                                context)
                                                            .push(
                                                      MaterialPageRoute<String>(
                                                        builder: (BuildContext
                                                                context) =>
                                                            UpdateQualityParameters(
                                                          row: e,
                                                        ),
                                                      ),
                                                    );
                                                    if (status != null &&
                                                        status == "refresh") {
                                                      reload();
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
                                          child:
                                              Text("Details", style: whiteText),
                                          onPressed: () async {
                                            print(e);
                                            List<YarnRow> recommendations =
                                                table
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
                                            var status =
                                                await Navigator.of(context)
                                                    .push(
                                              MaterialPageRoute<String>(
                                                builder: (BuildContext
                                                        context) =>
                                                    ProductDetails(
                                                        a: admin,
                                                        r: reload,
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
              ))
          .toList(),
    );
  }
}
