import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_connect/id_generator.dart';
import 'package:health_connect/pages/custom_appbar.dart';
import 'package:health_connect/services/auth_services.dart';
import 'package:health_connect/theme/colors.dart';
import 'package:intl/intl.dart';

class PatientDetailsPage extends StatefulWidget {
  const PatientDetailsPage({Key? key}) : super(key: key);

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  final AuthService _authService = AuthService();
  // Create an instance of AuthService
  String patientId = '';
  // Variable to hold the patient ID
  String patientName = '';

  @override
  void initState() {
    super.initState();
    _getPatientID(); // Call the method to retrieve the patient ID when the screen initializes
    _getPatientName();
  }

  Future<void> _getPatientID() async {
    String? id =
        await _authService.getPatientID(); // Call the method from AuthService
    setState(() {
      patientId =
          id ?? ''; // Update the state variable with the retrieved patient ID
    });
  }

  Future<void> _getPatientName() async {
    String? name =
        await _authService.getPatientName(); // Call the method from AuthService
    setState(() {
      patientName =
          name ?? ''; // Update the state variable with the retrieved patient ID
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: '$patientName\'s Medical Records',
        icon: const Icon(Icons.arrow_back_ios),
        actions: [],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
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
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No medical records found for you.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var record = snapshot.data!.docs[index];
                    var data = record.data() as Map<String, dynamic>;
                    String formattedDate = _formatDate(data['date']);
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: darkNavyBlueColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Date: $formattedDate',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.local_hospital, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Diagnosis: ${data['diagnosis']}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.person, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Doctor: ${data['doctor_name']}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.note, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Notes: ${data['notes']}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.medical_services, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Prescribed Medication: ${data['prescribed_medication']}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.healing, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Symptoms: ${data['symptoms']}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                // return ListView.builder(
                //   itemCount: snapshot.data!.docs.length,
                //   itemBuilder: (context, index) {
                //     var record = snapshot.data!.docs[index];
                //     var data = record.data() as Map<String, dynamic>;
                //     String formattedDate = _formatDate(data['date']);
                //     return Card(
                //       margin: const EdgeInsets.symmetric(
                //           vertical: 8, horizontal: 16),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(15),
                //         side: const BorderSide(color: darkNavyBlueColor),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.all(12),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               'Date: $formattedDate',
                //               style: const TextStyle(
                //                   fontSize: 16, fontWeight: FontWeight.bold),
                //             ),
                //             const SizedBox(height: 4),
                //             Text('Diagnosis: ${data['diagnosis']}',
                //                 style: const TextStyle(fontSize: 14)),
                //             const SizedBox(height: 2),
                //             Text('Doctor: ${data['doctor_name']}',
                //                 style: const TextStyle(fontSize: 14)),
                //             const SizedBox(height: 2),
                //             Text('Notes: ${data['notes']}',
                //                 style: const TextStyle(fontSize: 14)),
                //             // SizedBox(height: 2),
                //             Text(
                //                 'Prescribed Medication: ${data['prescribed_medication']}',
                //                 style: const TextStyle(fontSize: 14)),
                //             // SizedBox(height: 2),
                //             Text('Symptoms: ${data['symptoms']}',
                //                 style: const TextStyle(fontSize: 14)),
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // );
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
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }
}
