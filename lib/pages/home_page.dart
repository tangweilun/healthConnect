import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:health_connect/components/appointment_card.dart';
import 'package:health_connect/components/doctor_card.dart';
import 'package:health_connect/models/doctor_model.dart';
import 'package:health_connect/theme/colors.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "General",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": "Cardiology",
    },
    {
      "icon": FontAwesomeIcons.lungs,
      "category": "Resporations",
    },
    {
      "icon": FontAwesomeIcons.hand,
      "category": "Dermatology",
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "category": "Gynecology",
    },
    {
      "icon": FontAwesomeIcons.teeth,
      "category": "Dental",
    },
  ];

  @override
  Widget build(BuildContext context) {
    //read doctor from the firestore
    Stream<List<Doctor>> readDoctor() => FirebaseFirestore.instance
        .collection('doctor')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Doctor.fromJson(doc.data())).toList());

    //build doctor
    Widget buildDoctor(Doctor doctor) => GestureDetector(
          onTap: () {
            GoRouter.of(context).go('/doctordetail');
          },
          child: ListTile(
            leading: CircleAvatar(
              // Wrap the Image.network with ClipOval to make it round
              child: ClipOval(
                child: Image.network(
                  doctor.image,
                  // You can provide additional properties like width, height, etc. here
                  width: 50,
                  height: 50,
                  fit: BoxFit
                      .cover, // Adjust the image to cover the entire circle avatar
                ),
              ),
            ),
            title: Text(doctor.name),
            subtitle: Text(
              doctor.category,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              iconSize: 40,
              color: mediumBlueGrayColor,
              onPressed: () {
                //if route is given , then this icon button will navigate to
              },
            ),
          ),
        );
    //get device information
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Amanda',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage('assets/images/doctor_1.jpg'),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  height: screenHeight * 0.06,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(medCat.length, (index) {
                      return Card(
                        margin: const EdgeInsets.only(right: 16),
                        color: mediumBlueGrayColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(
                                medCat[index]['icon'],
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                medCat[index]['category'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Appointment Today',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                //display appointment card here
                AppointmentCard(),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  'Top Doctors',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //list of top doctor
                const SizedBox(
                  height: 14,
                ),
                // Column(
                //   children: List.generate(3, (index) {
                //     return const DoctorCard();
                //   }),
                // )
                // StreamBuilder(
                //   stream: readDoctor(),
                //   builder: (context, snapshot) {
                //     if (snapshot.hasError) {
                //       return Text('Something went wrong! ${snapshot.error}');
                //     } else if (snapshot.hasData) {
                //       final doctors = snapshot.data!;
                //       return ListView(
                //         shrinkWrap: true,
                //         physics: NeverScrollableScrollPhysics(),
                //         children: doctors.map(buildDoctor).toList(),
                //       );
                //     } else {
                //       return const Text('Loading...');
                //     }
                //   },
                // ),
                StreamBuilder(
                  stream: readDoctor(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong! ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final doctors = snapshot.data!;
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(10),
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
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: buildDoctor(doctors[index]),
                          );
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
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
