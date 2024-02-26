import 'package:flutter/material.dart';
import 'package:health_connect/theme/colors.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final double width;
  final bool disable;
  final String text;
  MyButton(
      {Key? key,
      required this.onTap,
      required this.text,
      required this.width,
      required this.disable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the color based on the disable state
    Color buttonColor = disable ? Colors.grey : AppColors.mediumBlueGrayColor;
    return GestureDetector(
      onTap: disable ? null : onTap,
      child: Container(
        width: width,
        padding:
            const EdgeInsets.symmetric(vertical: 12), // Adjust padding here
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14, // Adjust font size here
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
