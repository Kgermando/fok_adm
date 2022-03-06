import 'package:flutter/material.dart';
import 'package:fokad_admin/src/provider/theme_provider.dart';

Widget loading() => Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    CircularProgressIndicator(color: ThemeProvider().isDarkMode ? Colors.white : Colors.white),
    const SizedBox(width: 20.0,),
    Text('Patientez svp...', style: TextStyle(color: ThemeProvider().isDarkMode ? Colors.white : Colors.white))
  ],
);


Widget loadingMini() => CircularProgressIndicator(color: ThemeProvider().isDarkMode ? Colors.white : Colors.purple, strokeWidth: 2.0,);
