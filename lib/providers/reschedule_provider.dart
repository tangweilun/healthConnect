import 'package:flutter_riverpod/flutter_riverpod.dart';

final rescheduleProvider = StateProvider<bool>((ref) => false);

final appointmentIDProvider = StateProvider<String>((ref) => '');
