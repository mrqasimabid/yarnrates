import 'package:flutter/material.dart';

class DeliverSection extends StatefulWidget {
  DeliverSection({Key? key}) : super(key: key);

  @override
  State<DeliverSection> createState() => _DeliverSectionState();
}

class _DeliverSectionState extends State<DeliverSection> {
  var screenSize;
  var height;
  var width;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;
    return Container(
      height: width < 1100 ? height * 2 : height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/landingimages/marblebg.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white24.withOpacity(0.6),
            BlendMode.modulate,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ListTile(
            title: Center(
              child: Text(
                'WHAT WE DELIVER',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

          // Text(
          //   'WHAT WE DELIVER',
          //   style: TextStyle(
          //     fontSize: width / 25,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          width < 1100
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: listRowCol(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: listRowCol(),
                ),
        ],
      ),
    );
  }

  List<Widget> listRowCol() {
    return [
      qualityColumn('100 %', 'LOWEST YARN RATES'),
      qualityColumn('99 %', 'QUALITY ASSURANCE'),
      qualityColumn('100 %', 'YARN RATE ANALYSIS'),
      qualityColumn('99 %', 'TIMELY UPDATES'),
    ];
  }

  Column qualityColumn(quality, description) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              width: 5,
              color: Colors.orange,
            ),
          ),
          child: Text(
            quality,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          description,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
