// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:health_connect/components/my_button.dart';
import 'package:health_connect/components/my_textfield.dart';
import 'package:health_connect/pages/patient/forgot_password_page.dart';

import 'package:health_connect/theme/colors.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool isEmailFieldEmpty = true; // Initially, consider the field as empty
  bool isPasswordFieldEmpty = true; // Initially, consider the field as empty
  void signUserIn() async {
    // Check if the widget is still mounted
    if (!mounted) return;
    //show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Check if the widget is still mounted before updating the UI

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Check if the widget is still mounted before updating the UI

      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        showErrorMessage("Wrong Email"); // Pass the context here
      } else if (e.code == 'wrong-password') {
        showErrorMessage("Wrong Password"); // Pass the context here
      } else {
        showErrorMessage('please enter valid email');
      }
    }
  }

  void showErrorMessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(errorMessage),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                SizedBox(
                    height: 200,
                    width: 200,
                    child: Lottie.asset('assets/doctor_animation.json')),

                Text('Welcome back ',
                    style: GoogleFonts.roboto(
                        color: mediumBlueGrayColor, fontSize: 24)),
                SizedBox(
                  height: screenHeight * 0.03,
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
                    });
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                //textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  onChanged: (String newText) {
                    setState(() {
                      // Check if the text field is empty and update the boolean variable accordingly
                      isPasswordFieldEmpty = newText.isEmpty;
                    });
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // navigate to forgot password
                          // Navigate to forgot password screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage()),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: mediumBlueGrayColor, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                //sign in button
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                MyButton(
                  disable: emailController.text.isEmpty ||
                      passwordController.text.isEmpty,
                  width: screenWidth * 0.5,
                  text: "Sign In",
                  onTap: signUserIn,
                ),
                //or continue with
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                //google button
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SquareTile(
                //         onTap: () => AuthService().signInWithGoogle(),
                //         imagePath: 'assets/images/google_logo.png'),
                //     SizedBox(
                //       width: screenWidth * 0.05,
                //     ),
                //   ],
                // ),
                SizedBox(height: screenHeight * 0.02),
                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(
                      width: screenHeight * 0.01,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
