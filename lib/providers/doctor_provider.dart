import 'package:health_connect/models/doctor_model.dart';
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
