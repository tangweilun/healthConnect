import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_connect/components/my_textfield.dart';
import 'package:health_connect/components/my_button.dart';
import 'package:health_connect/components/square_tile.dart';
import 'package:health_connect/services/auth_services.dart';
import 'package:health_connect/theme/colors.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({Key? key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserIn() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } else {
        showErrorMessage("password not match!");
      }
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      showErrorMessage(e.code);
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
                //logo
                Image.asset(
                  'assets/images/bpm_helthcare.jpg',
                  height: screenWidth / 6,
                  width: screenHeight / 6,
                ),
                //welcome back
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Text(
                  'Let\'s create an account for you!',
                  style: GoogleFonts.roboto(
                      color: darkNavyBlueColor, fontSize: 16),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                //username
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obsureText: false,
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                //textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obsureText: true,
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                //textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obsureText: true,
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),

                //sign in button
                SizedBox(
                  height: screenHeight * 0.03,
                ),

                MyButton(
                  disable: emailController.text.isEmpty &&
                          passwordController.text.isEmpty &&
                          confirmPasswordController.text.isEmpty
                      ? false
                      : true,
                  width: screenWidth * 0.5,
                  text: "Register",
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Or Continue with'),
                    ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'assets/images/google_logo.png'),
                    SizedBox(
                      width: screenWidth * 0.05,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(
                      width: screenHeight * 0.01,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
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
