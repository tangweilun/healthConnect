import 'package:flutter/material.dart';
import 'package:health_connect/components/my_button.dart';
import 'package:health_connect/pages/custom_appbar.dart';
import 'package:health_connect/theme/colors.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({super.key});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  //for favourite button
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
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
          child: Column(
        children: <Widget>[
          AboutDoctor(),
          DetailBody(), //build doctor avatar and intro here
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: MyButton(
              width: double.infinity,
              disable: false,
              onTap: () {
                //navigate to booking appointment page
                // Navigator.of(context).pushNamed('');
              },
              text: "Book Appointment",
            ),
          )
        ],
      )),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  const AboutDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          const CircleAvatar(
            radius: 65.0,
            backgroundImage: AssetImage('assets/images/doctor_2.jpg'),
            backgroundColor: Colors.white,
          ),
          const SizedBox(
            height: 23,
          ),
          const Text(
            'Dr Richard Tan',
            style: TextStyle(
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
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: screenWidth * 0.5,
          ),
          // DoctorInfo(),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          const Text(
            'About Doctor',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// class DoctorInfo extends StatelessWidget {
//   const DoctorInfo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Row(
//       children: <Widget>[
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color: mediumBlueGrayColor),
//             padding: const EdgeInsets.symmetric(
//               vertical: 30,
//               horizontal: 15,
//             ),
//             child: Column(children: <Widget>[
//               const Text(
//                 'Patients',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(
//                 height: screenHeight * 0.2,
//               ),
//               const Text(
//                 '109',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w800,
//                 ),
//               )
//             ]),
//           ),
//         )
//       ],
//     );
//   }
// }

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: mediumBlueGrayColor),
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(children: <Widget>[
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: screenHeight * 0.5,
          ),
          Text(
            value,
            style: TextStyle(
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
