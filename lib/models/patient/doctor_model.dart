import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String description;

  final String photo;
  DateTime dateOfBirth = DateTime(1900);
  final String department;
  final String email;
  final String numberOfPreviousPatient;
  final String phoneNumber;
  final String speciality;
  final String workingExperience;
  // Add more properties as needed

  Doctor({
    this.id = '',
    this.name = '',
    this.description = '',
    this.photo = '',
    DateTime? dateOfBirth, // Using required for non-nullable types
    this.department = '',
    this.email = '',
    this.numberOfPreviousPatient = '', // Default value added
    this.phoneNumber = '',
    this.speciality = '',
    this.workingExperience = '',
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['doctor_id'] ?? '',
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      description: json['description'] ?? '',
      dateOfBirth: (json['date_of_birth'] as Timestamp).toDate(),
      department: json['department'] ?? '',
      email: json['email'] ?? '',
      numberOfPreviousPatient:
          json['number_of_previous_patient']?.toString() ?? '',
      phoneNumber: json['phone_number'] ?? '',
      speciality: json['speciality'] ?? '',
      workingExperience: json['work_experience'] ?? '',

      // Add more properties as needed
    );
  }

  Map<String, dynamic> toJson() => {
        'doctor_id': id,
        'name': name,
        'photo': photo,
        'description': description,
        'date_of_birth':
            dateOfBirth.toIso8601String(), // Convert DateTime to string
        'department': department,
        'email': email,
        'number_of_previous_patient': numberOfPreviousPatient,
        'phone_number': phoneNumber,
        'speciality': speciality,
        'work_Experience': workingExperience,
      };
}
