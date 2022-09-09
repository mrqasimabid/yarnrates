import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  var screenSize;
  var height;
  var width;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;
    return Container(
      // height: width < 1200 ? height * 2 : height,
      // width: width,
      child: Padding(
        // padding: EdgeInsets.symmetric(
        // horizontal: 50,
        // vertical: height / 7,
        // ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: height / 9),

        child: Column(
          children: [
            // Text(
            //   'ABOUT US',
            //   style: TextStyle(
            //     fontSize: width / 25,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            ListTile(
              title: Center(
                child: Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            Divider(
              height: 10,
              thickness: 2,
              indent: width / 2.5,
              endIndent: width / 2.5,
              color: Colors.grey[900],
            ),
            SizedBox(
              height: height / 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: width < 1100
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: list(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: list(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> list() {
    return [
      aboutColumn(
        Icons.account_tree_rounded,
        'WHO ARE WE?',
        'Yarn Rates is a product of National\nTextile'
            'University, Faisalabad where we\nprovide'
            'latest yarn rates and analysis.\nDownload '
            'our app to know more \nabout Yarn Rates.',
      ),
      aboutColumn(
        Icons.verified_user_outlined,
        'WHAT WE DO?',
        'We get you the lowest price for the yarns\n'
            'you need. We know the prevailing yarn rates\n'
            'in all major yarn spinning nations. We also\n'
            'provide advance search filters and analysis\n'
            'for Yarn Rates.',
      ),
      aboutColumn(
        Icons.emoji_emotions,
        'WHY CHOOSE US?',
        'We provide advance search filters,\n'
            'updates always on time and we also\n'
            'provide our users the best product\n'
            'recommendations to meet their needs\n'
            'and requirements.',
      ),
      aboutColumn(
        Icons.workspaces_rounded,
        'OUR REACH',
        'The yarn mills in the different\n'
            'cities of Pakistan is our Reach. We\n'
            'will make sure our services always\n'
            'reach you on time and provides you\n'
            'with all the updates of yarn.',
      ),
    ];
  }

  Column aboutColumn(icon, mainText, description) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            border: Border.all(
              width: 3,
              color: Colors.grey,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.black87,
            size: 60,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          mainText,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
