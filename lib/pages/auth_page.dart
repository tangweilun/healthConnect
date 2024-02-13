import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_connect/navigation_route.dart';
import 'package:health_connect/pages/loginOrRegister_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return NavigationRoute();
          } else {
            return const LoginOrRegisterPage();
          }
        }),
      ),
    );
  }
}
