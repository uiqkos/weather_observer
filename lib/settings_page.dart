

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:weather_observer/measure_units.dart';
import 'package:weather_observer/settings.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    var settings = context.watch<Settings>();
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: Text('Настройки')
      ),
      body: SafeArea(
          child: Column(
            children: [
              _Toggle(
                title: 'Температура',
                item1: temperatureUnitsToString(TemperatureUnits.Celsius),
                item2: temperatureUnitsToString(TemperatureUnits.Fahrenheit),
                selectedIndex: settings.temperatureUnits == TemperatureUnits.Celsius ? 0 : 1,
                onChanged: (index) {
                  if (index == 0) {
                    settings.temperatureUnits = TemperatureUnits.Celsius;
                  } else {
                    settings.temperatureUnits = TemperatureUnits.Fahrenheit;
                  }
                },
              ),
              _Toggle(
                title: 'Давление',
                item1: pressureMeasurementUnitsToString(PressureMeasurementUnits.MillimetersOfMercury),
                item2: pressureMeasurementUnitsToString(PressureMeasurementUnits.Gigapascals),
                selectedIndex: settings.pressureMeasurementUnits == PressureMeasurementUnits.MillimetersOfMercury ? 0 : 1,
                onChanged: (index) {
                  if (index == 0) {
                    settings.pressureMeasurementUnits = PressureMeasurementUnits.MillimetersOfMercury;
                  } else {
                    settings.pressureMeasurementUnits = PressureMeasurementUnits.Gigapascals;
                  }
                },
              ),
              _Toggle(
                title: 'Скорость ветра',
                item1: windSpeedMeasurementUnitsToString(WindSpeedMeasurementUnits.MetersPerSecond),
                item2: windSpeedMeasurementUnitsToString(WindSpeedMeasurementUnits.KilometersPerHour),
                selectedIndex: settings.windSpeedMeasurementUnits == WindSpeedMeasurementUnits.MetersPerSecond ? 0 : 1,
                onChanged: (index) {
                  if (index == 0) {
                    settings.windSpeedMeasurementUnits = WindSpeedMeasurementUnits.MetersPerSecond;
                  } else {
                    settings.windSpeedMeasurementUnits = WindSpeedMeasurementUnits.KilometersPerHour;
                  }
                },
              ),
            ],
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final String title;
  final String item1;
  final String item2;
  final int selectedIndex;
  final Function(int) onChanged;

  _Toggle({
    required String title,
    required String item1,
    required String item2,
    required int selectedIndex,
    required Function(int) onChanged
  }):
        title = title,
        item1 = item1,
        item2 = item2,
        selectedIndex = selectedIndex,
        onChanged = onChanged;

  @override
  Widget build(BuildContext context) {
    return
        ListTile(
          title: Text(title),
          trailing: NeumorphicToggle(
            height: 25,
            width: 130,
            selectedIndex: selectedIndex,
            onChanged: onChanged,
            children: [
              ToggleElement(
                  background: Neumorphic(
                    child: Center(
                      child: Text(
                        item1,
                        style: NeumorphicTheme.currentTheme(context).textTheme.subtitle1,
                      )
                    ),
                  ),
                foreground: Neumorphic(
                  style: NeumorphicStyle(
                    color: NeumorphicTheme.accentColor(context),
                  ),
                  child: Center(
                      child: Text(
                        item1,
                        style: NeumorphicTheme.currentTheme(context).textTheme.subtitle2,
                      )
                  )
                )
              ),
              ToggleElement(
                background: Neumorphic(
                  child: Center(
                      child: Text(
                        item2,
                        style: NeumorphicTheme.currentTheme(context).textTheme.subtitle1,
                      )
                  )
                ),
                foreground: Neumorphic(
                  style: NeumorphicStyle(
                    color: NeumorphicTheme.accentColor(context),
                  ),
                  child: Center(
                    child: Text(
                      item2,
                      style: NeumorphicTheme.currentTheme(context).textTheme.subtitle2,
                    )
                  )
                )
              ),
            ],
            thumb: Neumorphic()
          ),
        );
  }

}

