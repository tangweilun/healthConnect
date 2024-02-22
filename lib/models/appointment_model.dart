import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String id;
  final String patientID;
  final String doctorID;
  final DateTime date;
  final String status;
  final String category;
  final String doctorName;
  final String image;
  final String patientName;

  Appointment({
    this.id = '',
    required this.patientID,
    required this.doctorID,
    required this.date,
    required this.status,
    required this.category,
    required this.doctorName,
    required this.image,
    required this.patientName,
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
      'category': category,
      'doctorName': doctorName,
      'image': image,
      'patientName': patientName,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json, String id) {
    return Appointment(
      // id: json['id'],
      id: id,
      patientID: json['patientID'],
      doctorID: json['doctorID'],
      // date: DateTime.parse(json['date']), // Parse ISO 8601 string to DateTime
      date:
          (json['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      status: json['status'],
      category: json['category'],
      doctorName: json['doctorName'],
      image: json['image'],
      patientName: json['patientName'],
    );
  }
}
