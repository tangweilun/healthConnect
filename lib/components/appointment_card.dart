// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:health_connect/pages/appointment_page.dart';
import 'package:health_connect/theme/colors.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({super.key});

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: mediumBlueGrayColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/doctor_5.jpg'),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Dr Joe',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Dental',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ],
            ),
            // SizedBox(
            //   height: 14,
            // ),
            ScheduleCard(),
            // SizedBox(
            //   height: 14,
            // ),
            //action button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {},
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {},
                  child: Text(
                    'Complete',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 31, 142, 160),
          borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Monday, 11/28/2022',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            '2:00 PM',
            style: TextStyle(color: Colors.white),
          ))
        ],
      ),
    );
  }
}
