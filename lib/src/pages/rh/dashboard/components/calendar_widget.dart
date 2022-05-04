import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({ Key? key }) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: Card(
        elevation: 10,
        child: SfCalendar(
          view: CalendarView.month,
        ),
      ),
    );
  }
}