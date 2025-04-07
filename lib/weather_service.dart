import 'dart:convert';
import 'package:http/http.dart' as http;
import '../weather_model.dart';

class WeatherService {
  static const String _apiKey =
      '39b93c8c1a962743d616d8a0264b0e43'; 

  static Future<Weather> getWeather(String city) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('City not found');
    }
  }
}
