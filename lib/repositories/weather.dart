import 'package:flutter_code_challenge/constants.dart';
import 'package:flutter_code_challenge/models/coordinates.dart';
import 'package:weather/weather.dart';

class WeatherRepository {
  static Future<Weather> getWeather(Coordinates coordinates) {
    final WeatherFactory weatherFactory = WeatherFactory(Constants.OWM_API_KEY);

    return weatherFactory.currentWeatherByLocation(
      coordinates.latitude,
      coordinates.longitude,
    );
  }
}
