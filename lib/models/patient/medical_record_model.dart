import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalRecord {
  final String id; // Unique identifier for the record
  final String patientId; // ID of the patient associated with the record
  final String doctorId; // ID of the doctor who created the record
  final DateTime date; // Date when the record was created
  final String diagnosis; // Diagnosis or medical condition
  final String treatment; // Treatment prescribed
  final List<String> medications; // List of medications
  final String userId; // ID of the user (patient)

  MedicalRecord({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.diagnosis,
    required this.treatment,
    required this.medications,
    required this.userId,
  });

  // Convert MedicalRecord object to a Map (JSON-like structure) for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'date': Timestamp.fromDate(date),
      'diagnosis': diagnosis,
      'treatment': treatment,
      'medications': medications,
      'userId': userId,
    };
  }

  // Create a MedicalRecord object from a Firestore document snapshot
  factory MedicalRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MedicalRecord(
      id: doc.id,
      patientId: data['patientId'],
      doctorId: data['doctorId'],
      date: (data['date'] as Timestamp).toDate(),
      diagnosis: data['diagnosis'],
      treatment: data['treatment'],
      medications: List<String>.from(data['medications']),
      userId: data['userId'],
    );
  }
}
