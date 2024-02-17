// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:health_connect/models/appointment_model.dart';

// class FireStore_CRUD {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future createAppointment({required String name}) async {
//     final docAppointment =
//         FirebaseFirestore.instance.collection('appointment').doc();

//     final apponintment = Appointment(
//         id: docAppointment.id,
//         patientId: patientId,
//         doctorId: doctorId,
//         date: date);
//     final json = apponintment.toJson();

//     await docAppointment.set(json);
//   }
// }
