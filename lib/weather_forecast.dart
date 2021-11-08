import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_observer/settings.dart';
import 'package:weather_observer/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'measure_units.dart';

class GeoPos {
  final double lat;
  final double lon;

  GeoPos(this.lat, this.lon);
}

Future<GeoPos> geoPosByCity(String city) async {
  var url = Uri.https('api.openweathermap.org', '/geo/1.0/direct', {
    'appid': '625e7efd63d9a63e0cb5feef454133ef',
    'limit': '1',
    'q': city,
  });

  http.Response resp = await http.get(url);
  var json = jsonDecode(resp.body)[0];

  return GeoPos(json['lat'].toDouble(), json['lon'].toDouble());
}


class WeatherForecast {
  final List<Weather> hourly;
  final List<Weather> daily;
  final Weather current;

  WeatherForecast(this.hourly, this.daily, this.current);
  WeatherForecast.empty() :
        hourly = List<Weather>.empty(),
        daily = List<Weather>.empty(),
        current = Weather.empty();

  static Future<WeatherForecast> now(
      String city
  ) async {
    var geopos = await geoPosByCity(city);

    var url = Uri.https('api.openweathermap.org', '/data/2.5/onecall', {
      'lat': geopos.lat.toString(),
      'lon': geopos.lon.toString(),
      'units': 'metric',
      'lang': 'ru',
      'appid': '625e7efd63d9a63e0cb5feef454133ef'
    });

    var json = jsonDecode((await http.get(url)).body);

    return WeatherForecast(
      (json['hourly'] as List).map((w) => Weather.fromJson(w, daily: false)).toList(),
      (json['daily'] as List).map((w) => Weather.fromJson(w, daily: true)).toList(),
      Weather.fromJson(json['current'], daily: false)
    );
  }
}

class GlobalWeather extends ChangeNotifier {
  static late final SharedPreferences sharedPreferences;

  WeatherForecast? _forecast;

  String get currentCity {
    var city = sharedPreferences.getString('currentCity');
    if (city == null) {
      sharedPreferences.setString('currentCity', 'Moscow');
      // notifyListeners();
      city = 'Moscow';
    }
    return city;
  }

  set currentCity(String city) {
    sharedPreferences.setString('currentCity', city);
    notifyListeners();
  }

  List<String> get favouriteCities {
    var cities = sharedPreferences.getStringList('favouriteCities');
    if (cities == null) {
      sharedPreferences.setStringList('favouriteCities', List<String>.empty());
      // notifyListeners();
      cities = List<String>.empty();
    }
    return cities;
  }
  
  void addFavouriteCity(String city) {
    sharedPreferences.setStringList('favouriteCities', (favouriteCities..add(city)).toSet().toList());
    notifyListeners();
  }

  void removeFavouriteCity(String city) {
    sharedPreferences.setStringList('favouriteCities', favouriteCities..remove(city));
    notifyListeners();
  }

  Future<WeatherForecast> get forecast async {
    if (_forecast == null) _forecast = await sync();
    return _forecast!;
  }

  Future<WeatherForecast> sync() async => await WeatherForecast.now(currentCity);

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
