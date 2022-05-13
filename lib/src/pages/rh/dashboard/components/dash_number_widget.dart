import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';

class DashNumberWidget extends StatelessWidget {
  const DashNumberWidget(
      {Key? key,
      required this.number,
      required this.title,
      required this.icon,
      required this.color})
      : super(key: key);

  final String number;
  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 10.0,
        shadowColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 200,
          height: 100,
          color: color,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Icon(icon, size: 40.0, color: Colors.white))
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [ 
                    Expanded(
                      flex: 1,
                      child: AutoSizeText(title, maxLines: 2, style: bodyMedium!.copyWith(color: Colors.white))
                    ),
                    const SizedBox(height: p10),
                    Expanded(
                      flex: 2,
                      child: AutoSizeText(
                        number, 
                        maxLines: 1,
                        style: headline6!.copyWith(color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}