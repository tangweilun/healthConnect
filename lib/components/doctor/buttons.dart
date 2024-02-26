import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_connect/theme/colors.dart';

enum ButtonType { empty, filled }

class Button extends StatelessWidget {
  final String title;
  final String appointmentId;
  final ButtonType type; // New parameter for button type
  final VoidCallback onPressed; // New parameter for onPressed callback

  const Button({
    Key? key,
    required this.title,
    required this.appointmentId,
    required this.type, // New required parameter
    required this.onPressed, // New required parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed, // Invoke onPressed callback
        style: OutlinedButton.styleFrom(
          side: type == ButtonType.empty
              ? BorderSide(
                  color: AppColors
                      .deepBlue, // Use red border color for empty buttons
                  width: 2.0, // Thin border for empty buttons
                )
              : BorderSide.none, // No border for filled buttons
          backgroundColor: type == ButtonType.filled
              ? AppColors.deepBlue // Use deepBlue color for filled buttons
              : Colors.transparent, // No background color for empty buttons
        ),
        child: Text(
          title,
          style: TextStyle(
            color: type == ButtonType.filled ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
