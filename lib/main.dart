
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_observer/about_page.dart';
import 'package:weather_observer/city_search_page.dart';
import 'package:weather_observer/favourite_page.dart';
import 'package:weather_observer/settings.dart';
import 'package:weather_observer/settings_page.dart';
import 'package:weather_observer/weather_forecast.dart';
import 'package:weather_observer/weekly.dart';

import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init();
  await GlobalWeather.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Settings>(create: (context) => Settings()),
      ChangeNotifierProvider<GlobalWeather>(create: (context) => GlobalWeather()),
    ],
    child: App()
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const lightPrimary = Color(0xfffafafa);

    return NeumorphicApp(
      debugShowCheckedModeBanner: false,

      theme: const NeumorphicThemeData(
        baseColor: lightPrimary,
        variantColor: Color(0xEAFFFFFF),
        accentColor: Color(0xff354062),
        appBarTheme: NeumorphicAppBarThemeData(
          color: lightPrimary,
        ),
        textTheme: TextTheme(
          subtitle1: TextStyle(color: Color(0xff656565)),
          subtitle2: TextStyle(color: Colors.white),
        ),
      ),

      darkTheme: const NeumorphicThemeData(
        baseColor: Color(0xff0c1620),
        variantColor: Color(0xff354062),
        accentColor: Color(0xfff39369),
        shadowLightColor: Colors.transparent,
        shadowDarkColor: Color(0x98FFA793),
        defaultTextColor: Colors.white,

        textTheme: TextTheme(
          subtitle1: TextStyle(color: Color(0xffe5e5e5)),
          subtitle2: TextStyle(color: Colors.white),
        ),

        lightSource: LightSource.bottomRight,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/settings': (context) => SettingsPage(),
        '/weekly': (context) => WeeklyPage(),
        '/about': (context) => AboutPage(),
        '/favourites': (context) => FavouritePage(),
        '/cities': (context) => CitySearchPage(),
      },
    );
  }
}

