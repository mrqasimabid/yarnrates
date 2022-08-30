import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yarnrates/requests.dart';

import '../Model/globals.dart';

class AddMillPage extends StatefulWidget {
  AddMillPage({
    Key? key,
  }) : super(key: key);
  @override
  State<AddMillPage> createState() => _AddMillPageState();
}

class _AddMillPageState extends State<AddMillPage> {
  List<dynamic> mills = [];
  List<dynamic> table = [];
  TextEditingController nameController = TextEditingController();
  bool loader = false;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    reloadMills();

    super.initState();
  }

  File? imageFile;
  Image? image;
  var selectedMill = null;
  int id = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Mills'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.miscellaneous_services), text: "Add Mill"),
              Tab(icon: Icon(Icons.list), text: "View")
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.factory,
                    size: size.height / 4,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter mill name',
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    horizontalTitleGap: size.width / 5,
                    title: Text("Pick Image"),
                    trailing: MaterialButton(
                      child: Icon(Icons.browse_gallery),
                      onPressed: () async {
                        await _getFromGallery();
                      },
                    ),
                    leading: MaterialButton(
                      child: Icon(Icons.camera),
                      onPressed: () async {
                        await _getFromCamera();
                      },
                    ),
                  ),
                  imageFile != null
                      ? Image.file(
                          imageFile!,
                          width: size.width / 3,
                          height: size.height / 3,
                          // size: size.width / 2,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                  Container(
                    padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (nameController.text.isNotEmpty) {
                        String name = nameController.text;
                        var filename = null;
                        if (imageFile != null) {
                          filename = imageFile!.path
                              .split('/')
                              .where((element) =>
                                  element.contains('.jpg') ||
                                  element.contains('.png'))
                              .first;
                          print(filename);
                        }
                        if (selectedMill == null) {
                          String query =
                              "INSERT INTO mills(mill_name,mill_image) Values('$name','$filename')";
                          // print(globalUser);

                          if (imageFile == null) {
                            await insertDB(query);
                          } else {
                            await asyncFileUpload(imageFile!, query);
                          }
                        } else {
                          if (filename == null) {
                            filename = selectedMill['mill_image'];
                          }
                          String query =
                              "UPDATE mills set mill_name='$name',mill_image='$filename' where mill_id=${globalUser['uid']}";
                          print(query);
                          if (imageFile == null) {
                            await insertDB(query);
                          } else {
                            await asyncFileUpload(imageFile!, query);
                          }
                        }
                        reloadMills();
                      }
                    },
                    child: Text("Submit"),
                  )
                ],
              ),
            ),
            loader
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              trailing: InkWell(
                                child: const Icon(Icons.cancel),
                                onTap: () {
                                  table = mills;

                                  searchController.text = '';

                                  setState(() {});
                                },
                              ),
                              title: TextField(
                                onChanged: (value) {
                                  List<dynamic> t = mills;
                                  var values = value.split(' ');
                                  if (value.isEmpty) {
                                  } else {
                                    table = t.where((obj) {
                                      var ele = obj.toString();
                                      List<bool> flags = [];
                                      for (var element in values) {
                                        bool flag = ele
                                            .toLowerCase()
                                            .contains(element.toLowerCase());
                                        flags.add(flag);
                                      }
                                      return !flags.contains(false);
                                    }).toList();
                                    print(table);
                                  }
                                  setState(() {});
                                },
                                controller: searchController,
                                decoration: const InputDecoration(
                                  label: Text("Search"),
                                ),
                              ),
                            ),
                          ),
                          Column(
                              children: table
                                  .map((e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: e['mill_image'] == null ||
                                              e['mill_image'] == 'null'
                                          ? ListTile(
                                              trailing: MaterialButton(
                                                  onPressed: () {
                                                    selectedMill = e;
                                                    nameController.text =
                                                        e['mill_name'];

                                                    setState(() {});
                                                  },
                                                  child: Icon(Icons.edit)),
                                              tileColor: mainColor,
                                              title: Text(e['mill_name']),
                                            )
                                          : ExpansionTile(
                                              leading: MaterialButton(
                                                  onPressed: () {
                                                    selectedMill = e;
                                                    nameController.text =
                                                        e['mill_name'];

                                                    setState(() {});
                                                  },
                                                  child: Icon(Icons.edit)),
                                              collapsedBackgroundColor:
                                                  mainColor,
                                              title: Text(e['mill_name']),
                                              children: [
                                                  Card(
                                                      color: mainColor,
                                                      child: Column(
                                                        children: [
                                                          Image.network(
                                                            globalImage +
                                                                e['mill_image'],
                                                            height: 200,
                                                          ),
                                                        ],
                                                      ))
                                                ])))
                                  .toList())
                        ]),
                  ),
          ],
        ),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  reloadMills() {
    nameController.text = '';
    imageFile = null;
    setState(() {
      loader = true;
    });
    queryDB("Select * from mills").then((value) {
      mills = jsonDecode(value) as List<dynamic>;
      table = mills;
    }).whenComplete(() {
      loader = false;
      setState(() {});
    });
  }
}
