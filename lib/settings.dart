import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_observer/measure_units.dart';


class Settings extends ChangeNotifier {
  static late final SharedPreferences sharedPreferences;

  TemperatureUnits get temperatureUnits =>
      sharedPreferences.getString('tempUnits') == 'C'
        ? TemperatureUnits.Celsius
        : TemperatureUnits.Fahrenheit;

  set temperatureUnits(TemperatureUnits value) {
    sharedPreferences.setString('tempUnits', value == TemperatureUnits.Celsius ? 'C' : 'F');
    notifyListeners();
  }

  WindSpeedMeasurementUnits get windSpeedMeasurementUnits =>
      sharedPreferences.getString('windSpeedUnits') == 'mps'
        ? WindSpeedMeasurementUnits.MetersPerSecond
        : WindSpeedMeasurementUnits.KilometersPerHour;

  set windSpeedMeasurementUnits(WindSpeedMeasurementUnits value) {
    sharedPreferences.setString('windSpeedUnits',
        value == WindSpeedMeasurementUnits.KilometersPerHour ? 'kmph' : 'mps');
    notifyListeners();
  }

  PressureMeasurementUnits get pressureMeasurementUnits =>
      sharedPreferences.getString('pressureUnits') == 'mm'
          ? PressureMeasurementUnits.MillimetersOfMercury
          : PressureMeasurementUnits.Gigapascals;

  set pressureMeasurementUnits(PressureMeasurementUnits value) {
    sharedPreferences.setString('pressureUnits',
        value == PressureMeasurementUnits.Gigapascals ? 'hpa' : 'mm');
    notifyListeners();
  }

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
