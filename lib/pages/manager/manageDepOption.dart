import 'package:flutter/material.dart';
import 'package:health_connect/pages/manager/viewDepartment.dart';
import 'package:health_connect/theme/colors.dart';
import 'naviBar.dart';
import 'addDepTool.dart';
import 'editDep.dart';

class ManageDepOptions extends StatelessWidget {
  const ManageDepOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Department'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddDepTool()),
                );
              },
              icon: const Icon(Icons.add), // Add icon to the button
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.darkNavyBlue), // Background color
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white), // Text color
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50)), // Adjust padding here
              ),
              label: const Text(
                'Add Department',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditDepartment()),
                );
              },
              icon: const Icon(Icons.edit), // Add icon to the button
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.deepBlue), // Background color
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white), // Text color
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50)), // Adjust padding here
              ),
              label: const Text(
                'Edit Department',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewDepartments()),
                );
              },
              icon: const Icon(Icons.visibility), // Add icon to the button
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.blueGray), // Background color
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white), // Text color
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50)), // Adjust padding here
              ),
              label: const Text(
                'View Departments',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NaviBar(),
    );
  }
}
