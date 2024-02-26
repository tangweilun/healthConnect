import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health_connect/pages/doctor/doctor_nav_bar.dart';
import 'package:health_connect/theme/colors.dart';
import 'package:health_connect/pages/doctor/doctor_hamburger_menu.dart';
import 'package:health_connect/pages/doctor/doctor_view_profile.dart';
import 'package:health_connect/pages/doctor/add_medical_record_page.dart';
import 'package:health_connect/pages/doctor/patients_records_page.dart';
import 'package:health_connect/pages/doctor/doctor_user_manual.dart';
import 'package:health_connect/services/doctor/doctor_info_getter.dart';
import 'package:health_connect/models/doctor/doctor_info.dart';
import 'package:health_connect/pages/doctor/doctor_appointment_page.dart';

class DoctorHomePage extends StatefulWidget {
  final String doctorEmail;
  const DoctorHomePage({Key? key, required this.doctorEmail}) : super(key: key);

  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  int _currentIndex = 0;
  Doctor? doctor;

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    if (token != null) {
      print('My toke is' + token);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get the email of the currently logged-in user
        String? userEmail = user.email;
        print('userEmail:$userEmail');
        await FirebaseFirestore.instance
            .collection('Users')
            .where('Email', isEqualTo: userEmail)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({
              'fcmToken': token,
            });
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDoctorInfo();
    setupPushNotification();
  }

  void fetchDoctorInfo() async {
    try {
      final userData = await DoctorInfo().getUserByEmail(widget.doctorEmail);

      if (userData != null) {
        setState(() {
          doctor = Doctor(
              name: userData['name'],
              specialty: userData['speciality'],
              age: userData['age'],
              email: userData['email'],
              phoneNumber: userData['phone_number'],
              gender: userData['gender'],
              numberOfPreviousPatients: userData['number_of_previous_patient'],
              photoUrl: userData['photo'],
              doctorID: userData['doctor_id']);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 70,
                  backgroundImage: (doctor != null && doctor!.photoUrl != null)
                      ? NetworkImage(doctor!.photoUrl!)
                      : NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/healthconnect-ad0f1.appspot.com/o/icons_564369.svg?alt=media&token=ad91c72d-8e34-44f9-897c-96b693b42601'),
                ),
                SizedBox(height: 20),
                Text(
                  doctor?.name.isNotEmpty ?? false
                      ? doctor!.name
                      : 'HealthConnect doctor',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Specialty: ${doctor?.specialty ?? ""}',
                      style: TextStyle(),
                    ),
                    SizedBox(height: 5),
                    Text('Age: ${doctor?.age ?? ""}', style: TextStyle()),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to HealthConnect, your app to watch and monitor your operations in the hospital, where you can manage your appointments, patients\' medical records, and more.',
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
                SizedBox(height: 20),
                Text(
                  'Quick access',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildButton('View Medical Records', 0),
                      _buildButton('Add Medical Record', 1),
                      _buildButton('HealthConnect User Manual', 2),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Upcoming Appointments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                _buildUpcomingAppointments(),
              ],
            ),
          ),
        ),
      ),
      drawer: HamburgerMenu(
        onMenuItemClicked: (String menuItem) {},
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          navigateToPage(index);
        },
      ),
    );
  }

  Widget _buildButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        if (text == 'View Medical Records') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientsRecordsPage(),
            ),
          );
        } else if (text == 'Add Medical Record') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMedicalRecordPage(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HealthConnectUserManualPage(),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color:
              _currentIndex == index ? AppColors.deepBlue : AppColors.deepBlue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.deepBlue, width: 2),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _currentIndex == index ? Colors.white : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointments() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointment')
          .where('doctorID', isEqualTo: doctor?.doctorID ?? "")
          .where('status', isEqualTo: 'upcoming')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<DocumentSnapshot> appointments = snapshot.data!.docs;

        if (appointments.isEmpty) {
          return Text('No upcoming appointments');
        }

        return Column(
          children: appointments.map((appointment) {
            return _buildAppointmentCard(appointment);
          }).toList(),
        );
      },
    );
  }

  Widget _buildAppointmentCard(DocumentSnapshot appointment) {
    DateTime appointmentDate = (appointment['date'] as Timestamp).toDate();
    String patientId = appointment['patientID'];

    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Patient ID: $patientId',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            'Date: ${DateFormat('EEEE, MMMM d, y').format(appointmentDate)}',
          ),
          SizedBox(height: 5),
          Text(
            'Time: ${DateFormat('h:mm a').format(appointmentDate)}',
          ),
        ],
      ),
    );
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DoctorHomePage(doctorEmail: widget.doctorEmail)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorAppointmentPage(
              navigateToPage: navigateToPage,
              doctorEmail: doctor?.email ?? "",
            ),
          ),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewProfileScreen(
              navigateToPage: navigateToPage,
              userEmail: widget.doctorEmail, // Pass the doctor's email
            ),
          ),
        );
        break;
    }
  }
}
