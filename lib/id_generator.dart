import 'package:cloud_firestore/cloud_firestore.dart';

class IDGenerator {
  final CollectionReference _idGeneratorCollection =
  FirebaseFirestore.instance.collection('id_generator');

  Future<String> generateId(String userType) async {
    try {
      DocumentSnapshot idDocSnapshot =
      await _idGeneratorCollection.doc('IDs').get();

      if (!idDocSnapshot.exists) {
        throw IDGeneratorException('ID Document does not exist!');
      }

      Map<String, dynamic> data =
      idDocSnapshot.data() as Map<String, dynamic>;

      if (data == null ||
          !data.containsKey(userType) ||
          data[userType] is! int) {
        throw IDGeneratorException(
            'Invalid or missing data for user type: $userType');
      }

      int currentId = data[userType] as int;
      int nextId = currentId + 1;

      await _idGeneratorCollection.doc('IDs').update({userType: nextId});

      return '${_getIdPrefix(userType)}${nextId.toString().padLeft(3, '0')}';
    } catch (e) {
      print('Error generating ID: $e');
      throw IDGeneratorException('Error generating ID');
    }
  }

  String _getIdPrefix(String userType) {
    const Map<String, String> idPrefixes = {
      'doctor': 'D',
      'patient': 'P',
      'manager': 'M',
      'appointment': 'AP',
      'medical_record': 'MD',
      'department': 'DP',
    };

    return idPrefixes[userType] ?? '';
  }
}

class IDGeneratorException implements Exception {
  final String message;
  IDGeneratorException(this.message);
}
