import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleCard extends StatelessWidget {
  final DateTime appointmentDate;

  const ScheduleCard({Key? key, required this.appointmentDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            Icons.calendar_today,
            color: Colors.black,
            size: 15,
          ),
          SizedBox(width: 5),
          Text(
            DateFormat('EEEE, M/d/yyyy').format(appointmentDate),
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(width: 20),
          Icon(
            Icons.access_alarm,
            color: Colors.black,
            size: 17,
          ),
          SizedBox(width: 5),
          Flexible(
            child: Text(
              DateFormat('h:mm a').format(appointmentDate),
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
