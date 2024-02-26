import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:health_connect/pages/doctor/doctor_nav_bar.dart';
import 'package:health_connect/pages/doctor/doctor_hamburger_menu.dart';
import 'package:health_connect/theme/colors.dart';
import 'package:health_connect/models/doctor/appointment_card.dart';
import 'package:health_connect/services/doctor/appointment_services.dart';
import 'package:health_connect/services/doctor/doctor_info_getter.dart';
import 'package:health_connect/pages/doctor/medical_record_dialog.dart';
import 'package:health_connect/components/doctor/buttons.dart';

class DoctorAppointmentPage extends StatefulWidget {
  final void Function(int) navigateToPage;
  final String doctorEmail;

  const DoctorAppointmentPage(
      {Key? key, required this.navigateToPage, required this.doctorEmail})
      : super(key: key);

  @override
  State<DoctorAppointmentPage> createState() => _DoctorAppointmentPageState();
}

enum FilterStatus { pending, upcoming, completed, cancelled }

class _DoctorAppointmentPageState extends State<DoctorAppointmentPage> {
  FilterStatus status = FilterStatus.pending;
  Alignment _alignment = Alignment.centerLeft;
  late String doctor_id;

  @override
  void initState() {
    super.initState();
    DoctorAppointmentService().initializeFirebaseMessaging();
    DoctorAppointmentService().scheduleAppointmentNotifications();
    fetchDoctorInfo();
  }

  void fetchDoctorInfo() async {
    try {
      final userData = await DoctorInfo().getUserByEmail(widget.doctorEmail);

      if (userData != null) {
        setState(() {
          doctor_id = userData['doctor_id'];
        });
      }
    } catch (e) {
      print("Error fetching doctor's info: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkNavyBlue,
        title: Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10),
            _buildFilterBar(),
            SizedBox(height: 10),
            _buildStatusIndicator(),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('appointment')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  List<DocumentSnapshot> appointments = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      var _appointment = appointments[index];
                      return _buildScheduleCard(_appointment);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: HamburgerMenu(
        onMenuItemClicked: (String menuItem) {},
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          widget.navigateToPage(index);
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (FilterStatus filterStatus in FilterStatus.values)
            GestureDetector(
              onTap: () {
                setState(() {
                  status = filterStatus;
                  _updateAlignment();
                });
              },
              child: Center(
                child: Text(
                  filterStatus.toString().split('.').last,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return AnimatedAlign(
      alignment: _alignment,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        width: MediaQuery.of(context).size.width / FilterStatus.values.length,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.deepBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            status.toString().split('.').last.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _updateAlignment() {
    setState(() {
      _alignment = _calculateAlignmentForStatus(status);
    });
  }

  Widget _buildScheduleCard(DocumentSnapshot appointment) {
    String statusText = appointment['status'];
    DateTime appointmentDate = (appointment['date'] as Timestamp).toDate();
    String patientId = appointment['patientID'];

    if (_getStatusFromText(statusText) != status) {
      return SizedBox();
    }

    Color statusColor;
    IconData? statusIcon;

    switch (statusText) {
      case 'pending':
        statusColor = Colors.grey;
        break;
      case 'upcoming':
        statusColor = Color.fromARGB(174, 100, 180, 106);
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        break;
    }

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color.fromARGB(255, 0, 0, 139),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    // Remove the CircleAvatar
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Increase the font size of the patient's name
                        Text(
                          appointment['patientName'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18, // Adjust font size as needed
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Patient ID: $patientId',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 15),
                ScheduleCard(appointmentDate: appointmentDate),
                const SizedBox(height: 15),
                // Keep the buttons unchanged
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (statusText == 'pending') ...[
                      Expanded(
                        child: Button(
                          title: 'Reject',
                          appointmentId: appointment.id,
                          type: ButtonType.empty,
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('appointment')
                                .doc(appointment.id)
                                .update({'status': 'cancelled'});
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Button(
                          title: 'Accept',
                          appointmentId: appointment.id,
                          type: ButtonType.filled,
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('appointment')
                                .doc(appointment.id)
                                .update({'status': 'upcoming'});
                          },
                        ),
                      ),
                    ] else if (statusText == 'upcoming') ...[
                      Expanded(
                        child: Button(
                          title: 'Patient Details',
                          appointmentId: appointment.id,
                          type: ButtonType.empty,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientDetailsPage(
                                  patientId: patientId,
                                  patientName: appointment['patientName'],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Button(
                          title: 'Completed',
                          appointmentId: appointment.id,
                          type: ButtonType.filled,
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('appointment')
                                .doc(appointment.id)
                                .update({'status': 'completed'}).then((_) {
                              FirebaseFirestore.instance
                                  .collection('doctor')
                                  .doc(doctor_id)
                                  .update({
                                'number_of_previous_patient':
                                    FieldValue.increment(1)
                              });
                            }).catchError((error) {
                              print("Error completing appointment: $error");
                            });
                          },
                        ),
                      ),
                    ] else ...[
                      if (statusText != 'cancelled')
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientDetailsPage(
                                    patientId: patientId,
                                    patientName: appointment['patientName'],
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.deepBlue,
                            ),
                            child: const Text(
                              'View Visit Notes',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ]
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Alignment _calculateAlignmentForStatus(FilterStatus status) {
    final totalStatuses = FilterStatus.values.length;
    final indexOfCurrentStatus = FilterStatus.values.indexOf(status);
    final alignmentPosition =
        (indexOfCurrentStatus / (totalStatuses - 1)) * 2 - 1;
    return Alignment(alignmentPosition, 0.0);
  }

  FilterStatus _getStatusFromText(String statusText) {
    switch (statusText) {
      case 'pending':
        return FilterStatus.pending;
      case 'upcoming':
        return FilterStatus.upcoming;
      case 'completed':
        return FilterStatus.completed;
      case 'cancelled':
        return FilterStatus.cancelled;
      default:
        return FilterStatus.pending;
    }
  }
}
