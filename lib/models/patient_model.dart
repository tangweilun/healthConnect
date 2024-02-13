class Patient {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final List<String> conditions;
  final List<String> medications;
  final List<String> allergies;
  final List<String> surgeries;

  Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.conditions,
    required this.medications,
    required this.allergies,
    required this.surgeries,
  });
}
