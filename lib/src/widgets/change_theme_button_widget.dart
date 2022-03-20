import 'package:flutter/material.dart';
import 'package:fokad_admin/src/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isLightMode,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
        Routemaster.of(context).pop();
      },
    );
  }
}
