import 'package:flutter/material.dart';
import 'package:health_connect/pages/manager/manageDepOption.dart';
import 'package:health_connect/pages/manager/manage_user_option.dart';
import 'package:health_connect/theme/colors.dart';

import 'naviBar.dart'; // Import your naviBar.dart file with a prefix
import 'topScreen.dart'; // Import your TopScreen widget

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Management'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopScreen(), // Add the TopScreen widget here
          const SizedBox(
              height: 20), // Add spacing between TopScreen and other content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageUsersOptions()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.darkNavyBlue, // Text color
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50), // Adjust padding here
                  ),
                  icon:
                      const Icon(Icons.people), // Icon for Manage Users button
                  label: const Text(
                    'Manage Users',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageDepOptions()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.darkNavyBlue, // Text color
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50), // Adjust padding here
                  ),
                  icon: const Icon(
                      Icons.business), // Icon for Manage Department button
                  label: const Text(
                    'Manage Department',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to app report page
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.blueGray, // Text color
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50), // Adjust padding here
                  ),
                  icon: const Icon(Icons.receipt), // Icon for App Report button
                  label: const Text(
                    'App Report',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NaviBar(), // Add NavigationBar here
    );
  }
}
