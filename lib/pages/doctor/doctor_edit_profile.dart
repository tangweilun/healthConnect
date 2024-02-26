import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:health_connect/theme/colors.dart';
import 'package:health_connect/pages/doctor/doctor_new_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_connect/services/doctor/doctor_info_getter.dart';

class EditProfileScreen extends StatefulWidget {
  final String userEmail;
  final void Function(int) navigateToPage;

  const EditProfileScreen(
      {Key? key, required this.navigateToPage, required this.userEmail})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String doctorName = "";
  String id = "";
  String specialty = "";
  int age = 0;
  String email = "";
  String gender = "";
  String photoUrl = '';
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
    fetchDoctorInfo();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  void fetchDoctorInfo() async {
    try {
      final userData = await DoctorInfo().getUserByEmail(widget.userEmail);

      if (userData != null) {
        setState(() {
          doctorName = userData['name'];
          id = userData['doctor_id'];
          specialty = userData['speciality'];
          age = userData['age'];
          email = userData['email'];
          gender = userData['gender'];
          photoUrl = userData['photo'];
          String phoneNumber = userData['phone_number'];
          // Remove the "+60" prefix if it exists
          if (phoneNumber.startsWith("+60")) {
            phoneNumber = phoneNumber.substring(3);
          }
          _phoneNumberController.text = phoneNumber;
        });
      }
    } catch (e) {
      print("Error fetching doctor's info: $e");
    }
  }

  Future selectPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });

      if (pickedFile != null) {
        uploadFile();
      }
    }
  }

  Future uploadFile() async {
    final path = pickedFile!.name;
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() {
      photoUrl = urlDownload;
    });
    print('Download Link: ${urlDownload}');
  }

  @override
  Widget build(BuildContext context) {
    bool isValidNumber(String number) {
      // Example validation: Check if the number has 10 digits
      return number.replaceAll(RegExp(r'\D'), '').length == 10 ||
          number.replaceAll(RegExp(r'\D'), '').length == 9;
    }

    Future<void> updateInfo(String newPhoneNumber) async {
      try {
        if (!isValidNumber(newPhoneNumber)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Invalid phone number. Please enter a valid phone number.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Replace 'YOUR_DOCTOR_ID' with actual document ID
        await FirebaseFirestore.instance.collection('doctor').doc(id).update({
          'phone_number': '+60$newPhoneNumber',
          'photo': photoUrl, // Add photoUrl to the document
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone number updated successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Error updating phone number: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkNavyBlue,
        title: Text(
          'Update Profile',
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
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(photoUrl),
                ),
                SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    selectPhoto();
                  },
                  child: Icon(Icons.edit), // Add an edit icon
                ),
              ],
            ),
            SizedBox(height: 20.0),
            _buildProfileInfo(title: 'Full Name', value: doctorName),
            SizedBox(height: 20.0),
            _buildProfileInfo(title: 'Specialty', value: specialty),
            SizedBox(height: 20.0),
            _buildProfileInfo(title: 'Age', value: age.toString()),
            SizedBox(height: 20.0),
            _buildProfileInfo(title: 'Email', value: email),
            SizedBox(height: 20.0),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Phone Number (without: +60)'),
              controller: _phoneNumberController,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorNewPassword(
                      doctorEmail: email,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepBlue,
              ),
              child: Text(
                'Change Password',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    updateInfo(_phoneNumberController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(
      {required String title, required String value, bool readOnly = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black87),
        ),
      ],
    );
  }
}
