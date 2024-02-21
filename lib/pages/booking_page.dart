import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:health_connect/components/my_button.dart';
import 'package:health_connect/pages/custom_appbar.dart';
import 'package:health_connect/theme/colors.dart';
import 'package:table_calendar/table_calendar.dart';

final bookingStateProvider =
    StateNotifierProvider<BookingStateNotifier, BookingState>((ref) {
  return BookingStateNotifier();
});

class BookingState {
  CalendarFormat format;
  DateTime focusDay;
  DateTime currentDay;
  int? currentIndex;
  bool isWeekend;
  bool dateSelected;
  bool timeSelected;

  BookingState({
    required this.format,
    required this.focusDay,
    required this.currentDay,
    this.currentIndex,
    this.isWeekend = false,
    this.dateSelected = false,
    this.timeSelected = false,
  });

  BookingState copyWith({
    CalendarFormat? format,
    DateTime? focusDay,
    DateTime? currentDay,
    int? currentIndex,
    bool? isWeekend,
    bool? dateSelected,
    bool? timeSelected,
  }) {
    return BookingState(
      format: format ?? this.format,
      focusDay: focusDay ?? this.focusDay,
      currentDay: currentDay ?? this.currentDay,
      currentIndex: currentIndex ?? this.currentIndex,
      isWeekend: isWeekend ?? this.isWeekend,
      dateSelected: dateSelected ?? this.dateSelected,
      timeSelected: timeSelected ?? this.timeSelected,
    );
  }
}

class BookingStateNotifier extends StateNotifier<BookingState> {
  BookingStateNotifier()
      : super(BookingState(
          format: CalendarFormat.month,
          focusDay: DateTime.now(),
          currentDay: DateTime.now(),
        ));

  void updateState({
    CalendarFormat? format,
    DateTime? focusDay,
    DateTime? currentDay,
    int? currentIndex,
    bool? isWeekend,
    bool? dateSelected,
    bool? timeSelected,
  }) {
    state = state.copyWith(
      format: format ?? state.format,
      focusDay: focusDay ?? state.focusDay,
      currentDay: currentDay ?? state.currentDay,
      currentIndex: currentIndex,
      isWeekend: isWeekend ?? state.isWeekend,
      dateSelected: dateSelected ?? state.dateSelected,
      timeSelected: timeSelected ?? state.timeSelected,
    );
  }
}

class BookingPage extends ConsumerWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingStateProvider);

    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Appointment',
        icon: const Icon(Icons.arrow_back_ios),
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(children: <Widget>[
            //display table calendar here
            _tableCalendar(ref),
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
        state.isWeekend
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
                        ref.read(bookingStateProvider.notifier).updateState(
                              currentIndex: index,
                              timeSelected: true,
                            );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: state.currentIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          color: state.currentIndex == index
                              ? mediumBlueGrayColor
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: state.currentIndex == index
                                ? Colors.white
                                : null,
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
            child: MyButton(
              width: double.infinity,
              disable: state.timeSelected && state.dateSelected ? false : true,
              onTap: () {
                //navigate to the appointment booked page
                GoRouter.of(context)
                    .go('/doctordetail/appointmentbooking/successbooked');
              },
              text: 'Make Appointment',
            ),
          ),
        )
      ]),
    );
  }

  Widget _tableCalendar(WidgetRef ref) {
    final state = ref.watch(bookingStateProvider);

    return TableCalendar(
      focusedDay: state.focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2024, 12, 31),
      calendarFormat: state.format,
      currentDay: state.currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
              color: mediumBlueGrayColor, shape: BoxShape.circle)),
      availableCalendarFormats: const {
        CalendarFormat.month: "Month",
      },
      onFormatChanged: (format) {
        ref.read(bookingStateProvider.notifier).updateState(format: format);
      },
      onDaySelected: (selectedDay, focusedDay) {
        ref.read(bookingStateProvider.notifier).updateState(
              currentDay: selectedDay,
              focusDay: focusedDay,
              dateSelected: true,
              isWeekend: selectedDay.weekday == 6 || selectedDay.weekday == 7,
              timeSelected: false,
              currentIndex: null,
            );
      },
    );
  }
}
