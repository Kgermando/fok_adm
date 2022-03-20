import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class BtnWidget extends StatelessWidget {
  const BtnWidget({Key? key, 
    required this.title, 
    required this.press, required this.isLoading}) : super(key: key);
  final String title;
  final VoidCallback press;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: const EdgeInsets.only(bottom: 5),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 10),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: press,
            child: isLoading
              ? loading()
              : Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.height / 50,
                ),
              )
          )
        ),
      ]
    );
    
    
    
    
    
    
    
    
    
    Material(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      shadowColor: themeColor,
      child: ElevatedButton(
        child: Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 50),
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
