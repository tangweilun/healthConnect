import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:health_connect/components/my_button.dart';

import 'package:health_connect/pages/custom_appbar.dart';
import 'package:health_connect/providers/doctor_provider.dart';
import 'package:health_connect/theme/colors.dart';

class DoctorDetails extends ConsumerWidget {
  const DoctorDetails({super.key});

  //for favourite button
  final bool isFav = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final doctor = ref.read(selectedDoctorProvider);
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Doctor Details',
        icon: const Icon(Icons.arrow_back_ios),
        actions: [
          //Favourite button
          IconButton(
              onPressed: () {},
              icon: Icon(
                isFav ? Icons.favorite_outline_rounded : Icons.favorite_outline,
                color: Colors.red,
              ))
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
                        NetworkImage(doctor.image) as ImageProvider,
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
                  SizedBox(
                    width: screenWidth * 0.75,
                    child: const Text(
                      'Columnbia University, Malaysia, Dr. Roberts completed her residency training at the renowned Mayo Clinic, where she honed her skills in preventive medicine, acute care, and chronic disease management.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  SizedBox(
                    width: screenWidth * 0.75,
                    child: const Text(
                      'Sarawak General Hospital',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          width: screenWidth * 0.5,
                        ),

                        //doctor exp, patient and rating
                        // const DoctorInfo(),

                        Row(
                          children: [
                            const InfoCard(label: 'Patient', value: "109"),
                            SizedBox(
                              width: screenWidth * 0.05,
                            ),
                            const InfoCard(
                                label: 'Experience', value: "10 Years"),
                            SizedBox(
                              width: screenWidth * 0.05,
                            ),
                            const InfoCard(label: 'Rating', value: "4.6"),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        const Text(
                          'About Doctor',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        const Text(
                          'Dr.Tan is an experience Dentist at Sarawal. he is graduated since 2008, and completed his training at Sungai Buloh Hospital',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                          softWrap: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: MyButton(
                            width: double.infinity,
                            disable: false,
                            onTap: () {
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

            // const Spacer(),
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
          vertical: 24,
          horizontal: 10,
        ),
        child: Column(children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
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
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          )
        ]),
      ),
    );
  }
}
