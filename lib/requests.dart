import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yarnrates/Model/globals.dart';
import 'dart:io';

var queryURL = "https://mrqasimabid.pythonanywhere.com/query";
var insertURL = "https://mrqasimabid.pythonanywhere.com/insert";
var loginURL = "https://mrqasimabid.pythonanywhere.com/yarn_login";
var saveMillURL = "https://mrqasimabid.pythonanywhere.com/save_mill";

asyncFileUpload(File file, String q) async {
  //create multipart request for POST or PATCH method
  var request = http.MultipartRequest("POST", Uri.parse(saveMillURL));
  request.fields['query'] = q;
  request.fields['token'] = globalUser['token'];
  request.fields['uid'] = globalUser['uid'].toString();
  //create multipart using filepath, string or bytes
  var pic = await http.MultipartFile.fromPath("file", file.path);

  //add multipart to request
  request.files.add(pic);

  var response = await request.send();

  //Get the response from the server
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  print(responseString);
  return (responseString);
}

Future queryDB(q) async {
  final http.Response res =
      await http.post(Uri.parse(queryURL), body: <String, String>{
    'query': q,
  });
  var data = jsonDecode(res.body)['data'];
  return data;
}

Future insertDB(q) async {
  final http.Response res = await http.post(Uri.parse(insertURL),
      body: <String, String>{
        'query': q,
        'token': globalUser['token'],
        'uid': globalUser['uid'].toString()
      });
  var data = jsonDecode(res.body);
  print(data);
  return data;
}

Future loginAPI(uname, password) async {
  final http.Response res =
      await http.post(Uri.parse(loginURL), body: <String, String>{
    'uname': uname,
    'password': password,
  });
  var data = jsonDecode(res.body);
  return data;
}
