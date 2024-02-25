import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_connect/models/doctor_model.dart';
import 'package:health_connect/theme/colors.dart';

class DoctorCard extends StatefulWidget {
  const DoctorCard({super.key});

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  // late final Doctor doctor;
  Doctor doctor = Doctor(
    id: "D001",
  );
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: paleGreyColor,
          child: Row(children: [
            SizedBox(
              width: screenWidth * 0.33,
              child: Image.asset(
                'assets/images/doctor_4.jpg',
                fit: BoxFit.fill,
              ),
            ),
            const Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Dr Jack',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Dental',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                          size: 16,
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Text('4.5'),
                        Spacer(
                          flex: 1,
                        ),
                        Text('Reviews'),
                        Spacer(
                          flex: 1,
                        ),
                        Text('(20)'),
                        Spacer(
                          flex: 7,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
        onTap: () {
          //redirect to doctor detail
          GoRouter.of(context).go('/doctordetail');
        },
      ),
    );
  }
}
