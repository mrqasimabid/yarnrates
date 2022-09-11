process(List<dynamic> data) {
  var f = {};
  for (var element in data) {
    f[element['name']] = element['data'];
  }
  return f;
}

processSuitable(List<dynamic> data) {
  var f = [];
  for (var element in data) {
    f.add(element['name'].toString());
  }
  return f;
}
