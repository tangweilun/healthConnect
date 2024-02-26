import 'package:flutter/material.dart';
import 'package:health_connect/theme/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: AppColors.darkNavyBlue,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: currentIndex == 0 ? 40 : 24),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today, size: currentIndex == 1 ? 40 : 24),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: currentIndex == 2 ? 40 : 24),
          label: 'Profile',
        ),
      ],
    );
  }
}
