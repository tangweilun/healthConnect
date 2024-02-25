import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:health_connect/models/appointment_model.dart';
import 'package:health_connect/models/doctor_model.dart';
import 'package:health_connect/providers/doctor_provider.dart';
import 'package:health_connect/providers/reschedule_provider.dart';
import 'package:health_connect/services/auth_services.dart';
import 'package:health_connect/theme/colors.dart';
import 'package:intl/intl.dart';

class ResheduleButton extends ConsumerWidget {
  final String appointmentID;
  final Doctor doctor;
  ResheduleButton({
    Key? key,
    required this.appointmentID,
    required this.doctor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: mediumBlueGrayColor,
        ),
        onPressed: () {
          ref.read(selectedDoctorProvider.notifier).updateDoctorModel(doctor);
          ref
              .read(appointmentIDProvider.notifier)
              .update((state) => appointmentID);

          ref.read(rescheduleProvider.notifier).update((state) => true);
          GoRouter.of(context).go('/doctordetail/appointmentbooking');
        },
        child: const Text(
          'Reschedule',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { pending, upcoming, cancel, complete }

class _AppointmentPageState extends State<AppointmentPage> {
  final AuthService _authService =
      AuthService(); // Create an instance of AuthService
  String? patientID; // Variable to hold the patient ID
  FilterStatus status = FilterStatus.pending;
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
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Appointment.fromJson(doc.data()))
            .toList());

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Appointment Schedule',
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
                      for (FilterStatus filterStatus
                          in FilterStatus.values.getRange(0, 3))
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (filterStatus == FilterStatus.pending) {
                                status = FilterStatus.pending;
                                _alignment = Alignment.centerLeft;
                              } else if (filterStatus ==
                                  FilterStatus.upcoming) {
                                status = FilterStatus.upcoming;
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
                      case 'pending':
                        filterStatus = FilterStatus.pending;
                        break;
                      case 'cancel':
                        filterStatus = FilterStatus.cancel;
                        break;
                      default:
                        filterStatus = FilterStatus.complete;
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
                    case FilterStatus.pending:
                      statusMessage = 'pending';
                      break;
                    case FilterStatus.cancel:
                      statusMessage = 'cancelled';
                      break;
                    default:
                      statusMessage = 'pending';
                  }
                  return Expanded(
                      child: filteredAppointments.isEmpty
                          ? Center(
                              child: Text(
                                'No $statusMessage appointments available. Please make an appointment.',
                                style: const TextStyle(
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
                                              backgroundImage: NetworkImage(
                                                schedule.photo,
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
                                                  schedule.department,
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
                                            if (schedule.status != 'cancel')
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    final docAppointment =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'appointment')
                                                            .doc(schedule.id);

                                                    docAppointment.update({
                                                      'status': 'cancel',
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color:
                                                            darkNavyBlueColor),
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(width: 20),
                                            ResheduleButton(
                                              appointmentID: schedule.id,
                                              doctor: Doctor(
                                                  id: schedule.doctorID,
                                                  name: schedule.doctorName,
                                                  department:
                                                      schedule.department,
                                                  speciality:
                                                      schedule.speciality,
                                                  photo: schedule.photo,
                                                  description: ''),
                                            ),
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
