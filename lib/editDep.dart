import 'package:flutter/material.dart';
import 'theme/colors.dart';

class EditDepartment extends StatelessWidget {
  const EditDepartment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Department'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Enter Department ID',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle search logic here
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: AppColors.darkNavyBlue, // Use button text color from theme
              ),
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
