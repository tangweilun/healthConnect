import 'package:firebase_auth/firebase_auth.dart';

class MedicalRecord {
  final String id;
  final User patient;
  final List<String> conditions;
  final List<String> medications;
  final List<String> allergies;
  final List<String> surgeries;

  MedicalRecord({
    required this.id,
    required this.patient,
    required this.conditions,
    required this.medications,
    required this.allergies,
    required this.surgeries,
  });
}
