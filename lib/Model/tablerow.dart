// To parse this JSON data, do
//
//     final YarnRow = YarnRowFromMap(jsonString);

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<YarnRow> YarnRowFromMap(String str) =>
    List<YarnRow>.from(json.decode(str).map((x) => YarnRow.fromMap(x)));

String YarnRowToMap(List<YarnRow> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class YarnRow {
  YarnRow({
    required this.yarnFullQaulity,
    required this.brandName,
    required this.qualityName,
    required this.natureName,
    required this.suitableFor,
    required this.productID,
    // required this.dated,
    required this.millName,
  });

  String yarnFullQaulity;
  String brandName;
  String qualityName;
  String natureName;
  String suitableFor;
  int productID;
  // String dated;
  String millName;

  factory YarnRow.fromMap(Map<String, dynamic> json) => YarnRow(
        yarnFullQaulity: json["yarn_full_qaulity"],
        brandName: json["brand_name"],
        qualityName: json["quality_name"],
        natureName: json["nature_name"],
        suitableFor: json["suitable_for"],
        productID: json["product_id"],
        // // // dated: json["dated"] == null ? null : json["dated"],
        millName: json["mill_name"],
      );

  Map<String, dynamic> toMap() => {
        "yarn_full_qaulity": yarnFullQaulity,
        "brand_name": brandName,
        "quality_name": qualityName,
        "nature_name": natureName,
        "suitable_for": suitableFor,
        // "product_id": productID == null ? null : productID,
        // // // "dated": dated == null ? null : dated,
        "mill_name": millName,
      };
}
