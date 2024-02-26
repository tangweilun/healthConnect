import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_connect/pages/patient/forgot_password_page.dart';
import 'package:health_connect/pages/patient/login_page.dart';
import 'package:health_connect/pages/patient/medical_record_dialog.dart';
import 'package:health_connect/pages/patient/profile_page.dart';
import 'package:health_connect/pages/patient/viewappointment_page.dart';
import 'package:health_connect/pages/patient/booking_page.dart';
import 'package:health_connect/pages/patient/doctor_detail_page.dart';
import 'package:health_connect/pages/patient/home_page.dart';
import 'package:health_connect/pages/patient/success_booked.dart';
import 'package:health_connect/theme/colors.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class NavigationRoute extends StatelessWidget {
  NavigationRoute({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/homepage',
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      /// Application shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/homepage',
            builder: (BuildContext context, GoRouterState state) {
              return HomePage();
            },
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover screen A but not the application shell.
              GoRoute(
                path: 'details',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePage();
                },
              ),
            ],
          ),

          /// The first screen to display in the bottom navigation bar.
          GoRoute(
            path: '/viewappointment',
            builder: (BuildContext context, GoRouterState state) {
              return const AppointmentPage();
            },
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover screen A but not the application shell.
              GoRoute(
                path: 'details',
                builder: (BuildContext context, GoRouterState state) {
                  return const AppointmentPage();
                },
              ),
            ],
          ),

          GoRoute(
            path: '/loginpage',
            builder: (BuildContext context, GoRouterState state) {
              return const LoginPage();
            },
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover screen A but not the application shell.
              GoRoute(
                path: 'forgotpasswordpage',
                builder: (BuildContext context, GoRouterState state) {
                  return const ForgotPasswordPage();
                },
              ),
            ],
          ),

          GoRoute(
            path: '/doctordetail',
            builder: (BuildContext context, GoRouterState state) {
              return const DoctorDetails();
            },
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover screen A but not the application shell.
              GoRoute(
                path: 'appointmentbooking',
                builder: (BuildContext context, GoRouterState state) {
                  return BookingPage();
                },
                routes: <RouteBase>[
                  /// Same as "/a/details", but displayed on the root Navigator by
                  /// specifying [parentNavigatorKey]. This will cover both screen B
                  /// and the application shell.
                  GoRoute(
                    path: 'successbooked',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      return const AppointmentBooked();
                    },
                  ),
                ],
              ),
            ],
          ),

          /// Displayed when the second item in the the bottom navigation bar is
          /// selected.
          GoRoute(
            path: '/medicalrecord',
            builder: (BuildContext context, GoRouterState state) {
              return const PatientDetailsPage();
            },
            routes: <RouteBase>[
              /// Same as "/a/details", but displayed on the root Navigator by
              /// specifying [parentNavigatorKey]. This will cover both screen B
              /// and the application shell.
              GoRoute(
                path: 'details',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (BuildContext context, GoRouterState state) {
                  return HomePage();
                },
              ),
            ],
          ),

          /// The third screen to display in the bottom navigation bar.
          GoRoute(
            path: '/profilepage',
            builder: (BuildContext context, GoRouterState state) {
              return ProfilePage();
            },
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover screen A but not the application shell.
              GoRoute(
                path: 'details',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePage();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  /// The widget to display in the body of the Scaffold.
  /// In this sample, it is a Navigator.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 4,
        selectedIconTheme:
            const IconThemeData(color: AppColors.mediumBlueGrayColor),
        selectedItemColor:
            AppColors.mediumBlueGrayColor, // Change selected item color
        unselectedItemColor: Colors.black, // Change unselected item color
        selectedLabelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold), // Change selected label style
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HomePage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information),
            label: 'View Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_outlined),
            label: 'Medical Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/homepage')) {
      return 0;
    }
    if (location.startsWith('/viewappointment')) {
      return 1;
    }
    if (location.startsWith('/medicalrecord')) {
      return 2;
    }
    if (location.startsWith('/profilepage')) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/homepage');
      case 1:
        GoRouter.of(context).go('/viewappointment');
      case 2:
        GoRouter.of(context).go('/medicalrecord');
      case 3:
        GoRouter.of(context).go('/profilepage');
    }
  }
}
