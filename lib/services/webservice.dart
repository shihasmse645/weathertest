import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather_response_model.dart';
class Webservice{
  //function to get weatherdata on current loction
//   Future<WeatherModel> fetchWeatherData(double latitude, double longitude) async {
//   const apiKey = '2e32d3ba66735f8f3f3aab1bdb675a40'; // Replace with your OpenWeatherMap API key
//   final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
//   final response = await http.get(Uri.parse(url));
//   if (response.statusCode == 200) {
//     final jsonData = json.decode(response.body);
//     return WeatherModel.fromJson(jsonData);
//   } else {
//     throw Exception('Failed to load weather data');
//   }
// }

  //function ti get weather data of searched location
  Future<WeatherModel> fetchWeatherDataByLocation(String location) async {
  const apiKey = '2e32d3ba66735f8f3f3aab1bdb675a40'; // Replace with your OpenWeatherMap API key
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return WeatherModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}