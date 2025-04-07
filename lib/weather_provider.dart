import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../weather_model.dart';
import '../weather_service.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> _history = [];
  List<String> get history => _history;

  Future<void> fetchWeather(String city, {bool save = true}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await WeatherService.getWeather(city);
      if (!_history.contains(city)) {
        _history.insert(0, city);
        if (_history.length > 5) _history = _history.sublist(0, 5);
      }

      if (save) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('lastCity', city);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLastCityWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('lastCity');
    if (lastCity != null) {
      await fetchWeather(lastCity, save: false);
    }
  }
}
