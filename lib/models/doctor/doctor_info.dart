class Doctor {
  final String name;
  final String doctorID;
  final String specialty;
  final int age;
  final String email;
  final String phoneNumber;
  final String gender;
  final int numberOfPreviousPatients;
  final String photoUrl;

  Doctor({
    required this.name,
    required this.doctorID,
    required this.specialty,
    required this.age,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.numberOfPreviousPatients,
    this.photoUrl = '', // Provide a default value for photoUrl
  });
}
