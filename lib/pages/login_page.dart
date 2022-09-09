import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yarnrates/Model/globals.dart';
import '../main.dart';
import '../requests.dart';

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    var res;
    try {
      res = await loginAPI(data.name, data.password);
      if (res['status'] == "true") {
        globalUser = jsonDecode(res['data'])[0];
        print(globalUser);
        var prefs = await SharedPreferences.getInstance();
        await prefs.setBool('login', true);
        await prefs.setString('user', jsonEncode(globalUser));
        return null;
      } else {
        return res['message'];
      }
    } catch (ex) {
      return "Server Error";
    }
    // var user = "SELECT * from user where uname='${data.name}'";
    // var userRes = await queryDB(user);
    // var value = jsonDecode(userRes);
    // if (value.length > 0) {
    //   // user found
    //   if (value[0]['password'] == data.password) {
    //     // user matched
    //     var prefs = await SharedPreferences.getInstance();
    //     await prefs.setBool('login', true);
    //     return null;
    //   } else {
    //     return "Incorrect Password";
    //   }
    // } else {
    //   return "No user ${data.name} Found";
    // }
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return "null";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      children: [
        Positioned(
            bottom: MediaQuery.of(context).size.height / 4,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/homepage');
              },
              child: const Text(
                "Continue without Login",
                style: TextStyle(color: Colors.white),
              ),
            )),
      ],
      footer: "National Textile University",
      hideForgotPasswordButton: true,
      title: 'Yarn Rates',
      onLogin: _authUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'Yarn Rates'),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
