import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_connect/components/patient/my_button.dart';
import 'package:health_connect/components/patient/my_textfield.dart';
import 'package:health_connect/id_generator.dart';
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
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  DateTime dateOfBirth = DateTime(1900);
  bool isEmailFieldEmpty = true; // Initially, consider the field as empty
  bool isPasswordFieldEmpty = true; // Initially, consider the field as empty
  bool isconfirmFieldEmpty = true; // Initially, consider the field as empty
  bool isFullNameFieldEmpty = true; // Initially, consider the field as empty
  bool isDateOfBirthFieldEmpty = true; // Initially, consider the field as empty
  bool isPhoneNumberFieldEmpty = true; // Initially, consider the field as empty
  final CollectionReference patient =
      FirebaseFirestore.instance.collection('patient');
  final IDGenerator idGenerator = IDGenerator();

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

        // // Get the user's unique ID after registration
        String patientID = await idGenerator.generateId("patient");
        // // Add patient information to Firestore database
        final docPatient =
            FirebaseFirestore.instance.collection('patient').doc(patientID);
        final jsonPatient = {
          'email': emailController.text,
          'blood_type': '',
          'date_of_birth': dateOfBirth,
          'gender': _isMale ? 'Male' : 'Female',
          'name': fullNameController.text,
          'phone_number': phoneNumberController.text,
          'patient_id': patientID,
        };
        await docPatient.set(jsonPatient);

        final docUser = FirebaseFirestore.instance.collection('Users').doc();
        final jsonUser = {
          'Email': emailController.text,
          'UserRole': 'Patient',
        };

        await docUser.set(jsonUser);
      } else {
        showErrorMessage("password not match!");
      }

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
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

  bool _isMale = true;
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
                  height: screenHeight * 0.03,
                ),
                //logo
                Image.asset(
                  'assets/images/bpm_helthcare.jpg',
                  height: screenWidth / 6,
                  width: screenHeight / 6,
                ),
                //welcome back
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Text(
                  'Let\'s create an account for you!',
                  style: GoogleFonts.roboto(
                      color: AppColors.darkNavyBlue, fontSize: 16),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),

                //username
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                MyTextField(
                  controller: fullNameController,
                  hintText: 'Full Name',
                  obscureText: false,
                  onChanged: (String newText) {
                    setState(() {
                      // Check if the text field is empty and update the boolean variable accordingly
                      isFullNameFieldEmpty = newText.isEmpty;
                    });
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                //textfield
                // MyTextField(
                //   controller: dateOfBirthController,
                //   hintText: 'Date Of Birth',
                //   obscureText: false,
                //   onChanged: (String newText) {
                //     setState(() {
                //       // Check if the text field is empty and update the boolean variable accordingly
                //       isDateOfBirthFieldEmpty = newText.isEmpty;
                //     });
                //   },
                // ),
                DatePickerWidget(
                  onDateSelected: (DateTime date) {
                    print('Selected date: $date');
                    dateOfBirth = date;
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Radio(
                        value: true,
                        groupValue: _isMale,
                        onChanged: (value) {
                          setState(() {
                            _isMale = value!;
                          });
                        }),
                    const Text('Male'),
                    Radio(
                      value: false,
                      groupValue: _isMale,
                      onChanged: (value) {
                        setState(() {
                          _isMale = value!;
                        });
                      },
                    ),
                    const Text('Female'),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                MyTextField(
                  controller: phoneNumberController,
                  hintText: 'Phone Number',
                  obscureText: false,
                  onChanged: (String newText) {
                    setState(() {
                      // Check if the text field is empty and update the boolean variable accordingly
                      isPhoneNumberFieldEmpty = newText.isEmpty;
                    });
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                //
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
                //textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  onChanged: (String newText) {
                    setState(() {
                      // Check if the text field is empty and update the boolean variable accordingly
                      isconfirmFieldEmpty = newText.isEmpty;
                    });
                  },
                ),

                //sign in button
                SizedBox(
                  height: screenHeight * 0.02,
                ),

                MyButton(
                  disable: emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty ||
                      fullNameController.text.isEmpty ||
                      phoneNumberController.text.isEmpty,
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
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                    //   child: Text('Or Continue with'),
                    // ),
                    // Expanded(
                    //   child: Divider(
                    //     thickness: 0.5,
                    //     color: Colors.grey[400],
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
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
                // SizedBox(height: screenHeight * 0.01),
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
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime)? onDateSelected;

  const DatePickerWidget({Key? key, this.onDateSelected}) : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        if (widget.onDateSelected != null) {
          widget.onDateSelected!(selectedDate);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        _selectDate(context);
      },
      child: SizedBox(
        width: screenWidth * 0.76,
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Date of Birth',
            hintText: 'Select Date',
            border: OutlineInputBorder(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "${selectedDate.toLocal()}".split(' ')[0],
                style: const TextStyle(fontSize: 16),
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }
}
