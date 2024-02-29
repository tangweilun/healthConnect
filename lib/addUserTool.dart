import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'id_generator.dart';

class AddUserTool extends StatefulWidget {
  const AddUserTool({Key? key}) : super(key: key);

  @override
  _AddUserToolState createState() => _AddUserToolState();
}

class _AddUserToolState extends State<AddUserTool> {
  final IDGenerator idGenerator = IDGenerator();
  String _selectedUserRole = 'Patient';
  String? _selectedDepartment; // Set to nullable
  String _selectedBloodType = 'A+';

  final List<String> _userRoles = ['Patient', 'Doctor'];
  List<String> _departments = []; // Initialized as empty since it will be populated from Firestore
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  TextEditingController _user_idController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  String _selectedGender = ''; // Initialize selected gender
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _specialtyController = TextEditingController();
  TextEditingController _workExperienceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _number_of_previous_patient = TextEditingController();
  TextEditingController _fcmTokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
    _number_of_previous_patient.text = '0';
    _fcmTokenController.text = '-';
  }

  Future<void> _fetchDepartments() async {
    try {
      // Fetch departments from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('department').get();
      List<String> departments = querySnapshot.docs.map((doc) {
        return doc.get('department_name') as String;
      }).toList();

      setState(() {
        _departments = departments; // Update the _departments list with fetched department names
      });
    } catch (e) {
      print('Error fetching departments: $e');
    }
  }

  Future<void> _saveUserDetails() async {
    try {
      // Save common user details under "Users" collection
      await FirebaseFirestore.instance.collection('Users').add({
        'email': _emailController.text,
        'UserRole': _selectedUserRole,
        'fcmToken': _fcmTokenController.text,
      });

      // Save additional details under "Patient" or "Doctor" collection based on user role
      if (_selectedUserRole == 'Patient') {
        String autoId = await idGenerator.generateId('patient');

        await FirebaseFirestore.instance.collection('patient').doc(autoId).set({
          'patient_id': autoId,
          'name': _nameController.text,
          'gender': _selectedGender, // Changed to use selected gender
          'date_of_birth': Timestamp.fromDate(DateTime.parse(_dobController.text)),
          'phone_number': _phoneController.text,
          'blood_type': _selectedBloodType, // Changed from 'bloodType' to 'blood_type' to match Firestore
          'email': _emailController.text,
        });
      } else if (_selectedUserRole == 'Doctor') {
        String autoId = await idGenerator.generateId('doctor');
        await FirebaseFirestore.instance.collection('doctor').doc(autoId).set({
          'doctor_id': _user_idController.text = autoId,
          'name': _nameController.text,
          'gender': _selectedGender, // Changed to use selected gender
          'date_of_birth': Timestamp.fromDate(DateTime.parse(_dobController.text)),
          'phone_number': _phoneController.text,
          'department': _selectedDepartment,
          'email': _emailController.text,
          'speciality': _specialtyController.text,
          'work_experience': int.tryParse(_workExperienceController.text),
          'description': _descriptionController.text,
          'number_of_previous_patient': int.tryParse(_number_of_previous_patient.text) ?? 0, // Parse to integer or default to 0
          'photo': 'https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg', // Corrected photo URL
        });
      }

      // Clear text field values after saving
      _nameController.clear();
      _emailController.clear();
      _dobController.clear();
      _phoneController.clear();
      _specialtyController.clear();
      _workExperienceController.clear();
      _descriptionController.clear();
      _number_of_previous_patient.clear();
      _fcmTokenController.clear();
      // Reset selected values
      setState(() {
        _selectedGender = '';
        _selectedBloodType = 'A+';
        _selectedDepartment = null; // Change to null
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User details saved successfully.'),
        ),
      );
    } catch (e) {
      print('Error saving user details: $e');
      // Display an error message to the user if saving user details fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save user details. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedUserRole,
              items: _userRoles.map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUserRole = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'User Role',
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Gender:'),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Male',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                    const Text('Male'),
                    Radio<String>(
                      value: 'Female',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                    const Text('Female'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                final DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  setState(() {
                    _dobController.text = selectedDate.toString(); // Display the selected date
                    // Convert the selected date to a timestamp
                    _dobController.text = Timestamp.fromDate(selectedDate).toDate().toString();
                  });
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: 'DOB',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              value: _selectedBloodType,
              items: _bloodTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBloodType = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Blood Type',
              ),
            ),
            if (_selectedUserRole == 'Doctor') ...[
              const SizedBox(height: 20.0),
              Text(
                'Department:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10.0),
              // Display departments as a list of Radio buttons
              ListView.builder(
                shrinkWrap: true,
                itemCount: _departments.length,
                itemBuilder: (context, index) {
                  final department = _departments[index];
                  return ListTile(
                    title: Text(department),
                    leading: Radio<String>(
                      value: department,
                      groupValue: _selectedDepartment,
                      onChanged: (value) {
                        setState(() {
                          _selectedDepartment = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ],
            if (_selectedUserRole == 'Doctor') ...[
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _specialtyController,
                decoration: const InputDecoration(
                  labelText: 'Specialty',
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _workExperienceController,
                decoration: const InputDecoration(
                  labelText: 'Work Experience',
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
            if (_selectedUserRole == 'Doctor') ...[
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _number_of_previous_patient,
                keyboardType: TextInputType.number, // Set the keyboard type to number
                decoration: const InputDecoration(
                  labelText: 'Number of Previous Patients',
                ),
              ),
            ],
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _saveUserDetails(); // Call method to save user details when button is pressed
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
