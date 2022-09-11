// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// Create a Form widget.
class AddMillForm extends StatefulWidget {
  const AddMillForm({Key? key}) : super(key: key);

  @override
  AddMillFormState createState() {
    return AddMillFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class AddMillFormState extends State<AddMillForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.factory,
            size: size.height / 4,
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Enter your full name',
              labelText: 'Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.phone),
              hintText: 'Enter a phone number',
              labelText: 'Phone',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter valid phone number';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              hintText: 'Enter your date of birth',
              labelText: 'Dob',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter valid date';
              }
              return null;
            },
          ),
          Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(
                        const SnackBar(content:  Text('Data is in processing.')));
                  }
                },
              )),
        ],
      ),
    );
  }
}
