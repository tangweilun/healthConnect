import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_connect/models/appointment_model.dart';
import 'package:health_connect/services/auth_services.dart';
import 'package:health_connect/theme/colors.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { upcoming, complete, cancel }

class _AppointmentPageState extends State<AppointmentPage> {
  final AuthService _authService =
      AuthService(); // Create an instance of AuthService
  String? patientID; // Variable to hold the patient ID
  FilterStatus status = FilterStatus.upcoming;
  Alignment _alignment = Alignment.centerLeft;

  @override
  void initState() {
    super.initState();
    _getPatientID(); // Call the method to retrieve the patient ID when the screen initializes
  }

  Future<void> _getPatientID() async {
    String? id =
        await _authService.getPatientID(); // Call the method from AuthService
    setState(() {
      patientID = id; // Update the state variable with the retrieved patient ID
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<List<Appointment>> readAppointment() => FirebaseFirestore.instance
        .collection('appointment')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              final id = doc.id; // Accessing the document ID
              return Appointment.fromJson(data, id);
            }).toList());

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // List<dynamic> filteredSchedules = schedules.where((var schedule) {
    //   switch (schedule['status']) {
    //     case 'upcoming':
    //       schedule['status'] = FilterStatus.upcoming;
    //       break;
    //     case 'complete':
    //       schedule['status'] = FilterStatus.complete;
    //       break;
    //     case 'cancel':
    //       schedule['status'] = FilterStatus.cancel;
    //       break;
    //   }
    //   return schedule['status'] == status;
    // }).toList();
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
                  final List<dynamic> appointments = snapshot.data!;

                  // Filter appointments collection by status
                  List<dynamic> filteredAppointments =
                      appointments.where((appointment) {
                    // Access the 'status' property of each appointment
                    String appointmentStatus = appointment.status;

                    // Convert status string to enum (assuming FilterStatus is an enum)
                    FilterStatus filterStatus;
                    switch (appointmentStatus) {
                      case 'upcoming':
                        filterStatus = FilterStatus.upcoming;
                        break;
                      case 'complete':
                        filterStatus = FilterStatus.complete;
                        break;
                      case 'cancel':
                        filterStatus = FilterStatus.cancel;
                        break;
                      default:
                        filterStatus = FilterStatus.upcoming;
                    }
                    // Check if the appointment is for the specified patient
                    bool patientMatches = appointment.patientID == patientID;

                    // Check if the appointment status matches the desired status
                    bool statusMatches = filterStatus == status;

                    // // Return true if appointment status matches the desired status
                    // return filterStatus == status;
                    // Return true if both status and patient match
                    return statusMatches && patientMatches;
                  }).toList();

                  String statusMessage;
                  switch (status) {
                    case FilterStatus.upcoming:
                      statusMessage = 'upcoming';
                      break;
                    case FilterStatus.complete:
                      statusMessage = 'complete';
                      break;
                    case FilterStatus.cancel:
                      statusMessage = 'cancelled';
                      break;
                    default:
                      statusMessage = 'upcoming';
                  }
                  return Expanded(
                      child: filteredAppointments.isEmpty
                          ? Center(
                              child: Text(
                                'No $statusMessage appointments available. Please make an appointment.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : ListView.builder(
                              // itemCount: filteredSchedules.length,
                              itemCount: filteredAppointments.length,
                              itemBuilder: (((context, index) {
                                // var schedule = filteredSchedules[index];
                                var schedule = filteredAppointments[index];
                                // bool isLastElement =
                                //     filteredSchedules.length + 1 == index;
                                bool isLastElement =
                                    filteredAppointments.length + 1 == index;
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              // backgroundImage:Image.network(
                                              //   schedule.image,
                                              // ),
                                              backgroundImage: NetworkImage(
                                                schedule.image,
                                              ),
                                              radius:
                                                  25, // Adjust the radius as needed
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.2,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  schedule.doctorName,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  schedule.category,
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                const Icon(
                                                  Icons.calendar_today,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(schedule.date),
                                                  // 'testing date',
                                                  style: const TextStyle(
                                                    color: darkNavyBlueColor,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                const Icon(
                                                  Icons.access_alarm,
                                                  color: darkNavyBlueColor,
                                                  size: 17,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                    child: Text(
                                                  // '2:00 PM',
                                                  DateFormat('hh:mm a')
                                                      .format(schedule.date),
                                                  style: const TextStyle(
                                                      color: darkNavyBlueColor),
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
                                                style: TextStyle(
                                                    color: darkNavyBlueColor),
                                              ),
                                            )),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                                child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor:
                                                    mediumBlueGrayColor,
                                              ),
                                              onPressed: () {},
                                              child: const Text(
                                                'Reschedule',
                                                style: TextStyle(
                                                    color: Colors.white),
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
