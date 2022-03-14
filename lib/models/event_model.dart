import 'dart:convert';

class AppEvent {
  final String? title;
  final DateTime? date;

  AppEvent({
    this.title,
    this.date,
  });

  AppEvent copyWith({
    String? title,
    DateTime? date,
  }) {
    return AppEvent(title: title ?? this.title, date: date ?? this.date);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date!.millisecondsSinceEpoch,
    };
  }

  factory AppEvent.fromMap(Map<String, dynamic> map) {
    if (map == null) return null!;

    return AppEvent(
      title: map['title'],
      date: DateTime.fromMicrosecondsSinceEpoch(map['date']),
    );
  }
}
