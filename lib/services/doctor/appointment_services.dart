import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DoctorAppointmentService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initializeFirebaseMessaging() {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened when app is in foreground: ${message.notification?.title}');
    });
  }

  void scheduleAppointmentNotifications() {
    FirebaseFirestore.instance
        .collection('appointment')
        .orderBy('date')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      for (QueryDocumentSnapshot appointment in snapshot.docs) {
        DateTime appointmentDate =
        (appointment['date'] as Timestamp).toDate();
        DateTime currentDate = DateTime.now();
        int timeDifferenceInMinutes =
            appointmentDate.difference(currentDate).inMinutes;

        if (timeDifferenceInMinutes <= 60) {
          String doctorID = appointment['doctorID'];

          FirebaseFirestore.instance
              .collection('doctor')
              .where('doctor_id', isEqualTo: doctorID)
              .get()
              .then((QuerySnapshot doctorSnapshot) {
            if (doctorSnapshot.size > 0) {
              String doctorEmail = doctorSnapshot.docs.first['email'];

              _sendNotification(doctorEmail, 'Appointment Reminder',
                  'Your appointment is in 1 hour.');
            }
          });
        }
      }
    });
  }

  void _sendNotification(String recipient, String title, String body) {
    // Logic to send push notification using recipient's email
    // You can use a service like Firebase Cloud Messaging (FCM) to send notifications
    // Example: https://firebase.flutter.dev/docs/messaging/usage#send-messages
  }
}
