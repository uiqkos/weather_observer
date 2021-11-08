import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:weather_observer/weather_forecast.dart';

import 'city_search.dart';

class CitySearchPage extends StatefulWidget {
  const CitySearchPage({Key? key}) : super(key: key);

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  final _searchFocus = FocusNode();
  final _searchController = TextEditingController();

  Future<List<SearchResult>> cityList = Future.value([]);

  @override
  void initState() {
    super.initState();
    _searchFocus.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchCities() {
    if (_searchController.text.isEmpty) {
      return;
    }

    setState(() {
      cityList = searchCities(_searchController.text, 20);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: TextField(
          focusNode: _searchFocus,
          controller: _searchController,
          onEditingComplete: _fetchCities,
          style: const TextStyle(fontSize: 20),
          decoration: const InputDecoration(
            hintText: 'Введите город',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _fetchCities,
          ),
        ],
      ),
      body: FutureBuilder<List<SearchResult>>(
        future: cityList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return const Center(child: Text('Не удалось получить результаты'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var item = snapshot.data![index];
              var isFavorite = context.read<GlobalWeather>().favouriteCities.contains(item.city);

              return GestureDetector(
                child: ListTile(
                  title: Text('${item.city} - ${item.country}'),
                  trailing: Icon(isFavorite ? Icons.star : Icons.star_border),
                ),
                onTap: () {
                  var weather = context.read<GlobalWeather>();
                  weather.currentCity = item.city;
                  weather.addFavouriteCity(item.city);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}