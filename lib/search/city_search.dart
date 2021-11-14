import 'package:flutter/material.dart';
import 'package:weagus/models/city.dart';
import 'package:weagus/services/city_service.dart';

class CitySearchDelegate extends SearchDelegate<City> {
  @override
  final String searchFieldLabel;
  final List<City> history;
  CitySearchDelegate(this.searchFieldLabel, this.history);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => {this.query = ''}, icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => this.close(context, null),
        icon: Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().length == 0) {
      return Center(child: Text('Inserte una ciudad en la barra de búsqueda'));
    }

    final cityService = new CityService();

    return FutureBuilder(
      future: cityService.getCityByName(query),
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return ListTile(
            title: Text('Ha existido un error en el servidor.'),
          );
        }

        if (snapshot.hasData) {
          if(snapshot.data.length > 0){
            return _showCities(snapshot.data);
          }else{
            return Center(child: Text('No existe ninguna ciudad con ese nombre.', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.redAccent),));
          }
        } else {
          // Loading
          return Center(child: CircularProgressIndicator(strokeWidth: 4));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _showCities(this.history);
  }

  Widget _showCities(List<City> cities) {
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, i) {
        final city = cities[i];
        return ListTile(
          title: Text(city.name),
          onTap: () {
            this.close(context, city);
          },
        );
      },
    );
  }
}
