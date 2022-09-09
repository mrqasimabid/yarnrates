import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  var screenSize;
  var height;
  var width;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/landingimages/ntu.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white24.withOpacity(0.6),
            BlendMode.modulate,
          ),
        ),
      ),
      height: width < 1100 ? height * 2 : height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                contactCard(
                  Icons.location_on,
                  'OUR LOCATION',
                  'National Textile University, Sheikhupura Road, '
                      'Faisalabad 37610, Pakistan',
                ),
                Row(
                  children: [
                    contactCard(
                      Icons.email,
                      'EMAIL US',
                      'info@ntu.edu.pk',
                    ),
                    contactCard(
                      Icons.call,
                      'CALL US',
                      '92 (041) 9230081-90',
                    ),
                    contactCard(
                      Icons.fax,
                      'FAX',
                      '92 (041) 9230098',
                    ),
                  ],
                ),
                contactCard(
                  Icons.timer,
                  'OFFICE HOURS',
                  'Monday - Friday 8:30 am to 4:40 pm and '
                      'Saturday & Sunday - Closed',
                ),
              ],
            ),
            Row(
              children: [],
            ),
          ],
        ),
      ),
    );
  }

  Card contactCard(icon, textMain, textDecription) {
    return Card(
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.orange[700],
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              textMain,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              textDecription,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
