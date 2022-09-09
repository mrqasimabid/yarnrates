import 'package:flutter/material.dart';
import 'package:yarnrates/Model/globals.dart';

class DrawerC extends StatefulWidget {
  const DrawerC({Key? key}) : super(key: key);

  @override
  State<DrawerC> createState() => _DrawerCState();
}

var data = [
  {'title': 'Analysis', 'route': '/analysis', 'icon': Icons.analytics},
];

class _DrawerCState extends State<DrawerC> {
  Widget tile = Container();

  @override
  void initState() {
    getLoginTile(context).then((v) {
      tile = v;
    }).whenComplete(() async {
      tile = await getLoginTile(context);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getLoginTile(context).then((v) {
      tile = v;
    });
    return SafeArea(
      child: Drawer(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/icon.png',
              height: MediaQuery.of(context).size.height / 4,
            ),
          ),
          const Divider(),
          ...data
              .map((e) => ListTile(
                    leading: Icon(e['icon'] as IconData),
                    title: Text(e['title'].toString()),
                    onTap: () {
                      Navigator.of(context).pushNamed(e['route'].toString());
                    },
                  ))
              .toList(),
          tile,
          // getLoginTile(context)
        ]),
      ),
    );
  }
}

getLoginTile(context) async {
  IconData icon = Icons.login;
  String title = "Login";
  String route = "/login";
  bool admin = await isLoggedIn();
  if (admin) {
    icon = Icons.logout;
    title = "Logout";
    route = "/logout";
    data = [
      {'title': 'Analysis', 'route': '/analysis', 'icon': Icons.analytics},
      {'title': 'Add New', 'route': '/addnew', 'icon': Icons.new_label},
      // {'title': 'Add Mill', 'route': '/addmill', 'icon': Icons.factory},
    ];
  } else {
    data = [
      {'title': 'Analysis', 'route': '/analysis', 'icon': Icons.analytics},
    ];
  }
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      Navigator.of(context).pushReplacementNamed(route);
    },
  );
}
