import 'package:flutter/material.dart';
import 'package:health_connect/theme/colors.dart';
import 'package:health_connect/pages/doctor/doctor_nav_bar.dart';
import 'package:health_connect/pages/doctor/doctor_edit_profile.dart';
import 'package:health_connect/pages/doctor/doctor_hamburger_menu.dart';
import 'package:health_connect/services/doctor/doctor_info_getter.dart';
import 'package:health_connect/models/doctor/doctor_info.dart'; // Import Doctor model

class ViewProfileScreen extends StatefulWidget {
  final void Function(int) navigateToPage;
  final String userEmail;

  const ViewProfileScreen({
    Key? key,
    required this.navigateToPage,
    required this.userEmail,
  }) : super(key: key);

  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  Doctor? doctor; // Store Doctor object

  @override
  void initState() {
    super.initState();
    fetchDoctorInfo();
  }

  void fetchDoctorInfo() async {
    try {
      final userData = await DoctorInfo().getUserByEmail(widget.userEmail);

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
          'Personal Profile',
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
      body: doctor != null
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: doctor!.photoUrl != null
                              ? NetworkImage(doctor!.photoUrl!)
                              : AssetImage('assets/profile_photo.jpg')
                                  as ImageProvider,
                        ),
                        SizedBox(width: 20.0),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    _buildProfileInfo(title: 'Full Name', value: doctor!.name),
                    SizedBox(height: 10),
                    _buildProfileInfo(
                        title: 'Specialty', value: doctor!.specialty),
                    SizedBox(height: 10),
                    _buildProfileInfo(
                        title: 'Number of Previous Patients',
                        value: doctor!.numberOfPreviousPatients.toString()),
                    SizedBox(height: 10),
                    _buildProfileInfo(
                        title: 'Age', value: doctor!.age.toString()),
                    SizedBox(height: 10),
                    _buildProfileInfo(title: 'Email', value: doctor!.email),
                    SizedBox(height: 10),
                    _buildProfileInfo(title: 'Gender', value: doctor!.gender),
                    SizedBox(height: 10),
                    _buildProfileInfo(
                        title: 'Phone Number', value: doctor!.phoneNumber),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                              navigateToPage: widget.navigateToPage,
                              userEmail: doctor!.email,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepBlue,
                      ),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child:
                  CircularProgressIndicator()), // Show loading indicator while fetching data
      drawer: HamburgerMenu(
        onMenuItemClicked: (String menuItem) {},
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          widget.navigateToPage(index);
        },
      ),
    );
  }

  Widget _buildProfileInfo(
      {required String title, required String value, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black87),
        ),
      ],
    );
  }
}
