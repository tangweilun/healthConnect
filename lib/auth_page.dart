// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:health_connect/navigation_route.dart';

// import 'package:health_connect/pages/patient/loginOrRegister_page.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: ((context, snapshot) {
//           if (snapshot.hasData) {
//             return NavigationRoute();
//           } else {
//             return const LoginOrRegisterPage();
//           }
//         }),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:health_connect/navigation_route.dart';
// import 'package:health_connect/pages/doctor/doctor_home_page.dart';
// import 'package:health_connect/pages/patient/home_page.dart';
// import 'package:health_connect/pages/patient/loginOrRegister_page.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, AsyncSnapshot<User?> authSnapshot) {
//           if (authSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (authSnapshot.hasData) {
//             return StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('Users')
//                   .doc(authSnapshot.data!.email)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
//                 if (userSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (userSnapshot.hasData && userSnapshot.data!.exists) {
//                   var userData = userSnapshot.data!.data();
//                   var userDataMap = userData as Map<String,
//                       dynamic>?; // Cast userData to Map<String, dynamic> or null
//                   var role = userDataMap?[
//                       'UserRole']; // Access 'UserRole' from the Map

//                   switch (role) {
//                     case 'Doctor':
//                       return DoctorHomePage(
//                           doctorEmail: authSnapshot.data!.email!);
//                     case 'Patient':
//                       return NavigationRoute();

//                     default:
//                       return Text('Unhandled role: $role');
//                   }
//                 } else {
//                   return Center(
//                       child:
//                           Text('Error fetching user data or user not found'));
//                 }
//               },
//             );
//           } else {
//             return LoginOrRegisterPage();
//           }
//         },
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:health_connect/navigation_route.dart';

// import 'package:health_connect/pages/patient/loginOrRegister_page.dart';
// import 'package:health_connect/pages/doctor/doctor_home_page.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator(); // Show a loading indicator while fetching user data.
//           }
//           if (snapshot.hasData) {
//             return FutureBuilder<DocumentSnapshot>(
//               future: FirebaseFirestore.instance
//                   .collection('Users')
//                   .doc(snapshot.data!.email)
//                   .get(),
//               builder: (context, userSnapshot) {
//                 if (userSnapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator(); // Show a loading indicator while fetching user data.
//                 }
//                 if (userSnapshot.hasData && userSnapshot.data != null) {
//                   // Fetch user role from Firestore document
//                   String? userRole = userSnapshot.data!.get('UserRole');
//                   String? doctorEmail = userSnapshot.data!.get('Email');

//                   // Determine which page to navigate based on user role
//                   switch (userRole) {
//                     case 'Patient':
//                       return NavigationRoute(); // Navigate to patient page
//                     case 'Doctor':
//                       return DoctorHomePage(
//                         doctorEmail: doctorEmail!,
//                       ); // Navigate to doctor page

//                     default:
//                       return Text(
//                           'Unknown user role'); // Handle unknown user roles
//                   }
//                 } else {
//                   return Text(
//                       'User data not found'); // Handle cases where user data is missing
//                 }
//               },
//             );
//           } else {
//             return const LoginOrRegisterPage(); // Show login/register page if user is not authenticated
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_connect/navigation_route.dart';

import 'package:health_connect/pages/patient/loginOrRegister_page.dart';
import 'package:health_connect/pages/doctor/doctor_home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while fetching user data.
          }
          if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(snapshot.data!.email)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show a loading indicator while fetching user data.
                }
                if (userSnapshot.hasData && userSnapshot.data != null) {
                  // Fetch user role from Firestore document
                  var userData =
                      userSnapshot.data!.data() as Map<String, dynamic>?;

                  // Check if the document contains user data
                  if (userData != null && userData.containsKey('UserRole')) {
                    String? userRole = userData['UserRole'];
                    String? doctoremail = userData['Email'];

                    // Determine which page to navigate based on user role
                    switch (userRole) {
                      case 'patient':
                        return NavigationRoute(); // Navigate to patient page
                      case 'doctor':
                        return DoctorHomePage(
                          doctorEmail: doctoremail ?? '',
                        ); // Navigate to doctor page
                      default:
                        return Text(
                            'Unknown user role'); // Handle unknown user roles
                    }
                  } else {
                    return Text(
                        'User role not found'); // Handle case where UserRole field is missing
                  }
                } else {
                  return Text(
                      'User data not found'); // Handle cases where user data is missing
                }
              },
            );
          } else {
            return const LoginOrRegisterPage(); // Show login/register page if user is not authenticated
          }
        },
      ),
    );
  }
}
