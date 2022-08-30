// To parse this JSON data, do
//
//     final Quality = qualityFromMap(jsonString);

import 'dart:convert';

List<Quality> qualityFromMap(String str, String key) =>
    List<Quality>.from(json.decode(str).map((x) => Quality.fromMap(x, key)));

String qualityToMap(List<Quality> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Quality {
  Quality({
    this.id = '',
    required this.name,
  });

  String id;
  String name;

  factory Quality.fromMap(Map<String, dynamic> json, String key) => Quality(
        // id: json["id"] == null ? null : json["id"],
        name: json[key],
      );

  Map<String, dynamic> toMap() => {
        // "id": id == null ? null : id,
        "name": name,
      };
}
