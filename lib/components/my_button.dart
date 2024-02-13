// import 'package:flutter/material.dart';

// class MyButton extends StatelessWidget {
//   final Function()? onTap;

//   const MyButton({super.key, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(25),
//         margin: EdgeInsets.symmetric(horizontal: 25),
//         decoration: BoxDecoration(
//             color: Colors.black, borderRadius: BorderRadius.circular(8)),
//         child: const Center(
//             child: Text(
//           "Sign In",
//           style: TextStyle(
//               color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//         )),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  MyButton({Key? key, required this.onTap, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate button width as a percentage of the screen width
    double buttonWidth = screenWidth * 0.8; // Adjust the percentage as needed

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        padding: EdgeInsets.symmetric(vertical: 12), // Adjust padding here
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
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
