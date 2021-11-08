

enum TemperatureUnits {
  Celsius,
  Fahrenheit
}

double temperatureConvert(double temperature, TemperatureUnits to) {
  if (to == TemperatureUnits.Fahrenheit) return temperature * 1.8 + 32;
  return temperature;
}

String temperatureUnitsToString(TemperatureUnits temperatureUnit) {
  if (temperatureUnit == TemperatureUnits.Celsius) {
    return '°C';
  } else if (temperatureUnit == TemperatureUnits.Fahrenheit) {
    return '°F';
  }
  return 'unknown';
}

enum WindSpeedMeasurementUnits {
  MetersPerSecond,
  KilometersPerHour,
}

int windSpeedConvert(int windSpeed, WindSpeedMeasurementUnits to) {
  if (to == WindSpeedMeasurementUnits.KilometersPerHour) return (windSpeed * 3.6).round();
  return windSpeed;
}

String windSpeedMeasurementUnitsToString(WindSpeedMeasurementUnits windSpeedMeasurementUnits) {
  if (windSpeedMeasurementUnits == WindSpeedMeasurementUnits.KilometersPerHour) {
    return 'км/ч';
  } else if (windSpeedMeasurementUnits == WindSpeedMeasurementUnits.MetersPerSecond) {
    return 'м/с';
  }
  return 'unknown';
}

enum PressureMeasurementUnits {
  MillimetersOfMercury,
  Gigapascals
}

int pressureConvert(int pressure, PressureMeasurementUnits to) {
  if (to == PressureMeasurementUnits.MillimetersOfMercury) return (pressure / 1.333).round();
  return pressure;
}

String pressureMeasurementUnitsToString(PressureMeasurementUnits pressureMeasurementUnits) {
  if (pressureMeasurementUnits == PressureMeasurementUnits.MillimetersOfMercury) {
    return 'мм.рт.ст';
  } else if (pressureMeasurementUnits == PressureMeasurementUnits.Gigapascals) {
    return 'гПа';
  }
  return 'unknown';
}

class MeasureUnits {
  // final TemperatureUnits temperatureUnit;
  // final String
}