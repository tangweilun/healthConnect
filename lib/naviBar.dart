import 'package:flutter/material.dart';
import 'userManual.dart';
class NaviBar extends StatelessWidget {
  const NaviBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              color: Colors.blue.withOpacity(0.3), // Set background color with opacity
              child: IconButton(
                icon: const Icon(Icons.home), // Home icon
                onPressed: () {
                  // Navigate to home page
                  Navigator.pushNamed(context, '/home');
                },
                color: Colors.blue, // Set icon color
              ),
            ),
            Container(
              color: Colors.green.withOpacity(0.3), // Set background color with opacity
              child: IconButton(
                icon: const Icon(Icons.person), // Profile icon
                onPressed: () {
                  // Navigate to profile page
                },
                color: Colors.green, // Set icon color
              ),
            ),
            Container(
              color: Colors.orange.withOpacity(0.3), // Set background color with opacity
              child: IconButton(
                icon: const Icon(Icons.library_books), // User manual icon
                onPressed: () {
                  // Navigate to user manual page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserManual()),
                  );
                },
                color: Colors.orange, // Set icon color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
