import 'package:yarnrates/Model/quality.dart';
import 'package:yarnrates/Model/tablerow.dart';
import 'package:yarnrates/requests.dart';

Future<dynamic> yarnRows() async {
  var data = {};
  data['table'] = YarnRowFromMap(
      await queryDB("select * from product order by product_id desc;"));

  data['quality'] =
      qualityFromMap(await queryDB("select * from quality;"), 'quality_name');
  data['mills'] =
      qualityFromMap(await queryDB("select * from mills;"), 'mill_name');

  return data;
}
