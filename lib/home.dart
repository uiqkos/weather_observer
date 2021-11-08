import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:weather_observer/settings.dart';
import 'package:weather_observer/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:weather_observer/utils.dart';

import 'package:weather_observer/weather_forecast.dart';

import 'measure_units.dart';
import 'weather.dart';


class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final String title = 'Weather Observer';
  Weather _current = Weather.empty();
  WeatherForecast _forecast = WeatherForecast.empty();
  Map<String, Weather> _weatherByTime = Map<String, Weather>();

  void setCurrentWeather(forecast) {
    _forecast = forecast;
    _current = _forecast.current;

    // _forecast.forecast.forEach((key, value) {print('$key: ${value.iconId}');});
    _weatherByTime.clear();

    for (int i = 0; i < 4; i += 1) {
      var index = i * 2;
      _weatherByTime[_forecast.hourly[index].date.hour.toString().padLeft(2, '0') +
            ':' + _forecast.hourly[index].date.minute.toString().padLeft(2, '0')] = _forecast.hourly[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    var settings = context.watch<Settings>();
    var globalWeather = context.watch<GlobalWeather>();

    return FutureBuilder<WeatherForecast>(
        future: globalWeather.sync(),
        builder: (context, snapshot) {
          if (!snapshot.hasError && snapshot.hasData) {
            setCurrentWeather(snapshot.data!);
          }

          return Scaffold(
            drawer: Neumorphic(
              child:Drawer(
              child: Container(
                child: SafeArea(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Weather observer',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Настройки'),
                        onTap: () => Navigator.pushNamed(context, '/settings'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.favorite),
                        title: const Text('Избранное'),
                        onTap: () => Navigator.pushNamed(context, '/favourites'),
                      ),
                      ListTile(
                          leading: const Icon(Icons.info),
                          title: const Text('О приложении'),
                          onTap: () => Navigator.pushNamed(context, '/about')
                      ),
                    ],
                  ),
                ),
              ),
            ),),
            body: Container(
              child: SafeArea(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Builder(
                                builder: (context) => MaterialButton(
                                  child: Icon(Icons.arrow_forward_sharp, color: Colors.white,),
                                  onPressed: () => Scaffold.of(context).openDrawer()
                                  ),
                              ),
                              Container(),
                              MaterialButton(
                                child: Icon(Icons.add, color: Colors.white,),
                                onPressed: () => Navigator.pushNamed(context, '/cities')
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Text(
                            globalWeather.currentCity,
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          Text(
                            '${weekdays[_current.date.weekday]}, ${_current.date.day}.${_current.date.month}',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          Text(
                            '${_current.getTemperature(temperatureUnits: settings.temperatureUnits)}',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          Text(
                            ' ${_current.weather}',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          SizedBox(height: 160),
                          Neumorphic(
                            child: SlidingUpPanel(
                              maxHeight: 380,
                              minHeight: 150,
                              panel: Neumorphic(
                                // style: Theme,
                                child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10,),
                                        Container(
                                          height: 5,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).backgroundColor,
                                            borderRadius: BorderRadius.circular(30)
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(),
                                              ...(_weatherByTime.entries.map((entry) =>
                                                  _WeatherCard(
                                                    time: entry.key,
                                                    temperature: entry.value.getTemperature(temperatureUnits: settings.temperatureUnits),
                                                    image: NetworkImage('http://openweathermap.org/img/wn/${entry.value.iconId}@2x.png')
                                                  )
                                                )),
                                              Container()
                                              // SizedBox(width: 10),
                                            ]
                                        ),
                                        SizedBox(height: 30),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(),
                                                _DetailCard(value: _current.getTemperature(
                                                    temperatureUnits: settings.temperatureUnits
                                                ), assetImage: AssetImage('assets/images/temperature.png')),
                                                _DetailCard(value: _current.getHumidity(), assetImage: AssetImage('assets/images/humidity.png')),
                                                Container(),
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(),
                                                // SizedBox(width: 30),
                                                _DetailCard(value: _current.getWindSpeed(
                                                    windSpeedMeasurementUnits: settings.windSpeedMeasurementUnits
                                                ), assetImage: AssetImage('assets/images/wind-flag.png')),
                                                _DetailCard(value: _current.getPressure(
                                                    pressureMeasurementUnits: settings.pressureMeasurementUnits
                                                ), assetImage: AssetImage('assets/images/barometer.png')),
                                                Container(),
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                          ],
                                        ),
                                        SizedBox(height: 15,),
                                        Center(
                                          child: NeumorphicButton(
                                            child: Text(
                                              'Прогноз на неделю',
                                              style: NeumorphicTheme.currentTheme(context).textTheme.subtitle1,
                                            ),
                                            onPressed: () {Navigator.pushNamed(context, '/weekly');},
                                          ),
                                        )
                                      ],
                                    )
                                ),
                              ),
                            ),
                          )
                        ]
                    ),
                    ),
                  ),
                decoration: BoxDecoration(
            image: Theme.of(context).brightness == Brightness.dark
                ? DecorationImage(
              image: NetworkImage('https://games.mail.ru/hotbox/content_files/gallery/ff/7f/firewatch_screenshot_de832b7a.png'),
              fit: BoxFit.cover,
            )
                : DecorationImage(
              image: AssetImage('assets/images/main.png'),
              fit: BoxFit.cover,
            ),

          ),
              ),
            );

        }
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final String time;
  final String temperature;
  final image;

  _WeatherCard({required String time, required String temperature, required image}):
        time = time,
        temperature = temperature,
        image = image
  ;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Column(
        children: [
          SizedBox(height: 10, width: 80),
          Text(time, style: TextStyle(fontSize: 15),),
          Image(
            image: image,
            height: 50,
            width: 50,
          ),
          Text(temperature, style: TextStyle(fontSize: 15),),
          SizedBox(height: 10),
        ],
      ),
    );
  }

}

class _DetailCard extends StatelessWidget {
  final String value;
  final icon;

  _DetailCard({required String value, required assetImage}):
        value = value,
        icon = assetImage;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
        height: 60,
        width: 160,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: icon, height: 35, width: 35),
            SizedBox(width: 10,),
            Text(value, style: TextStyle(fontSize: 17)),
          ],
        ),
      ),
    );
  }
}

class ThermometerImage extends StatelessWidget {
  AssetImage? image;

  ThermometerImage(double temperature) {
    var assetName = '';

    if (temperature < 10) {
      assetName = 'cold.png';
    } else if (temperature < 25) {
      assetName = 'normal.png';
    } else {
      assetName = 'hot.png';
    }

    image = AssetImage('assets/images/$assetName');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}
