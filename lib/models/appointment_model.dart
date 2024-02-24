import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  // String id;
  final String id;
  final String patientID;
  final String doctorID;
  final DateTime date;
  final String status;
  final String department;
  final String doctorName;
  final String photo;
  final String patientName;
  final String speciality;

  Appointment({
    // this.id = '',
    required this.id,
    required this.patientID,
    required this.doctorID,
    required this.date,
    required this.status,
    required this.department,
    required this.doctorName,
    required this.photo,
    required this.patientName,
    required this.speciality,
  });

  // Convert the Appointment object to a Map (JSON-like structure)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientID': patientID,
      'doctorID': doctorID,
      'date': date,
      // Convert DateTime to ISO 8601 format
      'status': status,
      'speciality': speciality,
      'department': department,
      'doctorName': doctorName,
      'photo': photo,
      'patientName': patientName,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      // id: ,
      patientID: json['patientID'],
      doctorID: json['doctorID'],

      date:
          (json['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      status: json['status'],
      department: json['department'],
      speciality: json['speciality'],
      doctorName: json['doctorName'],
      photo: json['photo'],
      patientName: json['patientName'],
    );
  }
}
