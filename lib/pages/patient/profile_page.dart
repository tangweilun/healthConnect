import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_connect/models/patient_model.dart';
import 'package:health_connect/pages/patient/custom_appbar.dart';
import 'package:health_connect/services/auth_services.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Patient patient = Patient(
      bloodType: 'bloodType',
      dateOfBirth: DateTime.now(),
      email: 'email',
      gender: 'gender',
      name: 'name',
      patientId: 'patientId',
      phoneNumber: 'phoneNumber');
  String patientName = '';
  String patientID = '';

  final AuthService _authService = AuthService();
  Future<void> _getPatientName() async {
    String? name = await _authService.getPatientName();
    setState(() {
      patientName = name ?? '';
    });
  }

  Future<void> _getPatientID() async {
    String? id =
        await _authService.getPatientID(); // Call the method from AuthService
    setState(() {
      patientID =
          id ?? ''; // Update the state variable with the retrieved patient ID
    });
  }

  Future<void> _getPatientFromFireStore() async {
    Patient? patientData =
        await _authService.getPatient(); // Call the method from AuthService
    setState(() {
      patient =
          patientData!; // Update the state variable with the retrieved patient ID
    });
  }

  @override
  void initState() {
    super.initState();
    _getPatientName();
    _getPatientID();
    _getPatientFromFireStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appTitle: 'Profile',
        icon: Icon(Icons.arrow_back_ios),
        actions: [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              _buildEditableRow('Name', patient.name, 'name'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          patient.email,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     _showEditDialog(context, fieldName, _controller);
                      //   },
                      //   child: const Icon(
                      //     Icons.mode_edit_outline_rounded,
                      //     color: Colors.blue,
                      //   ),
                      // ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                ],
              ),
              _buildEditableRow(
                  'Phone Number', patient.phoneNumber, 'phone number'),
              _buildEditableRow(
                  'Date Of Birth',
                  DateFormat('yyyy-MM-dd').format(patient.dateOfBirth),
                  'date of birth'),
              _buildEditableRow('Gender', patient.gender, 'gender'),
              _buildEditableRow('Blood Type', patient.bloodType, 'blood type'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableRow(String label, String value, String fieldName) {
    TextEditingController _controller = TextEditingController(text: value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _showEditDialog(context, fieldName, _controller);
              },
              child: const Icon(
                Icons.mode_edit_outline_rounded,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const Divider(color: Colors.grey),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showEditDialog(BuildContext context, String fieldName,
      TextEditingController controller) {
    Widget editWidget;
    if (fieldName == 'date of birth') {
      editWidget = _buildDatePicker(controller);
    } else if (fieldName == 'gender') {
      editWidget = _buildGenderPicker(controller);
    } else if (fieldName == 'blood type') {
      editWidget = _buildBloodTypePicker(controller);
    } else {
      editWidget = _buildTextField(controller, fieldName);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $fieldName'),
          content: editWidget,
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Implement saving logic here
                _saveField(fieldName, controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBloodTypePicker(TextEditingController controller) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RadioListTile<String>(
              title: const Text('A'),
              value: 'A',
              groupValue: controller.text,
              onChanged: (String? value) {
                setState(() {
                  controller.text = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('B'),
              value: 'B',
              groupValue: controller.text,
              onChanged: (String? value) {
                setState(() {
                  controller.text = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('AB'),
              value: 'AB',
              groupValue: controller.text,
              onChanged: (String? value) {
                setState(() {
                  controller.text = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('O'),
              value: 'O',
              groupValue: controller.text,
              onChanged: (String? value) {
                setState(() {
                  controller.text = value!;
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String fieldName) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: 'Enter new $fieldName'),
    );
  }

  Widget _buildDatePicker(TextEditingController controller) {
    return ElevatedButton(
      onPressed: () {
        _selectDate(context, controller);
      },
      child: Text('Select Date'),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Widget _buildGenderPicker(TextEditingController controller) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RadioListTile<String>(
              title: const Text('Male'),
              value: 'Male',
              groupValue: controller.text,
              onChanged: (String? value) {
                setState(() {
                  controller.text = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Female'),
              value: 'Female',
              groupValue: controller.text,
              onChanged: (String? value) {
                setState(() {
                  controller.text = value!;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _saveField(String fieldName, String newValue) {
    // Implement logic to save the edited field
    // For example, you can update the patient's data in Firestore
    print('Saving $fieldName: $newValue');

    // Get a reference to the Firestore document
    final CollectionReference patients =
        FirebaseFirestore.instance.collection('patient');
    final DocumentReference documentReference = patients.doc(patientID);

    // Create a map containing the field to be updated
    Map<String, dynamic> data = {};

    // Add the field to the data map
    if (fieldName == 'name') {
      data['name'] = newValue;
    } else if (fieldName == 'email') {
      // updateEmail(newValue);

      data['email'] = newValue;
    } else if (fieldName == 'phone number') {
      data['phone_number'] = newValue;
    } else if (fieldName == 'date of birth') {
      // Assuming the date of birth is stored as a DateTime field in Firestore
      data['date_of_birth'] = DateTime.parse(newValue);
    } else if (fieldName == 'gender') {
      data['gender'] = newValue;
    } else if (fieldName == 'blood type') {
      data['blood_type'] = newValue;
    }

    // Update the Firestore document
    documentReference.update(data).then((value) {
      print('Field $fieldName updated successfully');
      setState(() {
        // Refresh the page to reflect the updated data
        _getPatientFromFireStore();
      });
    }).catchError((error) {
      print('Failed to update field $fieldName: $error');
    });
  }

  // void updateEmail(String email, String newEmail) async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   // Update the email
  //   await user?.updateEmail(email);
  //       final docAppointment =
  //       FirebaseFirestore.instance.collection('Users').doc();
  //   docAppointment.update({
  //     'date': newSelectedDateTime,
  //     'status': 'pending',
  //   });

  // }
}
