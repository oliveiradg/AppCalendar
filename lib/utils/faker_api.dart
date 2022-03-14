import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:teste_calendario/models/api_model.dart';

class FakerApi {
  static Future<List<Data>> getData() async {
    String url = '';
    url =
        'https://fakerapi.it/api/v1/persons?_quantity=500&_birthday_start=2021-01-25&_birthday_end=2022-12-31';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Data> list = parseSchedules(response.body);
        return list;
      } else {
        throw Exception('ERROR');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Data> parseSchedules(String responseBody) {
    final parsed = json.decode(responseBody);
    return parsed["data"].map<Data>((json) => Data.fromJson(json)).toList();
  }
}
