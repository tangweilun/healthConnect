import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:health_connect/models/doctor/medical_record.dart';
import 'package:health_connect/services/doctor/medical_record_service.dart';
import 'package:health_connect/theme/colors.dart';

class AddMedicalRecordPage extends StatefulWidget {
  const AddMedicalRecordPage({Key? key}) : super(key: key);

  @override
  _AddMedicalRecordPageState createState() => _AddMedicalRecordPageState();
}

class _AddMedicalRecordPageState extends State<AddMedicalRecordPage> {
  PlatformFile? pickedFile;
  String photoUrl = '';
  String patientId = '';
  String doctorId = '';
  String diagnosis = '';
  String notes = '';
  String prescribedMedication = '';
  String symptoms = '';
  String patientName = '';

  final MedicalRecordService _medicalRecordService = MedicalRecordService();

  Future<void> selectPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        pickedFile = PlatformFile(
          name: image.name,
          path: image.path,
          size: File(image.path!).lengthSync(),
        );
      });

      if (pickedFile != null) {
        uploadFile();
      }
    }
  }

  Future<void> uploadFile() async {
    final path = pickedFile!.name;
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);

    final urlDownload = await ref.getDownloadURL();
    setState(() {
      photoUrl = urlDownload;
    });
    print('Download Link: $urlDownload');
  }

  Future<void> submitMedicalRecord() async {
    try {
      patientName = await _medicalRecordService.getPatientName(patientId);

      if (patientName == 'Patient not found') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Patient not found'),
              content: Text('The entered patient ID was not found.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      String doctorName = await _medicalRecordService.getDoctorName(doctorId);
      if (doctorName == 'Doctor not found') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Doctor not found'),
              content: Text('The entered doctor ID was not found.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      MedicalRecord record = MedicalRecord(
        patientId: patientId,
        doctorId: doctorId,
        diagnosis: diagnosis,
        notes: notes,
        prescribedMedication: prescribedMedication,
        symptoms: symptoms,
        photoUrl: photoUrl,
        date: DateTime.now(), // for the current date
        patientName: patientName,
        doctorName: doctorName,
      );

      await _medicalRecordService.addMedicalRecord(record);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Medical record for $patientName was added successfully'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      print('Medical record submitted successfully');
    } catch (error) {
      print('Error submitting medical record: $error');
    }
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.blue, width: 2.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Add Photo'),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    selectPhoto(ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    selectPhoto(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkNavyBlue,
        title: Text(
          'Add Medical Record',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    patientId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Patient ID',
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    doctorId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Doctor ID',
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    symptoms = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Symptoms',
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    diagnosis = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Diagnosis',
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    notes = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Notes',
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    prescribedMedication = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Prescribed Medication',
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _showImageSourceDialog,
                child: Text('Add Photo'),
                style: ButtonStyle(
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(color: AppColors.deepBlue, width: 2.0),
                  ),
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                ),
              ),
              if (photoUrl.isNotEmpty) ...[
                SizedBox(height: 10),
                Image.network(
                  photoUrl,
                  height: 100,
                  width: 100,
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitMedicalRecord,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.deepBlue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
