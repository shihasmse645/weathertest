import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather_response_model.dart';

class WeatherServiceProvider extends ChangeNotifier {
  WeatherModel? _weather;

  WeatherModel? get weather => _weather;

  bool _isloading = false;
  bool get isLoading => _isloading;

  String _error = "";
  String get error => _error;

  Future<void> fetchWeatherDataByCity(String lat, String lon) async {
    _isloading = true;
    _error = "";
    const apikey = "2e32d3ba66735f8f3f3aab1bdb675a40";

    try {
      final String apiUrl =
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apikey&units=metric";
      //print(apiUrl);
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        _weather = WeatherModel.fromJson(data);
        print(_weather!.main!.feelsLike);

        notifyListeners();
      } else {
        _error = "Failed to load data";
      }
    } catch (e) {
      _error = "Failed to load data $e";
    } finally {
      _isloading = false;
    }
  }
}
