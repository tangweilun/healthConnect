import 'package:flutter/material.dart';
import 'package:health_connect/theme/colors.dart';

class HealthConnectUserManualPage extends StatelessWidget {
  const HealthConnectUserManualPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkNavyBlue,
        title: Text(
          'HealthConnect User Manual',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        // Customize the color of the back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HealthConnect User Manual',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Introduction:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Welcome to HealthConnect, your all-in-one solution for managing medical records, appointments, and more. This user manual will guide you through the various features and functionalities of HealthConnect to help you make the most out of the app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Getting Started:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'To get started with HealthConnect, simply sign in or create an account. Once logged in, you will have access to your dashboard where you can view upcoming appointments, manage patient records, and more.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Features:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '- Appointments: View and manage your appointments with ease. You can accept or reject appointments and view appointment details.\n\n'
                '- Patient Records: Keep track of patient information, medical history, and treatment plans. You can view, edit, and add new patient records.\n\n'
                '- Medical Records: Access and update medical records securely. You can view existing medical records and add new ones.\n\n'
                '- User Profile: Customize your profile and preferences to suit your needs. You can edit your profile information and update preferences.\n\n',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Support:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'If you have any questions or require assistance, please contact our support team:\n\n'
                'Phone: +60145015436\n'
                'Email: quasi.abdullah@gmail.com',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Conclusion:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Thank you for choosing considering the time to read this user manual. We hope this user manual has provided you with the necessary information to navigate the app effectively.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
