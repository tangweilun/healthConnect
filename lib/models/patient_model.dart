import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String bloodType;
  final DateTime dateOfBirth;
  final String email;
  final String gender;
  final String name;
  final String patientId;
  final String phoneNumber;

  Patient({
    required this.bloodType,
    required this.dateOfBirth,
    required this.email,
    required this.gender,
    required this.name,
    required this.patientId,
    required this.phoneNumber,
  });

  // Convert the Patient object to a Map (JSON-like structure)
  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'blood_type': bloodType,
      'date_of_birth': dateOfBirth,
      'email': email,
      'gender': gender,
      'name': name,
      'phone_number': phoneNumber,
    };
  }

  // Create a factory method to convert a map to a Patient object
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      bloodType: json['blood_type'],
      dateOfBirth: (json['date_of_birth'] as Timestamp).toDate(),
      email: json['email'],
      gender: json['gender'],
      name: json['name'],
      patientId: json['patient_id'],
      phoneNumber: json['phone_number'],
    );
  }
}
