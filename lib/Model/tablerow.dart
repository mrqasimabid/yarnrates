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
    // required this.qualityName,
    required this.natureName,
    // required this.suitableFor,
    required this.productID,
    // required this.dated,
    required this.millName,
  });

  String yarnFullQaulity;
  String brandName;
  String? qualityName;
  String natureName;
  String? suitableFor;
  int productID;
  // String dated;
  String millName;

  factory YarnRow.fromMap(Map<String, dynamic> json) => YarnRow(
        yarnFullQaulity: json["yarn_full_qaulity"],
        brandName: json["brand_name"],
        natureName: json["nature_name"],
        productID: json["product_id"],
        millName: json["mill_name"],
        // dated: json["dated"] == null ? null : json["dated"],
        // suitableFor: json["suitable_for"],
        // qualityName: json["quality_name"],
      );

  Map<String, dynamic> toMap() => {
        "yarn_full_qaulity": yarnFullQaulity,
        "brand_name": brandName,
        "nature_name": natureName,
        "mill_name": millName,
        // "suitable_for": suitableFor,
        // "quality_name": qualityName,
        // "product_id": productID == null ? null : productID,
        // "dated": dated == null ? null : dated,
      };
}
