class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime date;
  final String status;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.status,
  });

  // Convert the Appointment object to a Map (JSON-like structure)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'date': date.toIso8601String(), // Convert DateTime to ISO 8601 format
      'status': status,
    };
  }

  // Create an Appointment object from a Map
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      date: DateTime.parse(json['date']), // Parse ISO 8601 string to DateTime
      status: json['status'],
    );
  }
}
