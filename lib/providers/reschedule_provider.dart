import 'package:flutter_riverpod/flutter_riverpod.dart';

final rescheduleProvider = StateProvider<bool>((ref) => false);

final appointmentIDProvider = StateProvider<String>((ref) => '');

// final tokenProvider = StateProvider<String>((ref) => '');

final doctorIdProvider = StateProvider<String>((ref) => '');
