import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:health_connect/components/my_button.dart';

import 'package:health_connect/pages/custom_appbar.dart';
import 'package:health_connect/providers/doctor_provider.dart';
import 'package:health_connect/providers/reschedule_provider.dart';
import 'package:health_connect/theme/colors.dart';

class DoctorDetails extends ConsumerWidget {
  const DoctorDetails({super.key});

  //for favourite button
  final bool isFav = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final doctor = ref.watch(selectedDoctorProvider);
    return Scaffold(
      appBar: const CustomAppBar(
        appTitle: 'Doctor Details',
        icon: Icon(Icons.arrow_back_ios),
        actions: [
          //Favourite button
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       isFav ? Icons.favorite_outline_rounded : Icons.favorite_outline,
          //       color: Colors.red,
          //     ))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // AboutDoctor(),
            // DetailBody(), //build doctor avatar and intro here
            SizedBox(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 65.0,
                    backgroundImage:
                        NetworkImage(doctor.photo) as ImageProvider,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors
                                .grey, // Change this color to whatever you desire
                            width:
                                2, // Change the width of the border as needed
                          ),
                        ),
                        width: 90,
                        height: 40,
                        child: Text(
                          doctor.speciality,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.02,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors
                                .grey, // Change this color to whatever you desire
                            width:
                                2, // Change the width of the border as needed
                          ),
                        ),
                        width: 90,
                        height: 40,
                        child: Center(
                          child: Text(
                            doctor.department,
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  // SizedBox(
                  //   width: screenWidth * 0.75,
                  //   child: Text(
                  //     doctor.speciality,
                  //     style: TextStyle(
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 15,
                  //     ),
                  //     softWrap: true,
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          width: screenWidth * 0.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InfoCard(
                                label: 'Patient Count',
                                value: doctor.numberOfPreviousPatient),
                            SizedBox(
                              width: screenWidth * 0.05,
                            ),
                            InfoCard(
                                label: 'Experience',
                                value: "${doctor.workingExperience} Years"),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        const Text(
                          'About Doctor',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        SizedBox(
                          width: screenWidth * 0.75,
                          child: Text(
                            doctor.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: MyButton(
                            width: double.infinity,
                            disable: false,
                            onTap: () {
                              //is creating appointment
                              ref
                                  .read(rescheduleProvider.notifier)
                                  .update((state) => false);
                              //navigate to booking appointment page
                              GoRouter.of(context)
                                  .go('/doctordetail/appointmentbooking');
                            },
                            text: "Book Appointment",
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: mediumBlueGrayColor),
        padding: const EdgeInsets.symmetric(
          vertical: 22,
          horizontal: 8,
        ),
        child: Column(children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          )
        ]),
      ),
    );
  }
}
