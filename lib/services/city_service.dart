import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weagus/models/city.dart';

class CityService {
  Future getCityByName(String name) async {
    try {
      var request = await http.get(Uri.parse(
          'http://api.weatherapi.com/v1/search.json?key=fb300dacca6d454a9be190729211909&q=$name'));

      var result = await jsonDecode(request.body);

      final List<dynamic> citiesList = result;
      return citiesList.map((city) => City.fromJson(city)).toList();

    } catch (e) {
      print(e);
      return [];
    }
  }
}
