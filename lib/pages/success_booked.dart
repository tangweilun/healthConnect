import 'package:flutter/material.dart';
import 'package:health_connect/components/my_button.dart';
import 'package:lottie/lottie.dart';

class AppointmentBooked extends StatelessWidget {
  const AppointmentBooked({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Lottie.asset('assets/success_animation.json')),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Succeccfully Booked',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: MyButton(
                width: double.infinity,
                text: 'Back to HomePage',
                onTap: () {},
                disable: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
