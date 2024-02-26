import 'package:flutter/material.dart';
import 'theme/colors.dart';

class AddDepTool extends StatelessWidget {
  final TextEditingController departmentNameController =
      TextEditingController();

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
              onPressed: () {
                // Handle adding department logic here
                addDepartment();
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

  void addDepartment() {
    String departmentName = departmentNameController.text;

    // Instead of Firestore code, you can put your custom logic here
    // For example, you could print the department name
    print('Department Name: $departmentName');
  }
}
