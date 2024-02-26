import 'package:health_connect/models/patient/doctor_model.dart';
import 'package:riverpod/riverpod.dart';

final selectedDoctorProvider =
    StateNotifierProvider<DoctorModelNotifier, Doctor>((ref) {
  return DoctorModelNotifier(Doctor()); // Initialize your model here
});

class DoctorModelNotifier extends StateNotifier<Doctor> {
  DoctorModelNotifier(Doctor doctorModel) : super(doctorModel);

  // Method to update the model instance
  void updateDoctorModel(Doctor doctor) {
    state = doctor;
  }
}

// Define a provider for the list
final searchNameProvider = StateProvider<String>((ref) => '');

// Define a provider for the list
final isfilteredByDepartment = StateProvider<bool>((ref) => false);
