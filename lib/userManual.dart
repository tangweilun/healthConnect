import 'package:flutter/material.dart';
import 'naviBar.dart';

class UserManual extends StatelessWidget {
  const UserManual({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Manual'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Manual: Hospital Management App',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            _buildSection(
              title: '1. Adding a User:',
              content: 'To add a new user to the system, follow these steps: ...',
            ),
            _buildSection(
              title: '2. Editing a User:',
              content: 'To edit an existing user\'s information, follow these steps: ...',
            ),
            _buildSection(
              title: '3. Deleting a User:',
              content: 'To delete a user from the system, follow these steps: ...',
            ),
            _buildSection(
              title: '4. Viewing Users:',
              content: 'To view a list of all users in the system, follow these steps: ...',
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NaviBar(),
    );
  }

  Widget _buildSection({required title, required content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
