import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_connect/theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:health_connect/pages/doctor/medical_record_dialog.dart';
import 'package:health_connect/models/doctor/medical_record.dart';
import 'package:health_connect/services/doctor/medical_record_service.dart';

class PatientsRecordsPage extends StatefulWidget {
  const PatientsRecordsPage({Key? key}) : super(key: key);

  @override
  _PatientsRecordsPageState createState() => _PatientsRecordsPageState();
}

class _PatientsRecordsPageState extends State<PatientsRecordsPage> {
  TextEditingController searchController = TextEditingController();
  late Stream<List<MedicalRecord>> recordsStream; // Update the type of recordsStream
  late MedicalRecordService _medicalRecordService; // Declare MedicalRecordService instance

  @override
  void initState() {
    super.initState();
    _medicalRecordService = MedicalRecordService(); // Initialize MedicalRecordService
    recordsStream = _medicalRecordService.getMedicalRecordsStream(); // Use MedicalRecordService method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkNavyBlue,
        title: Text(
          'Patient Records',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by Patient ID',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<MedicalRecord>>( // Update StreamBuilder type
              stream: recordsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                var filteredRecords = snapshot.data!
                    .where((record) => record.patientId.toLowerCase().contains(searchController.text.toLowerCase()))
                    .toList();

                return ListView.builder(
                  itemCount: filteredRecords.length,
                  itemBuilder: (context, index) {
                    var record = filteredRecords[index];
                    String dateAdded = _formatDate(record.date);

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: AppColors.deepBlue),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientDetailsPage(
                                patientId: record.patientId,
                                patientName: record.patientName,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Patient ID: ${record.patientId}',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Patient Name: ${record.patientName}', // Access patientName from MedicalRecord
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Date added: $dateAdded',
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PatientDetailsPage(
                                          patientId: record.patientId,
                                          patientName: record.patientName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('View', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  style: OutlinedButton.styleFrom(backgroundColor: AppColors.deepBlue),
                                ),
                              ],
                            ),
                          ),
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

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
