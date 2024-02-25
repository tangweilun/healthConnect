import 'package:flutter/material.dart';

class AddUserTool extends StatefulWidget {
  const AddUserTool({super.key});

  @override
  _AddUserToolState createState() => _AddUserToolState();
}

class _AddUserToolState extends State<AddUserTool> {
  String _selectedUserRole = 'Patient';
  String _selectedDepartment = 'Department A'; // Set an initial value that exists in the department list
  String _selectedBloodType = 'A+';

  final List<String> _userRoles = ['Patient','Doctor'];
  final List<String> _departments = ['Department A', 'Department B', 'Department C'];
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

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
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Gender',
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'DOB',
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
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
            const SizedBox(height: 20.0),
            // Add more text form fields for other user details (gender, email, DOB, phone number)
            if (_selectedUserRole == 'Doctor') ...[
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                items: _departments.map((department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Department',
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Specialty',
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Work Experience',
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Add functionality to save user details
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
