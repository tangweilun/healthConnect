import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_connect/models/doctor/medical_record.dart';
import 'package:health_connect/id_generator.dart';

class MedicalRecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final IDGenerator _idGenerator = IDGenerator();

  Future<void> addMedicalRecord(MedicalRecord record) async {
    try {
      String medicalRecordId = await _idGenerator.generateId('medical_record');
      DateTime currentDate = DateTime.now();
      Timestamp timestamp = Timestamp.fromDate(currentDate);

      Map<String, dynamic> recordData = record.toMap();
      recordData['date'] = timestamp;

      await _firestore.collection('medical_record').doc(medicalRecordId).set(recordData);
    } catch (error) {
      print('Error adding medical record: $error');
      rethrow;
    }
  }

  Future<String> getDoctorName(String doctorId) async {
    try {
      DocumentSnapshot doctorSnapshot = await _firestore.collection('doctor').doc(doctorId).get();
      if (doctorSnapshot.exists) {
        return doctorSnapshot['name'];
      } else {
        return 'Doctor not found';
      }
    } catch (error) {
      print('Error getting doctor name: $error');
      return 'Error';
    }
  }

  Future<String> getPatientName(String patientId) async {
    try {
      DocumentSnapshot patientSnapshot = await _firestore.collection('patient').doc(patientId).get();
      if (patientSnapshot.exists) {
        return patientSnapshot['name'];
      } else {
        return 'Patient not found';
      }
    } catch (error) {
      print('Error getting patient name: $error');
      return 'Error';
    }
  }

  Stream<List<MedicalRecord>> getMedicalRecordsStream() {
    return _firestore.collection('medical_record').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => MedicalRecord.fromMap(doc.data())).toList());
  }
}
