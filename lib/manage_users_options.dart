import 'package:flutter/material.dart';
import 'theme/colors.dart';
import 'naviBar.dart';
import 'addUserTool.dart';
import 'editUser.dart';
import 'viewUsers.dart';

class ManageUsersOptions extends StatelessWidget {
  const ManageUsersOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users Options'),
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
                  MaterialPageRoute(builder: (context) => const AddUserTool()),
                );
              },
              icon: const Icon(Icons.add),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.darkNavyBlue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 20, horizontal: 50)),
              ),
              label: const Text(
                'Add User',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditUserPage()), // Navigate to EditUserPage
                );
              },
              icon: const Icon(Icons.edit),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.deepBlue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 20, horizontal: 50)),
              ),
              label: const Text(
                'Edit User',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewUsers()),
                );
              },
              icon: const Icon(Icons.visibility),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.blueGray),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 20, horizontal: 50)),
              ),
              label: const Text(
                'View Users',
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
