import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // //google sign in
  // signInWithGoogle() async {
  //   //begin interaction sign in process
  //   final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
  //   // obtain auth details from request
  //   final GoogleSignInAuthentication gAuth = await gUser!.authentication;

  //   //create a new credential for user
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: gAuth.accessToken,
  //     idToken: gAuth.idToken,
  //   );
  //   UserCredential userCredential =
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //   // Add user to Firestore
  //   await addUserToFirestore(userCredential.user!);

  //   // finally, leys sign in
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  // Future<void> addUserToFirestore(User user) async {
  //   // Reference to Firestore collection (you may need to change 'users' to your collection name)
  //   CollectionReference users =
  //       FirebaseFirestore.instance.collection('patient');

  //   // Check if user already exists in Firestore
  //   DocumentSnapshot docSnapshot = await users.doc(user.uid).get();
  //   if (!docSnapshot.exists) {
  //     // Add user to Firestore if not already present
  //     await users.doc(user.uid).set({
  //       // 'displayName': user.displayName ?? '', //// Add display name if available
  //       'email': user.email,
  //     });
  //   }
  // }

  Future<String?> getPatientID() async {
    try {
// Get the currently logged-in user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get the email of the currently logged-in user
        String? userEmail = user.email;

        if (userEmail != null) {
          // Query Firestore to find the document where the email matches the user's email
          QuerySnapshot userDocs = await FirebaseFirestore.instance
              .collection('patient')
              .where('email', isEqualTo: userEmail)
              .get();

          if (userDocs.docs.isNotEmpty) {
            // Retrieve the first document that matches the query
            DocumentSnapshot userDoc = userDocs.docs.first;

            // Get the value of the "patientID" field from the document
            String? patientID = userDoc['patient_id'];

            if (patientID != null) {
              // Now you have the patientID value
              return patientID;
            } else {
              // The "patientID" field is not available in the document
              print('Patient ID not found in the document.');
            }
          } else {
            // No user document found with the matching email
            print('No user document found with the matching email.');
          }
        } else {
          // User's email is not available
          print("User's email is not available.");
        }
      } else {
        // No user logged in
        print('No user logged in.');
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error getting patient ID: $e');
      return null;
    }
  }

  Future<String?> getPatientName() async {
    try {
// Get the currently logged-in user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get the email of the currently logged-in user
        String? userEmail = user.email;

        if (userEmail != null) {
          // Query Firestore to find the document where the email matches the user's email
          QuerySnapshot userDocs = await FirebaseFirestore.instance
              .collection('patient')
              .where('email', isEqualTo: userEmail)
              .get();

          if (userDocs.docs.isNotEmpty) {
            // Retrieve the first document that matches the query
            DocumentSnapshot userDoc = userDocs.docs.first;

            String? patientName = userDoc['name'];

            if (patientName != null) {
              return patientName;
            } else {
              // The "patientID" field is not available in the document
              print('Patient ID not found in the document.');
            }
          } else {
            // No user document found with the matching email
            print('No user document found with the matching email.');
          }
        } else {
          // User's email is not available
          print("User's email is not available.");
        }
      } else {
        // No user logged in
        print('No user logged in.');
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error getting patient ID: $e');
      return null;
    }
  }
}
