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

  Future<void> addUserToFirestore(User user) async {
    // Reference to Firestore collection (you may need to change 'users' to your collection name)
    CollectionReference users =
        FirebaseFirestore.instance.collection('patient');

    // Check if user already exists in Firestore
    DocumentSnapshot docSnapshot = await users.doc(user.uid).get();
    if (!docSnapshot.exists) {
      // Add user to Firestore if not already present
      await users.doc(user.uid).set({
        // 'displayName': user.displayName ?? '', //// Add display name if available
        'email': user.email,
      });
    }
  }

  Future<String?> getPatientID() async {
    try {
      // Get the currently logged-in user
      User? user = FirebaseAuth.instance.currentUser;

      // If the user is logged in
      if (user != null) {
        // Get a reference to the user's document in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('patient')
            .doc(user.uid)
            .get();

        // Check if the document exists
        if (userDoc.exists) {
          // Extract the patientID from the document ID or a specific field
          String patientId = userDoc.id;
          return patientId;
        } else {
          // Handle case where user document does not exist
          print('Handle case where user document does not exist');
          return null;
        }
      } else {
        // Handle case where no user is logged in
        print(' Handle case where no user is logged in');
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error getting patient ID: $e');
      return null;
    }
  }
}
