import 'package:flutter/material.dart';
import 'package:teste_calendario/screens/calendar_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppTeste Calendário',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Calendário"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
        ),
        body: calendarScreen(),
        backgroundColor: Colors.white,
      ),
    );
  }
}
