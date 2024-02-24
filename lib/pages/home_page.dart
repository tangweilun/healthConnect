import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:health_connect/components/appointment_card.dart';

import 'package:health_connect/models/doctor_model.dart';
import 'package:health_connect/providers/doctor_provider.dart';
import 'package:health_connect/services/auth_services.dart';
import 'package:health_connect/theme/colors.dart';

class PatientNameWidget extends StatefulWidget {
  const PatientNameWidget({super.key});

  @override
  State<PatientNameWidget> createState() => _PatientNameWidgetState();
}

class _PatientNameWidgetState extends State<PatientNameWidget> {
  String patientName = '';
  @override
  void initState() {
    super
        .initState(); // Call the method to retrieve the patient ID when the screen initializes
    _getPatientName();
  }

  final AuthService _authService =
      AuthService(); // Create an instance of AuthService
  Future<void> _getPatientName() async {
    String? name =
        await _authService.getPatientName(); // Call the method from AuthService
    setState(() {
      patientName =
          name ?? ''; // Update the state variable with the retrieved patient ID
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome $patientName',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  //function that will filter doctor list
  //for searching
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //read doctor from the firestore
    Stream<List<Doctor>> readDoctor() => FirebaseFirestore.instance
        .collection('doctor')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Doctor.fromJson(doc.data())).toList());

    //build doctor
    Widget buildDoctor(Doctor doctor) => GestureDetector(
          onTap: () {
            ref.read(selectedDoctorProvider.notifier).updateDoctorModel(doctor);

            GoRouter.of(context).go('/doctordetail');
          },
          child: ListTile(
            leading: CircleAvatar(
              // Wrap the Image.network with ClipOval to make it round
              child: ClipOval(
                child: Image.network(
                  doctor.photo,
                  // You can provide additional properties like width, height, etc. here
                  width: 90,
                  height: 90,
                  fit: BoxFit
                      .cover, // Adjust the image to cover the entire circle avatar
                ),
              ),
            ),
            title: Text(
              doctor.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${doctor.speciality} in ${doctor.department} Department",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 40,
              color: mediumBlueGrayColor,
            ),
          ),
        );
    //get device information
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.04,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: signUserOut,
              icon: const Icon(
                Icons.logout,
                color: mediumBlueGrayColor,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PatientNameWidget(),

                SizedBox(
                  height: screenHeight * 0.02,
                ),
                const Text(
                  'Appointment Today',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                //display appointment card here
                const AppointmentCard(),
                const SizedBox(
                  height: 20,
                ),

                Center(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      ref.read(searchNameProvider.notifier).state = value;
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.blue, // Change border color here
                          width: 2.0, // Change border thickness here
                        ),
                      ),
                      hintText: 'Find Doctor',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(
                            left: 8.0, right: 8.0), // Adjust padding as needed
                        child: Icon(Icons.search, color: mediumBlueGrayColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 10.0), // Adjust padding as needed
                    ),
                  ),
                ),

                SizedBox(
                  height: screenHeight * 0.02,
                ),
                const Text(
                  'Departments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                StreamBuilder(
                  stream: readDoctor(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong! ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      var doctors = snapshot.data!;
                      List<String> departmentList = doctors
                          .map((doctor) => doctor.department)
                          .toSet()
                          .toList();
                      //display department
                      return SizedBox(
                        height: screenHeight * 0.06,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List<Widget>.generate(departmentList.length,
                              (index) {
                            return GestureDetector(
                              onTap: () {
                                ref.read(searchNameProvider.notifier).state =
                                    departmentList[index];
                                ref
                                    .read(isfilteredByDepartment.notifier)
                                    .state = true;
                              },
                              child: Card(
                                margin: const EdgeInsets.only(right: 16),
                                color: mediumBlueGrayColor,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Text(
                                      departmentList[index],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            );
                          }),
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),

                const SizedBox(
                  height: 14,
                ),
                /////////////////////////////////////////////////////////////////////////////////////////
                const Text(
                  'Our Doctors',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //list of top doctor
                const SizedBox(
                  height: 14,
                ),
                StreamBuilder(
                  stream: readDoctor(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong! ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      var doctors = snapshot.data!;
                      List<String> departmentList = doctors
                          .map((doctor) => doctor.department)
                          .toSet()
                          .toList();
                      String searchName = ref.watch(searchNameProvider);

                      if (searchName.isNotEmpty &&
                          ref.watch(isfilteredByDepartment)) {
                        doctors = doctors
                            .where((doctor) => doctor.department
                                .toLowerCase()
                                .contains(searchName.toLowerCase()))
                            .toList();
                      } else if (searchName.isNotEmpty) {
                        doctors = doctors
                            .where((doctor) => doctor.name
                                .toLowerCase()
                                .contains(searchName.toLowerCase()))
                            .toList();
                      }

                      if (doctors.isEmpty) {
                        return Container(
                          padding: EdgeInsets.all(
                              16.0), // Add padding for better visual appeal
                          decoration: BoxDecoration(
                            color: Colors.grey[
                                200], // Change the background color to a light grey
                            borderRadius: BorderRadius.circular(
                                8.0), // Add rounded corners to the container
                          ),
                          child: Text(
                            "Opps, no doctor found. Try another name",
                            style: TextStyle(
                                fontSize: 24,
                                color:
                                    Colors.grey[600]), // Adjust the text color
                          ),
                        );
                      }
                      // display doctor
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: doctors.length,
                        // itemCount: filteredDoctors.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: mediumBlueGrayColor, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: buildDoctor(doctors[index]),
                            // child: buildDoctor(filteredDoctors[index]),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
