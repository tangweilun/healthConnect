import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;

  const SquareTile({Key? key, required this.imagePath, required this.onTap})
      : super(key: key);

  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate tile size as a percentage of the screen width
    double tileSize = screenWidth * 0.2; // Adjust the percentage as needed

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(tileSize * 0.1),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(tileSize * 0.2),
        ),
        child: Image.asset(
          imagePath,
          height: tileSize * 0.5, // Adjust image height as needed
        ),
      ),
    );
  }
}
