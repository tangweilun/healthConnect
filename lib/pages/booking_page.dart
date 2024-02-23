import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_connect/components/my_button.dart';
import 'package:health_connect/models/appointment_model.dart';

import 'package:health_connect/pages/custom_appbar.dart';
import 'package:health_connect/providers/doctor_provider.dart';
import 'package:health_connect/providers/reschedule_provider.dart';
import 'package:health_connect/services/auth_services.dart';
import 'package:health_connect/theme/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

DateTime selectedDateTime = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();

TimeOfDay handleTimeSlotSelection(int selectedIndex) {
  // Map the index to the corresponding time slot
  selectedTime = timeSlots[selectedIndex];
  return timeSlots[selectedIndex];
}

List<TimeOfDay> timeSlots = [
  const TimeOfDay(hour: 9, minute: 0), // 9:00 AM
  const TimeOfDay(hour: 10, minute: 0), // 10:00 AM
  const TimeOfDay(hour: 11, minute: 0), // 11:00 AM
  const TimeOfDay(hour: 12, minute: 0),
  const TimeOfDay(hour: 13, minute: 0),
  const TimeOfDay(hour: 14, minute: 0),
  const TimeOfDay(hour: 15, minute: 0),
  const TimeOfDay(hour: 16, minute: 0),
];
DateTime combineDateTimeAndTimeOfDay() {
  return DateTime(
    selectedDateTime.year,
    selectedDateTime.month,
    selectedDateTime.day,
    selectedTime.hour,
    selectedTime.minute,
  );
}

class MyConsumerWidget extends ConsumerWidget {
  final bool timeSelected;
  final bool dateSelected;
  final String patientID;
  MyConsumerWidget({
    Key? key,
    required this.dateSelected,
    required this.timeSelected,
    required this.patientID,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Retrieve the values of _timeSelected and _dateSelected from the provider
    final selectedDoctor = ref.watch(selectedDoctorProvider);
    final isReschedule = ref.watch(rescheduleProvider);
    final appointmentID = ref.watch(appointmentIDProvider);
    // You need to define _dateSelected somewhere or replace it with the appropriate provider
    return MyButton(
      width: double.infinity,
      disable: timeSelected && dateSelected ? false : true,
      onTap: () {
        final appointment = Appointment(
            patientID: patientID,
            doctorID: selectedDoctor.id,
            //  doctorID: selectedDoctor.id,
            date: combineDateTimeAndTimeOfDay(),
            status: 'pending',
            category: selectedDoctor.category,
            doctorName: selectedDoctor.name,
            image: selectedDoctor.image,
            patientName: 'patientName');

        if (isReschedule) {
          rescheduleAppointment(appointmentID, combineDateTimeAndTimeOfDay());
        } else {
          createAppointment(appointment);
        }
        //navigato to the appointment booked page
        GoRouter.of(context)
            .go('/doctordetail/appointmentbooking/successbooked');
      },
      text: 'Make Appointment',
    );
  }
}

Future createAppointment(Appointment appointment) async {
  final docAppointment =
      FirebaseFirestore.instance.collection('appointment').doc();
  appointment.id = docAppointment.id;

  final json = appointment.toJson();
  await docAppointment.set(json);
}

Future rescheduleAppointment(
    String appointmentID, DateTime newSelectedDateTime) async {
  final docAppointment =
      FirebaseFirestore.instance.collection('appointment').doc(appointmentID);

  docAppointment.update({
    'date': newSelectedDateTime,
    'status': 'pending',
  });
}

class BookingPage extends StatefulWidget {
  BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final AuthService _authService =
      AuthService(); // Create an instance of AuthService
  String patientID = ''; // Variable to hold the patient ID

  @override
  void initState() {
    super.initState();
    _getPatientID(); // Call the method to retrieve the patient ID when the screen initializes
  }

  Future<void> _getPatientID() async {
    String? id =
        await _authService.getPatientID(); // Call the method from AuthService
    setState(() {
      patientID =
          id ?? ''; // Update the state variable with the retrieved patient ID
    });
  }

  //declaration
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentindex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appTitle: 'Appointment',
        icon: Icon(Icons.arrow_back_ios),
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(children: <Widget>[
            //display table calendar here
            _tableCalendar(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              child: Center(
                child: Text(
                  'Select Consultation Time',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ]),
        ),
        _isWeekend
            ? SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  alignment: Alignment.center,
                  child: const Text(
                    'Weekend is not available, please select another date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            : SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          //when selected, update current index and st time selected to true
                          _currentindex = index;
                          handleTimeSlotSelection(index);

                          _timeSelected = true;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _currentindex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          color: _currentindex == index
                              ? mediumBlueGrayColor
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _currentindex == index ? Colors.white : null,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: 8,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 1.5),
              ),
        SliverToBoxAdapter(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: MyConsumerWidget(
                patientID: patientID,
                timeSelected: _timeSelected,
                dateSelected: _dateSelected,
              )

              // print(selectedDoctor);
              // print(selectedDoctor.category);

              // final appointment = Appointment(
              //     patientID: patientID,
              //     doctorID: selectedDoctor.id,
              //     //  doctorID: selectedDoctor.id,
              //     date: combineDateTimeAndTimeOfDay(),
              //     status: 'upcoming',
              //     category: selectedDoctor.category,
              //     doctorName: selectedDoctor.name,
              //     image:
              //         'https://firebasestorage.googleapis.com/v0/b/healthconnect-ad0f1.appspot.com/o/doctor_4.jpg?alt=media&token=730f6dad-af44-4128-9d57-97ac503c21e5',
              //     patientName: 'patientName');
              // print('before createAppointment function');
              // //navigato to the appointment booked page
              // createAppointment(appointment);
              // print("after createAppointment function");
              // GoRouter.of(context)
              //     .go('/doctordetail/appointmentbooking/successbooked');
              ),
        ),
      ]),
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2024, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
              color: mediumBlueGrayColor, shape: BoxShape.circle)),
      availableCalendarFormats: const {
        CalendarFormat.month: "Month",
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;
          selectedDateTime = selectedDay;
          //check if weekend is selected
          if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
            _isWeekend = true;
            _timeSelected = false;
            _currentindex = null;
          } else {
            _isWeekend = false;
          }
        });
      },
    );
  }
}
