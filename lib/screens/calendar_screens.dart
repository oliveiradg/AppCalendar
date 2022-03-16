// ignore_for_file: must_call_super

import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:teste_calendario/models/event_model.dart';
import 'package:teste_calendario/utils/faker_api.dart';

var now = DateTime.now();
var firstDay = DateTime(now.year, now.month - 3, now.day);
var lastDay = DateTime(now.year, now.month + 3, now.day);
CalendarFormat format = CalendarFormat.month;

bool load = false;
List<AppEvent> events = [];

var focusedDay = DateTime.now();
var selectedDay = DateTime.now();

LinkedHashMap<DateTime, List<AppEvent>>? _groupedEvents;

// ignore: camel_case_types
class calendarScreen extends StatefulWidget {
  const calendarScreen({Key? key}) : super(key: key);

  @override
  State<calendarScreen> createState() => _calendarScreenState();
}

// ignore: camel_case_types
class _calendarScreenState extends State<calendarScreen> {
  @override
  void initState() {
    addSchedules();
  }

  List<dynamic> _getEventsForDay(DateTime date) {
    return _groupedEvents?[date] ?? [];
  }

  Future addSchedules() async {
    await FakerApi.getData().then((schedules) {
      for (var i = 0; i < schedules.length; i++) {
        events.add(AppEvent(
            date: DateTime.parse(schedules[i].birthday),
            title: schedules[i].firstname));
      }

      setState(() {
        load = true;
      });
    });

    _groupEvents(events);
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10002 + key.year;
  }

  _groupEvents(List<AppEvent> events) {
    _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);

    for (var event in events) {
      DateTime date = DateTime.utc(
          event.date!.year, event.date!.month, event.date!.day, 12);
      if (_groupedEvents![date] == null) _groupedEvents![date] = [];
      _groupedEvents![date]!.add(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          eventLoader: _getEventsForDay,
          onDaySelected: (newselectedDay, newfocusedDay) {
            setState(() {
              selectedDay = newselectedDay;
              focusedDay = newfocusedDay;
            });
          },
          selectedDayPredicate: (day) => isSameDay(day, selectedDay),
          //esta função permite selecionar o dia

          onFormatChanged: (CalendarFormat _format) {
            setState(() {
              var format = _format;
            });
          },

          focusedDay: now,
          firstDay: firstDay,
          lastDay: lastDay,
          calendarFormat: format,
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableCalendarFormats: const {
            CalendarFormat.month: 'mês',
            CalendarFormat.week: 'semana',
            CalendarFormat.twoWeeks: '2 semanas',
          },
          headerStyle: HeaderStyle(
            leftChevronIcon:
                const Icon(Icons.chevron_left, size: 24, color: Colors.black54),
            rightChevronIcon: const Icon(Icons.chevron_right,
                size: 24, color: Colors.black54),
            headerPadding: EdgeInsets.zero,
            formatButtonVisible: true,
            formatButtonShowsNext: true,
            formatButtonDecoration: BoxDecoration(
              color: Colors.blueGrey,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
            ),
            formatButtonTextStyle:
                const TextStyle(color: Colors.white, fontSize: 12),
            titleTextStyle: const TextStyle(
              color: (Color.fromARGB(1, 59, 60, 90)),
            ),
            titleCentered: true,
          ),

          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(
              color: Colors.blueGrey,
              shape: BoxShape.circle,
            ),
            selectedTextStyle:
                const TextStyle(color: Color.fromRGBO(238, 230, 226, 1)),
            todayDecoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(color: Colors.blueGrey),
            defaultDecoration: const BoxDecoration(
                color: Colors.transparent, shape: BoxShape.circle),
            defaultTextStyle: const TextStyle(color: Colors.blueGrey),
            weekendDecoration: const BoxDecoration(
                color: Colors.transparent, shape: BoxShape.circle),
            weekendTextStyle: const TextStyle(
              color: Colors.red,
            ),
          ),

          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              String text;
              if (day.weekday == DateTime.sunday) {
                text = 'Dom';
              } else if (day.weekday == DateTime.monday) {
                text = 'Seg';
              } else if (day.weekday == DateTime.tuesday) {
                text = 'Ter';
              } else if (day.weekday == DateTime.wednesday) {
                text = 'Qua';
              } else if (day.weekday == DateTime.thursday) {
                text = 'Qui';
              } else if (day.weekday == DateTime.friday) {
                text = 'Sex';
              } else if (day.weekday == DateTime.saturday) {
                text = 'Sáb';
              } else {
                text = 'error';
              }
              return Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              );
            },

            //IMPLEMENTAÇÃO ANIVERSÁRIO E QUANTIDADES DE EVETENTOS NO DIA

            /*  markerBuilder: (context, day, events) {
            if (events.isNotEmpty) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                      bottom: 2.0,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ))
                ],
              );
            } else {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                      bottom: 2.0,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                            color: Colors.brown,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ))
                ],
              );
            
          }}*/
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
            child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 40 / 9,
                children: [
              ..._getEventsForDay(selectedDay).map((event) => Card(
                    color: Colors.white10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        event.title.toString(),
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ))
            ])),
      ],
    );
  }
}
