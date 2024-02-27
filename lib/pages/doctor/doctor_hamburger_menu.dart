import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:health_connect/auth_page.dart';
import 'package:health_connect/pages/doctor/doctor_user_manual.dart';
import 'package:health_connect/theme/colors.dart';

class HamburgerMenu extends StatelessWidget {
  final Function(String) onMenuItemClicked;

  const HamburgerMenu({Key? key, required this.onMenuItemClicked})
      : super(key: key);

  // This function handles user sign out
  Future<void> signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => AuthPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.darkNavyBlue,
            ),
            child: Text(
              'HealthConnect Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('User Manual'),
            onTap: () {
              onMenuItemClicked('User Manual');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HealthConnectUserManualPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Log out'),
            onTap: () {
              signUserOut(context); // Call the sign out function
            },
          ),
        ],
      ),
    );
  }
}
