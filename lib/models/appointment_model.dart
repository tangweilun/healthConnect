class Appointment {
  final String id;
  final String patientId;
  final String therapistId;
  final DateTime date;
  final bool isBooked;

  Appointment({
    required this.id,
    required this.patientId,
    required this.therapistId,
    required this.date,
    this.isBooked = false,
  });

  // Convert the Appointment object to a Map (JSON-like structure)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'therapistId': therapistId,
      'date': date.toIso8601String(), // Convert DateTime to ISO 8601 format
      'isBooked': isBooked,
    };
  }

  // Create an Appointment object from a Map
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patientId'],
      therapistId: json['therapistId'],
      date: DateTime.parse(json['date']), // Parse ISO 8601 string to DateTime
      isBooked: json['isBooked'],
    );
  }
}
