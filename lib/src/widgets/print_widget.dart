import 'package:flutter/material.dart';

class PrintWidget extends StatelessWidget {
  const PrintWidget({Key? key, required this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [IconButton(onPressed: onPressed, icon: const Icon(Icons.print))],
    );
  }
}
