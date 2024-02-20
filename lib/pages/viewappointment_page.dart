import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_connect/models/appointment_model.dart';
import 'package:health_connect/theme/colors.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { upcoming, complete, cancel }

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.upcoming;
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [
    {
      "doctor_name": "Richard Tan",
      "doctor_profile": "assets/images/doctor_1.jpg",
      "category": "Dental",
      "status": FilterStatus.upcoming,
    },
    {
      "doctor_name": "Tan",
      "doctor_profile": "assets/images/doctor_2.jpg",
      "category": "Cardiologyl",
      "status": FilterStatus.upcoming,
    },
    {
      "doctor_name": "Ric",
      "doctor_profile": "assets/images/doctor_3.jpg",
      "category": "Respiration",
      "status": FilterStatus.complete,
    },
    {
      "doctor_name": "Rha",
      "doctor_profile": "assets/images/doctor_4.jpg",
      "category": "General",
      "status": FilterStatus.cancel,
    },
    {
      "doctor_name": "Rian",
      "doctor_profile": "assets/images/doctor_5.jpg",
      "category": "General",
      "status": FilterStatus.cancel,
    },
  ];

  @override
  Widget build(BuildContext context) {
    Stream<List<Appointment>> readAppointment() => FirebaseFirestore.instance
        .collection('appointment')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Appointment.fromJson(doc.data()))
            .toList());

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    List<dynamic> filteredSchedules = schedules.where((var schedule) {
      switch (schedule['status']) {
        case 'upcoming':
          schedule['status'] = FilterStatus.upcoming;
          break;
        case 'complete':
          schedule['status'] = FilterStatus.complete;
          break;
        case 'cancel':
          schedule['status'] = FilterStatus.cancel;
          break;
      }
      return schedule['status'] == status;
    }).toList();
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Apointment Schedule',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: mediumBlueGrayColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (filterStatus == FilterStatus.upcoming) {
                                status = FilterStatus.upcoming;
                                _alignment = Alignment.centerLeft;
                              } else if (filterStatus ==
                                  FilterStatus.complete) {
                                status = FilterStatus.complete;
                                _alignment = Alignment.center;
                              } else if (filterStatus == FilterStatus.cancel) {
                                status = FilterStatus.cancel;
                                _alignment = Alignment.centerRight;
                              }
                            });
                          },
                          child: Center(child: Text(filterStatus.name)),
                        ))
                    ]),
              ),
              AnimatedAlign(
                alignment: _alignment,
                duration: const Duration(
                  microseconds: 200,
                ),
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: mediumBlueGrayColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      status.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          StreamBuilder<List<Appointment>>(
              stream: readAppointment(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong! ${snapshot.error}');
                } else if (snapshot.hasData) {
                  // get appointments collection from firestore
                  final appointments = snapshot.data!;
                  // filter appointments collection by status
                  List<dynamic> filteredSchedules = appointments
                      .where((appointment) => appointment.status == status)
                      .toList();

                  FirebaseFirestore.instance
                      .collection('appointment')
                      .doc()
                      .get();
                  return Expanded(
                      child: ListView.builder(
                    itemCount: filteredSchedules.length,
                    itemBuilder: (((context, index) {
                      var schedule = filteredSchedules[index];
                      bool isLastElement =
                          filteredSchedules.length + 1 == index;
                      return Card(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: !isLastElement
                            ? const EdgeInsets.only(bottom: 20)
                            : EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                      schedule['image'],
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.2,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        schedule['doctor_name'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        schedule['category'],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              // const ScheduleCard(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                child: const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Monday, 11/28/2024',
                                        style: TextStyle(
                                          color: darkNavyBlueColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Icon(
                                        Icons.access_alarm,
                                        color: darkNavyBlueColor,
                                        size: 17,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                          child: Text(
                                        '2:00 PM',
                                        style:
                                            TextStyle(color: darkNavyBlueColor),
                                      ))
                                    ]),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: OutlinedButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Cancel',
                                      style:
                                          TextStyle(color: darkNavyBlueColor),
                                    ),
                                  )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                      child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: mediumBlueGrayColor,
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'Reschedule',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    })),
                  ));
                }
                // show loading
                return const Center(child: CircularProgressIndicator());
              })
        ],
      ),
    ));
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: 15,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Monday, 11/28/2024',
              style: TextStyle(
                color: darkNavyBlueColor,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.access_alarm,
              color: darkNavyBlueColor,
              size: 17,
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
                child: Text(
              '2:00 PM',
              style: TextStyle(color: darkNavyBlueColor),
            ))
          ]),
    );
  }
}
