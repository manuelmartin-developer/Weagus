import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weagus/models/city.dart';
import 'package:weagus/search/city_search.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MaterialApp(home: Weagus()));
}

class Weagus extends StatefulWidget {
  @override
  _WeagusState createState() => _WeagusState();
}

class _WeagusState extends State<Weagus> {
  // Declaración de variables
  double temperature = 0;
  String city = '';
  String region = '';
  String country = '';
  double longitude = 0;
  double latitude = 0;
  String weather = 'weagus';
  String icon = '//cdn.weatherapi.com/weather/64x64/night/116.png';
  String errorMessage = '';
  String API_KEY = dotenv.env['WEATHER_API_KEY'];
  String searchApiUrl = "http://api.weatherapi.com/v1/forecast.json?key=";
  List<double> minTemperatureForecast = List.filled(7, 0);
  List<double> maxTemperatureForecast = List.filled(7, 0);
  List<String> iconForecast =
      List.filled(7, '//cdn.weatherapi.com/weather/64x64/night/116.png');
  int epaIndex = 0;
  double co = 0;
  double no2 = 0;
  double o3 = 0;
  double so2 = 0;
  double pm2_5 = 0;
  double pm10 = 0;
  City selectedCity;
  List<City> history = [];

  // Método que que modifica el estado del componente
  initState() {
    super.initState();
    fetchLocation();
  }

// Método que recaba la localización dle dispositivo
  void getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      latitude = _locationData.latitude;
      longitude = _locationData.longitude;
    });
  }

// Método que recaba los datos de la API con la ciudad
// introducida por el usuario
  void fetchSearch(String input) async {
    try {
      input.replaceAll(" ", "");
      var searchResult = await http.get(Uri.parse(searchApiUrl +
          API_KEY +
          "&q=" +
          input +
          '&days=7&aqi=yes&alerts=yes'));
      var result = await json.decode(searchResult.body);

      setState(() {
        city = result["location"]["name"];
        region = result["location"]["region"];
        country = result["location"]["country"];
        longitude = result["location"]["lon"];
        latitude = result["location"]["lat"];
        temperature = result["current"]["temp_c"];
        icon = result["current"]["condition"]["icon"];
        weather = result["current"]["condition"]["text"]
            .replaceAll(' ', '')
            .toLowerCase();
        epaIndex = result["current"]["air_quality"]["gb-defra-index"];
        co = result["current"]["air_quality"]["co"];
        no2 = result["current"]["air_quality"]["no2"];
        o3 = result["current"]["air_quality"]["o3"];
        so2 = result["current"]["air_quality"]["so2"];
        pm2_5 = result["current"]["air_quality"]["pm2_5"];
        pm10 = result["current"]["air_quality"]["pm10"];
        errorMessage = '';
      });

      var forecast = result["forecast"]["forecastday"];

      for (var i = 0; i < 7; i++) {
        setState(() {
          minTemperatureForecast[i] = forecast[i]["day"]["mintemp_c"];
          maxTemperatureForecast[i] = forecast[i]["day"]["maxtemp_c"];
          iconForecast[i] = forecast[i]["day"]["condition"]["icon"];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage =
            "No existen datos sobre esa ciudad.\nPor favor, intente con otra.";
      });
    }
  }

// Método que recaba datos de la API con los datos
//de geolocalización recibidos.
  void fetchLocation() async {
    await getLocation();

    var locationResult = await http.get(Uri.parse(searchApiUrl +
        API_KEY +
        "&q=" +
        latitude.toString() +
        ',' +
        longitude.toString() +
        '&days=7&aqi=yes&alerts=yes'));

    var result = await json.decode(locationResult.body);

    setState(() {
      city = result["location"]["name"];
      region = result["location"]["region"];
      country = result["location"]["country"];
      temperature = result["current"]["temp_c"];
      icon = result["current"]["condition"]["icon"];
      weather = result["current"]["condition"]["text"]
          .replaceAll(' ', '')
          .toLowerCase();
      epaIndex = result["current"]["air_quality"]["gb-defra-index"];
      co = result["current"]["air_quality"]["co"];
      no2 = result["current"]["air_quality"]["no2"];
      o3 = result["current"]["air_quality"]["o3"];
      so2 = result["current"]["air_quality"]["so2"];
      pm2_5 = result["current"]["air_quality"]["pm2_5"];
      pm10 = result["current"]["air_quality"]["pm10"];
      errorMessage = '';
    });

    var forecast = result["forecast"]["forecastday"];

    for (var i = 0; i < 7; i++) {
      setState(() {
        minTemperatureForecast[i] = forecast[i]["day"]["mintemp_c"];
        maxTemperatureForecast[i] = forecast[i]["day"]["maxtemp_c"];
        iconForecast[i] = forecast[i]["day"]["condition"]["icon"];
      });
    }
  }

  onShowICA() {
    var icaValue = '';
    var icaTip = '';
    epaIndex <= 3
        ? icaValue = 'Bajo'
        : (epaIndex >= 4 && epaIndex <= 6)
            ? icaValue = 'Moderado'
            : (epaIndex >= 7 && epaIndex <= 9)
                ? icaValue = 'Alto'
                : icaValue = 'Muy alto';
    epaIndex <= 3
        ? icaTip = 'La calidad del aire es buena. ¡Un día perfecto para pasear!'
        : (epaIndex >= 4 && epaIndex <= 6)
            ? icaTip =
                'Los adultos y niños con problemas pulmonares y los adultos con problemas cardíacos que experimentan síntomas deben considerar la posibilidad de reducir la actividad física extenuante, especialmente al aire libre.'
            : (epaIndex >= 7 && epaIndex <= 9)
                ? icaTip =
                    'Cualquiera que experimente molestias como dolor de ojos, tos o dolor de garganta debe considerar reducir la actividad, especialmente al aire libre.'
                : icaTip =
                    'Cualquier exposición al aire, aunque sea por pocos minutos, puede provocar graves efectos en la salud de todas las personas. Evite las actividades al aire libre.';

    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(10, 10, 10, 0.95),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Indice de Calidad del Aire',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                    Divider(height: 10, thickness: 1, color: Colors.grey),
                    Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Nivel de polución',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          epaIndex.toString() + ' ' + icaValue,
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w600,
                              color: epaIndex <= 3
                                  ? Color.fromRGBO(144, 190, 109, 0.7)
                                  : (epaIndex >= 4 && epaIndex <= 6)
                                      ? Color.fromRGBO(248, 150, 30, 0.7)
                                      : (epaIndex >= 7 && epaIndex <= 9)
                                          ? Color.fromRGBO(249, 65, 68, 0.7)
                                          : Color.fromRGBO(206, 48, 255, 0.7)),
                        )),
                    Row(children: [
                      Expanded(
                          child: Column(
                        children: [
                          Text(pm2_5.toStringAsFixed(2),
                              style: TextStyle(
                                  color: pm2_5 <= 11.999999999
                                      ? Color.fromRGBO(156, 255, 156, 0.7)
                                      : (pm2_5 >= 12.0 && pm2_5 <= 23.99999999)
                                          ? Color.fromRGBO(48, 255, 1, 0.7)
                                          : (pm2_5 >= 24.0 &&
                                                  pm2_5 <= 35.999999999)
                                              ? Color.fromRGBO(49, 207, 1, 0.7)
                                              : (pm2_5 >= 36.0 &&
                                                      pm2_5 <= 41.999999999)
                                                  ? Color.fromRGBO(
                                                      255, 255, 1, 0.7)
                                                  : (pm2_5 >= 42.0 &&
                                                          pm2_5 <= 47.999999999)
                                                      ? Color.fromRGBO(
                                                          255, 207, 1, 0.7)
                                                      : (pm2_5 >= 48.0 &&
                                                              pm2_5 <=
                                                                  53.999999999)
                                                          ? Color.fromRGBO(
                                                              255, 154, 0, 0.7)
                                                          : (pm2_5 >= 54.0 &&
                                                                  pm2_5 <=
                                                                      58.999999999)
                                                              ? Color.fromRGBO(
                                                                  255,
                                                                  100,
                                                                  100,
                                                                  0.7)
                                                              : (pm2_5 >= 59.0 &&
                                                                      pm2_5 <=
                                                                          64.999999999)
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0.7)
                                                                  : (pm2_5 >= 59.0 &&
                                                                          pm2_5 <=
                                                                              64.999999999)
                                                                      ? Color.fromRGBO(
                                                                          153,
                                                                          0,
                                                                          0,
                                                                          0.7)
                                                                      : Color.fromRGBO(
                                                                          206,
                                                                          48,
                                                                          255,
                                                                          0.7))),
                          Text('PM2.5', style: TextStyle(color: Colors.white)),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Text(pm10.toStringAsFixed(2),
                              style: TextStyle(
                                  color: pm10 <= 16.99999999
                                      ? Color.fromRGBO(156, 255, 156, 0.7)
                                      : (pm10 >= 17.0 && pm10 <= 33.99999999)
                                          ? Color.fromRGBO(48, 255, 1, 0.7)
                                          : (pm10 >= 34.0 &&
                                                  pm10 <= 50.999999999)
                                              ? Color.fromRGBO(49, 207, 1, 0.7)
                                              : (pm10 >= 51.0 &&
                                                      pm10 <= 58.999999999)
                                                  ? Color.fromRGBO(
                                                      255, 255, 1, 0.7)
                                                  : (pm10 >= 59.0 &&
                                                          pm10 <= 66.999999999)
                                                      ? Color.fromRGBO(
                                                          255, 207, 1, 0.7)
                                                      : (pm10 >= 67.0 &&
                                                              pm10 <=
                                                                  75.999999999)
                                                          ? Color.fromRGBO(
                                                              255, 154, 0, 0.7)
                                                          : (pm10 >= 76.0 &&
                                                                  pm10 <=
                                                                      83.999999999)
                                                              ? Color.fromRGBO(
                                                                  255,
                                                                  100,
                                                                  100,
                                                                  0.7)
                                                              : (pm10 >= 84.0 &&
                                                                      pm10 <=
                                                                          91.999999999)
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0.7)
                                                                  : (pm10 >= 92.0 &&
                                                                          pm10 <=
                                                                              100.999999999)
                                                                      ? Color.fromRGBO(
                                                                          153,
                                                                          0,
                                                                          0,
                                                                          0.7)
                                                                      : Color.fromRGBO(
                                                                          206,
                                                                          48,
                                                                          255,
                                                                          0.7))),
                          Text('PM10', style: TextStyle(color: Colors.white)),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Text(so2.toStringAsFixed(2),
                              style: TextStyle(
                                  color: so2 <= 88.99999999
                                      ? Color.fromRGBO(156, 255, 156, 0.7)
                                      : (so2 >= 89.0 && so2 <= 177.99999999)
                                          ? Color.fromRGBO(48, 255, 1, 0.7)
                                          : (so2 >= 179.0 &&
                                                  so2 <= 266.999999999)
                                              ? Color.fromRGBO(49, 207, 1, 0.7)
                                              : (so2 >= 267.0 &&
                                                      so2 <= 354.999999999)
                                                  ? Color.fromRGBO(
                                                      255, 255, 1, 0.7)
                                                  : (so2 >= 355.0 &&
                                                          so2 <= 443.999999999)
                                                      ? Color.fromRGBO(
                                                          255, 207, 1, 0.7)
                                                      : (so2 >= 444.0 &&
                                                              so2 <=
                                                                  532.999999999)
                                                          ? Color.fromRGBO(
                                                              255, 154, 0, 0.7)
                                                          : (so2 >= 533.0 &&
                                                                  so2 <=
                                                                      710.999999999)
                                                              ? Color.fromRGBO(
                                                                  255,
                                                                  100,
                                                                  100,
                                                                  0.7)
                                                              : (so2 >= 711.0 &&
                                                                      so2 <=
                                                                          887.999999999)
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0.7)
                                                                  : (so2 >= 888.0 &&
                                                                          so2 <=
                                                                              1064.999999999)
                                                                      ? Color.fromRGBO(
                                                                          153,
                                                                          0,
                                                                          0,
                                                                          0.7)
                                                                      : Color.fromRGBO(
                                                                          206,
                                                                          48,
                                                                          255,
                                                                          0.7))),
                          Text('SO2', style: TextStyle(color: Colors.white)),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Text(no2.toStringAsFixed(2),
                              style: TextStyle(
                                  color: no2 <= 67.99999999
                                      ? Color.fromRGBO(156, 255, 156, 0.7)
                                      : (no2 >= 68.0 && no2 <= 134.99999999)
                                          ? Color.fromRGBO(48, 255, 1, 0.7)
                                          : (no2 >= 135.0 &&
                                                  no2 <= 200.999999999)
                                              ? Color.fromRGBO(49, 207, 1, 0.7)
                                              : (no2 >= 201.0 &&
                                                      no2 <= 267.999999999)
                                                  ? Color.fromRGBO(
                                                      255, 255, 1, 0.7)
                                                  : (no2 >= 268.0 &&
                                                          no2 <= 334.999999999)
                                                      ? Color.fromRGBO(
                                                          255, 207, 1, 0.7)
                                                      : (no2 >= 335.0 &&
                                                              no2 <=
                                                                  400.999999999)
                                                          ? Color.fromRGBO(
                                                              255, 154, 0, 0.7)
                                                          : (no2 >= 401.0 &&
                                                                  no2 <=
                                                                      467.999999999)
                                                              ? Color.fromRGBO(
                                                                  255,
                                                                  100,
                                                                  100,
                                                                  0.7)
                                                              : (no2 >= 468.0 &&
                                                                      no2 <=
                                                                          534.999999999)
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0.7)
                                                                  : (no2 >= 535.0 &&
                                                                          no2 <=
                                                                              600.999999999)
                                                                      ? Color.fromRGBO(
                                                                          153,
                                                                          0,
                                                                          0,
                                                                          0.7)
                                                                      : Color.fromRGBO(
                                                                          206,
                                                                          48,
                                                                          255,
                                                                          0.7))),
                          Text('NO2', style: TextStyle(color: Colors.white)),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Text(o3.toStringAsFixed(2),
                              style: TextStyle(
                                  color: o3 <= 33.99999999
                                      ? Color.fromRGBO(156, 255, 156, 0.7)
                                      : (o3 >= 34.0 && o3 <= 66.99999999)
                                          ? Color.fromRGBO(48, 255, 1, 0.7)
                                          : (o3 >= 67.0 && o3 <= 100.999999999)
                                              ? Color.fromRGBO(49, 207, 1, 0.7)
                                              : (o3 >= 101.0 &&
                                                      o3 <= 120.999999999)
                                                  ? Color.fromRGBO(
                                                      255, 255, 1, 0.7)
                                                  : (o3 >= 121.0 &&
                                                          o3 <= 140.999999999)
                                                      ? Color.fromRGBO(
                                                          255, 207, 1, 0.7)
                                                      : (o3 >= 141.0 &&
                                                              o3 <=
                                                                  160.999999999)
                                                          ? Color.fromRGBO(
                                                              255, 154, 0, 0.7)
                                                          : (o3 >= 161.0 &&
                                                                  o3 <=
                                                                      187.999999999)
                                                              ? Color.fromRGBO(
                                                                  255,
                                                                  100,
                                                                  100,
                                                                  0.7)
                                                              : (o3 >= 188.0 &&
                                                                      o3 <=
                                                                          213.999999999)
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0.7)
                                                                  : (o3 >= 214.0 &&
                                                                          o3 <=
                                                                              240.999999999)
                                                                      ? Color.fromRGBO(
                                                                          153,
                                                                          0,
                                                                          0,
                                                                          0.7)
                                                                      : Color.fromRGBO(
                                                                          206,
                                                                          48,
                                                                          255,
                                                                          0.7))),
                          Text('O3', style: TextStyle(color: Colors.white)),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Text(co.toStringAsFixed(2),
                              style: TextStyle(
                                  color: co <= 440.99999999
                                      ? Color.fromRGBO(49, 207, 1, 0.7)
                                      : (co >= 450.0 && co <= 940.99999999)
                                          ? Color.fromRGBO(255, 255, 1, 0.7)
                                          : (co >= 950.0 &&
                                                  co <= 1240.999999999)
                                              ? Color.fromRGBO(255, 154, 0, 0.7)
                                              : (co >= 1250.0 &&
                                                      co <= 1540.999999999)
                                                  ? Color.fromRGBO(
                                                      255, 0, 0, 0.7)
                                                  : (co >= 1550.0 &&
                                                          co <= 3040.999999999)
                                                      ? Color.fromRGBO(
                                                          153, 0, 0, 0.7)
                                                      : Color.fromRGBO(
                                                          206, 48, 255, 0.7))),
                          Text('CO', style: TextStyle(color: Colors.white)),
                        ],
                      )),
                    ]),
                    Divider(height: 10, thickness: 1, color: Colors.grey),
                    Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Consejos',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(icaTip,
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/$weather.png'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.8), BlendMode.dstATop)),
          ),
          child: city == ""
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
                  appBar: AppBar(
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            fetchLocation();
                          },
                          child: Icon(Icons.location_on, size: 36.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () async {
                             final cityToSearch = await showSearch(
                                          context: context,
                                          delegate: CitySearchDelegate(
                                              'Buscar ciudad...', history));

                                      if (cityToSearch != null) {
                                        fetchSearch(cityToSearch.name);
                                      setState(() {
                                        this.selectedCity = cityToSearch;
                                        if(!history.contains(cityToSearch)){
                                          this.history.insert(0, cityToSearch);
                                        }
                                      });
                                      }
                          },
                          child: Icon(Icons.search, size: 36.0),
                        ),),
                    ],
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                  ),
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              temperature.toString() + ' °C',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 60.0),
                            ),
                          ),
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'http:' + icon,
                                width: 100,
                              ),
                              TextButton.icon(
                                  icon: Icon(Icons.air_sharp),
                                  label: Text(epaIndex.toString() + ' ICA'),
                                  onPressed: onShowICA,
                                  style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      primary: Colors.white,
                                      backgroundColor: epaIndex <= 3
                                          ? Color.fromRGBO(144, 190, 109, 0.7)
                                          : (epaIndex >= 4 && epaIndex <= 6)
                                              ? Color.fromRGBO(
                                                  248, 150, 30, 0.7)
                                              : (epaIndex >= 7 && epaIndex <= 9)
                                                  ? Color.fromRGBO(
                                                      249, 65, 68, 0.7)
                                                  : Color.fromRGBO(
                                                      106, 4, 15, 0.7)))
                            ],
                          )),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              city,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 40.0),
                            ),
                          ),
                          Center(
                            child: Text(
                              region + "(" + country + ")",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            for (var i = 0; i < 7; i++)
                              forecastElement(
                                  i + 1,
                                  iconForecast[i],
                                  minTemperatureForecast[i],
                                  maxTemperatureForecast[i]),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}

Widget forecastElement(daysFromNow, icon, minTemperature, maxTemperature) {
  var now = new DateTime.now();
  var oneDayFromNow = now.add(new Duration(days: daysFromNow));
  return Padding(
    padding: const EdgeInsets.only(left: 16.0),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(205, 212, 228, 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              new DateFormat.E().format(oneDayFromNow),
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Text(
              new DateFormat.MMMd().format(oneDayFromNow),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Image.network(
                'http:' + icon,
                width: 50,
              ),
            ),
            Text(
              'Max: ' + maxTemperature.toString() + ' °C',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            Text(
              'Min: ' + minTemperature.toString() + ' °C',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ],
        ),
      ),
    ),
  );
}
