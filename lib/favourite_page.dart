
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:weather_observer/weather_forecast.dart';


class FavouritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var globalWeather = context.watch<GlobalWeather>();
    var favourites = globalWeather.favouriteCities;

    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('Избранные'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/cities'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: favourites.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: ListTile(
              title: Row(
                  children: [
                    MaterialButton(
                      child: Icon(globalWeather.currentCity == favourites[index]
                          ? Icons.album
                          : Icons.album_outlined
                      ),
                      onPressed: () {
                        globalWeather.currentCity = favourites[index];
                      },
                    ),
                    Text(favourites[index]),
                  ]
              ),
              trailing:
                  NeumorphicButton(
                    child: const Icon(Icons.close),
                    onPressed: () {
                      globalWeather.removeFavouriteCity(favourites[index]);
                    },

            ),
            )
          );
        }
      ),

    );
  }
}
