import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalRecord {
  final String patientId;
  final String doctorId;
  final String diagnosis;
  final String notes;
  final String prescribedMedication;
  final String symptoms;
  final String photoUrl;
  final DateTime date;
  final String patientName;
  final String doctorName;

  MedicalRecord({
    required this.patientId,
    required this.doctorId,
    required this.diagnosis,
    required this.notes,
    required this.prescribedMedication,
    required this.symptoms,
    required this.photoUrl,
    required this.date,
    required this.patientName,
    required this.doctorName
  });

  Map<String, dynamic> toMap() {
    return {
      'patient_id': patientId,
      'doctor_id': doctorId,
      'diagnosis': diagnosis,
      'notes': notes,
      'prescribed_medication': prescribedMedication,
      'symptoms': symptoms,
      'photo_url': photoUrl,
      'date': date,
      'patient_name': patientName,
      'doctor_name': doctorName
    };
  }

  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      patientId: map['patient_id'] ?? '',
      doctorId: map['doctor_id'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      notes: map['notes'] ?? '',
      prescribedMedication: map['prescribed_medication'] ?? '',
      symptoms: map['symptoms'] ?? '',
      photoUrl: map['photo_url'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      patientName: map['patient_name'] ?? '',
      doctorName: map['doctor_name'] ?? '',
    );
  }

}
