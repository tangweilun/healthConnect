import 'package:flutter/material.dart';
import 'package:health_connect/theme/colors.dart';
import 'package:health_connect/services/doctor/doctor_info_getter.dart';

class DoctorNewPassword extends StatefulWidget {
  final String doctorEmail;

  DoctorNewPassword({required this.doctorEmail});

  @override
  _DoctorNewPasswordState createState() => _DoctorNewPasswordState();
}

class _DoctorNewPasswordState extends State<DoctorNewPassword> {
  DoctorInfo doctorInfo = DoctorInfo(); // Instantiate DoctorInfo

  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _togglePasswordVisibility(String field) {
    setState(() {
      if (field == 'current') {
        _obscureCurrentPassword = !_obscureCurrentPassword;
      } else if (field == 'new') {
        _obscureNewPassword = !_obscureNewPassword;
      } else if (field == 'confirm') {
        _obscureConfirmPassword = !_obscureConfirmPassword;
      }
    });
  }

  Future<void> changePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords don't match")),
      );
      return;
    }

    try {
      await doctorInfo.changePassword(
          widget.doctorEmail, currentPassword, newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password changed successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to change password: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkNavyBlue,
        title: Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPasswordField(
                labelText: 'Current Password',
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                toggleVisibility: () => _togglePasswordVisibility('current'),
              ),
              SizedBox(height: 20.0),
              _buildPasswordField(
                labelText: 'New Password',
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                toggleVisibility: () => _togglePasswordVisibility('new'),
              ),
              SizedBox(height: 20.0),
              _buildPasswordField(
                labelText: 'Confirm New Password',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                toggleVisibility: () => _togglePasswordVisibility('confirm'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                ),
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _clearFields(); // Call function to clear fields
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepBlue,
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepBlue,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  Widget _buildPasswordField({
    required String labelText,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: labelText),
            controller: controller,
            obscureText: obscureText,
          ),
        ),
        IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ],
    );
  }
}
