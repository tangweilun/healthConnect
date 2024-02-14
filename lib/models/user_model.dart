import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id; // Unique identifier for the user
  final String email; // User's email address (used for authentication)
  final String role; // Role of the user (e.g., "patient," "doctor," "admin")
  final String fullName; // Full name of the user

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.fullName,
  });

  // Convert User object to a Map (JSON-like structure) for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'fullName': fullName,
    };
  }

  // Create a User object from a Firestore document snapshot
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      email: data['email'],
      role: data['role'],
      fullName: data['fullName'],
    );
  }
}
