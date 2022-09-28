// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MainSection extends StatefulWidget {
  const MainSection({Key? key}) : super(key: key);

  @override
  State<MainSection> createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  var screenSize;
  var height;
  var width;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;

    return Container(
      // height: height,
      // width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/landingimages/container_bg1.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white24.withOpacity(0.6),
            BlendMode.modulate,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 20, 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/YARNMARKETLOGO.png',
                  scale: 3,
                ),
              ],
            ),
            const Center(
              child: ListTile(
                title: Text(
                  'Live Yarn Rates and Analysis',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Column(
              children: [
                reusableTile('Get Live Yarn Rates'),
                // const SizedBox(height: 10),
                reusableTile('Get Live Yarn Analysis'),
                // const SizedBox(height: 10),
                reusableTile('Advance Search Filters'),
                // const SizedBox(height: 10),
                reusableTile('Timely Updates'),
                // const SizedBox(height: 10),
                reusableTile('Product Recommendations'),
                // const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget reusableTile(String points) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: ListTile(
        leading: const Icon(
          Icons.verified,
          // size: width % 50,
          size: 30,
          color: Colors.black,
        ),
        title: Text(
          points,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Padding reusableRow(String points) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        children: [
          const Icon(
            Icons.verified,
            size: 30,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            points,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
