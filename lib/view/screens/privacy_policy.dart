import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 300,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'The Health Data Server application reads the health data you provide consent for access. ' +
                    'It reads this health data from the built in sensors provided by the devices. ' +
                    'This data is never stored locally or externally.',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
