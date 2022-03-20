import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';

class BtnWidget extends StatelessWidget {
  const BtnWidget({Key? key, required this.title, required this.press}) : super(key: key);
  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      shadowColor: themeColor,
      child: ElevatedButton(
        child: Container(
          height: 1 * (MediaQuery.of(context).size.height / 50),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          // color: themeColor,
          margin: const EdgeInsets.all(p20),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(p30)
          // ),
          child: Text(title, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20.0), 
          ),
        ), 
        onPressed: press,
      ),
    );
  }
}
