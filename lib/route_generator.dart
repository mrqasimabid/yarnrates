import 'package:flutter/material.dart';
import 'package:yarnrates/main.dart';
import 'package:yarnrates/pages/addnew.dart';
import 'package:yarnrates/pages/analysispage.dart';
import 'package:yarnrates/pages/landing/landing_page.dart';
import 'package:yarnrates/pages/pricehistory.dart';
import 'package:yarnrates/pages/settings.dart';

import 'Model/globals.dart';
import 'pages/addmill.dart';
import 'pages/login_page.dart';
import 'pages/parameterhistory.dart';
import 'pages/product_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    String? name = settings.name;
    var args = (settings.arguments ?? {}) as Map;
    switch (name!.toLowerCase()) {
      case '/homepage':
        {
          return MaterialPageRoute(
              builder: (_) => const MyHomePage(title: 'Yarn Rates'));
        }
      case '/login':
        {
          return MaterialPageRoute(builder: (_) => LoginScreen());
        }
      case '/parameterhistory':
        {
          return MaterialPageRoute(
              builder: (_) => ParameterHistory(args['id']));
        }
      case '/history':
        {
          return MaterialPageRoute(builder: (_) => PriceHistory(args['id']));
        }
      case '/addnew':
        {
          return MaterialPageRoute(builder: (_) => const AddNew());
        }
      case '/analysis':
        {
          return MaterialPageRoute(builder: (_) => const AnalysisPage());
        }
      case '/settings':
        {
          return MaterialPageRoute(builder: (_) => const SettingsPage());
        }
      case '/logout':
        {
          logout();
          // return MaterialPageRoute(
          //     builder: (_) => const MyHomePage(title: 'Yarn Rates'));
          return MaterialPageRoute(builder: (_) => LandingPage());
        }
      case '/addmill':
        {
          return MaterialPageRoute(builder: (_) => AddMillPage());
        }
      case '/landing':
        {
          return MaterialPageRoute(builder: (_) => LandingPage());
        }

      default:
        return _errorPage(settings.name.toString());
    }
  }

  static Route<dynamic> _errorPage(String name) {
    return MaterialPageRoute(builder: (_) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(centerTitle: true, title: const Icon(Icons.error)),
          body: Center(
            child: Text(name.toUpperCase() + " page Coming Soon"),
          ),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
