import 'package:flutter/material.dart';

class LogView extends StatelessWidget {
  final String log;

  const LogView(this.log, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(color: Colors.black),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            log,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
