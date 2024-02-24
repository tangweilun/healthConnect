import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_connect/theme/colors.dart';
import 'package:intl/intl.dart';

class PatientDetailsPage extends StatelessWidget {
  final String patientId;
  final String patientName;

  const PatientDetailsPage({Key? key, required this.patientId, required this.patientName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkNavyBlue,
        title: Text(
          '${patientName} Records',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        // Customize the color of the back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient Name: $patientName',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('patient').doc(patientId).get(),
                  builder: (context, patientSnapshot) {
                    if (patientSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (patientSnapshot.hasError) {
                      return Center(child: Text('Error: ${patientSnapshot.error}'));
                    }
                    if (!patientSnapshot.hasData) {
                      return Center(child: Text('No patient data found.'));
                    }
                    var patientData = patientSnapshot.data!.data() as Map<String, dynamic>;
                    Timestamp dobTimestamp = patientData['date_of_birth'];
                    DateTime dob = dobTimestamp.toDate();
                    int age = _calculateAge(dob);
                    return Text(
                      'Age: $age',
                      style: TextStyle(fontSize: 16),
                    );
                  },
                ),
                SizedBox(height: 10),
                Text('Patient ID: $patientId', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('medical_record')
                  .where('patient_id', isEqualTo: patientId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No medical records found for this patient.'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var record = snapshot.data!.docs[index];
                    var data = record.data() as Map<String, dynamic>;
                    String formattedDate = _formatDate(data['date']);
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: AppColors.deepBlue),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: $formattedDate',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text('Diagnosis: ${data['diagnosis']}', style: TextStyle(fontSize: 14)),
                            SizedBox(height: 2),
                            Text('Doctor: ${data['doctor_name']}', style: TextStyle(fontSize: 14)),
                            SizedBox(height: 2),
                            Text('Notes: ${data['notes']}', style: TextStyle(fontSize: 14)),
                            // SizedBox(height: 2),
                            Text('Prescribed Medication: ${data['prescribed_medication']}', style: TextStyle(fontSize: 14)),
                            // SizedBox(height: 2),
                            Text('Symptoms: ${data['symptoms']}', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(date);
  }

  int _calculateAge(DateTime dob) {
    DateTime now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }
}
