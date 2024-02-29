import 'package:flutter/material.dart';
import 'theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'id_generator.dart';

class AddDepTool extends StatelessWidget {
  final TextEditingController departmentNameController = TextEditingController();
  final IDGenerator idGenerator = IDGenerator();

  AddDepTool({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Department'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: departmentNameController,
              decoration: const InputDecoration(
                labelText: 'Department Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {

                await addDepartment(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.darkNavyBlue,
              ),
              child: const Text('Add Department'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addDepartment(BuildContext context) async {
    String departmentName = departmentNameController.text;
    if (departmentName.isNotEmpty) {
      try {
        // Generate auto ID
        String autoId = await idGenerator.generateId('department');

        // Add the department to the 'department' collection with auto-generated ID
        await FirebaseFirestore.instance.collection('department').doc(autoId).set({
          'department_name': departmentName,
          'department_id': autoId, // Add Department ID field
          // Add any other department details here
        });

        // Clear text field after successful addition
        departmentNameController.clear();

        // Show a success message using a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Department added successfully')));
      } catch (e) {
        // Handle errors or show an error message
        print('Error adding department: $e');
        // Show an error message using a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding department: $e')));
      }
    } else {
      // Handle empty input, show an error message
      print('Department name cannot be empty');
      // Show an error message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Department name cannot be empty')));
    }
  }
}
