import 'package:cloud_firestore/cloud_firestore.dart';

class IDGenerator {
  // Reference to the 'id_generator' collection in Firestore
  final CollectionReference idGeneratorCollection =
  FirebaseFirestore.instance.collection('id_generator');

  // Function to generate a new ID for a given user type
  Future<String> generateId(String userType) async {
    try {
      // Get the 'IDs' document from the collection
      DocumentSnapshot idDocSnapshot =
      await idGeneratorCollection.doc('IDs').get();

      // Check if the document exists
      if (!idDocSnapshot.exists) {
        throw Exception('ID Document does not exist!');
      }

      // Extract the data from the document
      Map<String, dynamic> data = idDocSnapshot.data() as Map<String, dynamic>;

      // Check if data is null or userType is not present in the data
      if (data == null || !data.containsKey(userType) || data[userType] is! int) {
        throw Exception('Invalid or missing data for user type: $userType');
      }

      // Get the current ID count for the user type
      int currentId = data[userType] as int;

      // Calculate the next ID count
      int nextId = currentId + 1;

      // Update the document with the new ID count for the user type
      await idGeneratorCollection.doc('IDs').update({userType: nextId});

      // Generate the new ID string with the appropriate prefix and leading zeros
      String newId = '${_getIdPrefix(userType)}${nextId.toString().padLeft(3, '0')}';

      return newId; // Return the new ID
    } catch (e) {
      // Handle any exceptions that occur
      print('Error generating ID: $e');
      rethrow; // Rethrow the exception to be handled by the caller
    }
  }

  // Helper function to get the prefix for a given user type
  String _getIdPrefix(String userType) {
    const Map<String, String> idPrefixes = {
      'patient': 'P',
      'doctor': 'D',
      'manager': 'M',
    };

    // Return the prefix if it exists, or an empty string if not
    return idPrefixes[userType] ?? '';
  }
}
