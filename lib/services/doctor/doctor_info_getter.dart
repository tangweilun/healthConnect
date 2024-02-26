import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DoctorInfo {
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('doctor')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        final age = _calculateAge((userData['date_of_birth'] as Timestamp).toDate());
        userData['age'] = age;
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving user information: $e');
      return null;
    }
  }

  int _calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  Future<void> uploadPhoto(File file, String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
    } catch (e) {
      print('Error uploading photo: $e');
      rethrow;
    }
  }

  Future<void> updateDoctorInfo(String id, {String? phoneNumber, String? photoUrl}) async {
    try {
      final dataToUpdate = <String, dynamic>{};
      if (phoneNumber != null) {
        dataToUpdate['phone_number'] = phoneNumber;
      }
      if (photoUrl != null) {
        dataToUpdate['photo'] = photoUrl;
      }
      await FirebaseFirestore.instance.collection('doctor').doc(id).update(dataToUpdate);
    } catch (e) {
      print('Error updating doctor info: $e');
      rethrow;
    }
  }

  Future<void> changePassword(String doctorEmail, String currentPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(email: doctorEmail, password: currentPassword);
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      } else {
        throw Exception('User not found');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception("Current password is incorrect");
      } else {
        throw Exception("Failed to change password: $e");
      }
    } catch (e) {
      throw Exception("Failed to change password: $e");
    }
  }
}
