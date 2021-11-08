import 'dart:convert';

import 'package:http/http.dart' as http;

import 'measure_units.dart';


class Weather {
  final double temperature;
  final DateTime date;
  final int windSpeed;
  final int pressure;
  final int humidity;
  final String weather;
  String iconId = '10d';

  Weather(this.temperature, this.date, this.windSpeed, this.pressure, this.humidity,
      this.weather, {String iconId = '10d'}) : iconId = iconId ;

  Weather.fromJson(json, {daily = true}) :
        temperature = (daily ? json['temp']['day'] : json['temp']).toDouble(),
        date = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true),
        windSpeed = json['wind_speed'].toInt(),
        pressure = json['pressure'],
        humidity = json['humidity'],
        weather = json['weather'][0]['description'],
        iconId = json['weather'][0]['icon'];

  @override
  String toString() {
    return '${getTemperature()}, ${getPressure()}, ${getHumidity()}, ${getWindSpeed()}, ${getWeather()}';
  }

  Weather.empty() :
        temperature = 0,
        date = DateTime.now(),
        windSpeed = 0,
        pressure = 0,
        humidity = 0,
        weather = 'unknown';

  String getTemperature({TemperatureUnits temperatureUnits = TemperatureUnits.Celsius}) {
    if (temperatureUnits == TemperatureUnits.Celsius) {
      return '${temperatureConvert(temperature, TemperatureUnits.Celsius).toStringAsFixed(1)} °C';
    } else if (temperatureUnits == TemperatureUnits.Fahrenheit) {
      return '${temperatureConvert(temperature, TemperatureUnits.Fahrenheit).toStringAsFixed(1)} °F';
    }
    return '${temperature.toString()}';
  }

  String getWindSpeed(
      {WindSpeedMeasurementUnits windSpeedMeasurementUnits =
          WindSpeedMeasurementUnits.MetersPerSecond}) {
    return windSpeedConvert(windSpeed, windSpeedMeasurementUnits).toString() + ' ' + windSpeedMeasurementUnitsToString(windSpeedMeasurementUnits);
  }

  String getPressure({PressureMeasurementUnits pressureMeasurementUnits = PressureMeasurementUnits.Gigapascals}) {
    return pressureConvert(pressure, pressureMeasurementUnits).toString() + ' ' + pressureMeasurementUnitsToString(pressureMeasurementUnits);
  }

  String getHumidity() {
    return humidity.toString() + '%';
  }

  String getWeather() {
    return weather;
  }

}