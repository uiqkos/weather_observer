
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_stack_card/flutter_stack_card.dart';
import 'package:weather_observer/settings.dart';
import 'package:weather_observer/utils.dart';
import 'package:weather_observer/weather.dart';
import 'package:weather_observer/weather_forecast.dart';
import 'package:provider/provider.dart';

class WeeklyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var weather = context.watch<GlobalWeather>();
    var settings = context.watch<Settings>();

    return FutureBuilder<WeatherForecast>(
        future: weather.sync(),
        builder: (context, snapshot) {
          var forecast = WeatherForecast.empty();
          if (!snapshot.hasError && snapshot.hasData) {
            forecast = snapshot.data!;
          }

          return Scaffold(
            appBar: NeumorphicAppBar(
              title: Text('Прогноз на неделю'),
            ),
            body: SafeArea(
              child: Stack(
                  children: [
                    StackCard.builder(
                        itemBuilder: (context, index) {
                          return _itemBuilder(
                            DateTime.now().add(Duration(days: index)),
                            forecast.daily[index],
                            context,
                            settings
                          );
                        },
                        itemCount: forecast.daily.length
                    ),
                  ]
              ),
            ),
          );
        }
    );
  }
}

Widget _itemBuilder(DateTime dateTime, Weather weather, BuildContext context, Settings settings) {
  return Neumorphic(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            '${weekdays[dateTime.weekday]}, ${dateTime.month}.${dateTime.day}',
            style: TextStyle(
              fontSize: 23
            ),
          ),
          SizedBox(height: 10),
          Text(
            '${weather.weather}',
            style: TextStyle(
              fontSize: 20
            ),
          ),
          SizedBox(height: 20),
          Image(
            image: NetworkImage('http://openweathermap.org/img/wn/${weather.iconId}@2x.png'),
            height: 90,
            width: 90,
          ),
          _DetailCard(value: weather.getTemperature(
              temperatureUnits: settings.temperatureUnits
          ), assetImage: AssetImage('assets/images/temperature.png')),
          SizedBox(height: 20,),
          _DetailCard(value: weather.getWindSpeed(
            windSpeedMeasurementUnits: settings.windSpeedMeasurementUnits
          ), assetImage: AssetImage('assets/images/wind-flag.png')),
          SizedBox(height: 20),
          _DetailCard(value: weather.getHumidity(), assetImage: AssetImage('assets/images/humidity.png')),
          SizedBox(height: 20),
          _DetailCard(value: weather.getPressure(
            pressureMeasurementUnits: settings.pressureMeasurementUnits
          ), assetImage: AssetImage('assets/images/barometer.png')),
          SizedBox(height: 30),
        ],
      ),
  );
}

class _DetailCard extends StatelessWidget {
  final String value;
  final AssetImage icon;

  _DetailCard({required String value, required AssetImage assetImage}):
        value = value,
        icon = assetImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 15,),
        Image(image: icon, height: 35, width: 35),
        SizedBox(width: 10,),
        Text(value, style: TextStyle(fontSize: 17)),
      ],
    );
  }
}
