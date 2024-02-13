import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_connect/components/my_textfield.dart';
import 'package:health_connect/components/my_button.dart';
import 'package:health_connect/components/square_tile.dart';
import 'package:health_connect/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({Key? key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        showErrorMessage("Wrong Email"); // Pass the context here
      } else if (e.code == 'wrong-password') {
        showErrorMessage("Wrong Password"); // Pass the context here
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
      backgroundColor: Colors.grey[300],
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
                Icon(
                  Icons.lock,
                  size: screenHeight * 0.2,
                ),
                //welcome back
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Text(
                  'Welcome back ',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
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
                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                //sign in button
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                MyButton(
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
