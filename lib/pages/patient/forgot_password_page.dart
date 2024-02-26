import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:health_connect/components/my_textfield.dart';

import 'package:health_connect/pages/patient/login_page.dart';
import 'package:health_connect/theme/colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Password reset link sent! Check you email'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  bool isEmailFieldEmpty = true;
  bool disable = true;
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: mediumBlueGrayColor,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 16,
              color: Colors.white,
              onPressed: () {
                //if route is given , then this icon button will navigate to
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            )),
        title: const Text(
          "Reset Password",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter your email to get a password link',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),

                //email
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  onChanged: (String newText) {
                    setState(() {
                      // Check if the text field is empty and update the boolean variable accordingly
                      isEmailFieldEmpty = newText.isEmpty;
                      disable = false;
                    });
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                GestureDetector(
                  onTap: disable
                      ? null
                      : () {
                          passwordReset();
                        },
                  child: Container(
                    width: screenWidth * 0.8,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12), // Adjust padding here
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: disable ? Colors.grey : mediumBlueGrayColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14, // Adjust font size here
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
