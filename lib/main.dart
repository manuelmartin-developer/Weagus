// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:weagus/models/city.dart';
import 'package:weagus/search/city_search.dart';

import 'Forecast/Forecast.dart';
import 'Modals/Modal_ICA.dart';
import 'Modals/Modal_pollen.dart';

Future main() async {
  runApp(MaterialApp(home: Weagus()));
}

class Weagus extends StatefulWidget {
  @override
  _WeagusState createState() => _WeagusState();
}

class _WeagusState extends State<Weagus> {

  // Variable global de gestión de estado del menú
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

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
  // String API_KEY = dotenv.env['WEATHER_API_KEY'];
  // String POLLEN_API_KEY = dotenv.env['POLLEN_API_KEY'];
  String searchApiUrl = "http://api.weatherapi.com/v1/forecast.json?key=";
  String searchPollenApiUrl =
      "https://api.ambeedata.com/latest/pollen/by-lat-lng?";
  List<double> minTemperatureForecast = List.filled(7, 0);
  List<double> maxTemperatureForecast = List.filled(7, 0);
  List<double> avgtempForecast = List.filled(7, 0);
  List<double> maxwindForecast = List.filled(7, 0);
  List<double> totalPrecipForecast = List.filled(7, 0);
  List<double> humidityForecast = List.filled(7, 0);
  List<double> uvForecast = List.filled(7, 0);
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
  int grass_pollen = 0;
  int tree_pollen = 0;
  int weed_pollen = 0;
  String grass_pollen_risk = '';
  String tree_pollen_risk = '';
  String weed_pollen_risk = '';
  double avgtemp = 0;
  double maxwind = 0;
  double totalprecip = 0;
  double humidity = 0;
  double uv = 0;


  // Método que que modifica el estado inicial de la aplicación
  initState() {
    super.initState();
    fetchLocation();
  }

  // Método que recaba la localización del dispositivo
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

  // Método que recaba datos de la API y recibe los índices actuales
  // de polén según las coordenadas de búsqueda
  void fetchPollenIndex() async {
    try {
      var pollenApiResult = await http.get(
        Uri.parse(searchPollenApiUrl +
            'lat=' +
            latitude.toString() +
            '&lng=' +
            longitude.toString()),
        headers: {
          "x-api-key": "d98c7fd23b359622d11820b4ef5890334dab645a67a01dacb163c0c539138d89",
          "Content-type": "application/json"
        },
      );

      var pollenResults = await json.decode(pollenApiResult.body);

      setState(() {
        grass_pollen = pollenResults['data'][0]['Count']['grass_pollen'];
        tree_pollen = pollenResults['data'][0]['Count']['tree_pollen'];
        weed_pollen = pollenResults['data'][0]['Count']['weed_pollen'];
        grass_pollen_risk = pollenResults['data'][0]['Risk']['grass_pollen'];
        tree_pollen_risk = pollenResults['data'][0]['Risk']['tree_pollen'];
        weed_pollen_risk = pollenResults['data'][0]['Risk']['weed_pollen'];
      });
      grass_pollen_risk == 'Low'
          ? grass_pollen_risk = 'Bajo'
          : grass_pollen_risk == 'Moderate'
              ? grass_pollen_risk = 'Moderado'
              : grass_pollen_risk == 'High'
                  ? grass_pollen_risk = 'Alto'
                  : grass_pollen_risk == 'Very High'
                      ? grass_pollen_risk = 'Muy Alto'
                      : grass_pollen_risk = 'Sin datos';
      tree_pollen_risk == 'Low'
          ? tree_pollen_risk = 'Bajo'
          : tree_pollen_risk == 'Moderate'
              ? tree_pollen_risk = 'Moderado'
              : tree_pollen_risk == 'High'
                  ? tree_pollen_risk = 'Alto'
                  : tree_pollen_risk == 'Very High'
                      ? tree_pollen_risk = 'Muy Alto'
                      : tree_pollen_risk = 'Sin datos';
      weed_pollen_risk == 'Low'
          ? weed_pollen_risk = 'Bajo'
          : weed_pollen_risk == 'Moderate'
              ? weed_pollen_risk = 'Moderado'
              : weed_pollen_risk == 'High'
                  ? weed_pollen_risk = 'Alto'
                  : weed_pollen_risk == 'Very High'
                      ? weed_pollen_risk = 'Muy Alto'
                      : weed_pollen_risk = 'Sin datos';
    } catch (e) {
      setState(() {
        errorMessage =
            "No existen datos sobre esa ciudad.\nPor favor, intente con otra.";
      });
    }
  }

  // Método que recaba los datos de la API con la ciudad
  // introducida por el usuario
  void fetchSearch(String input) async {
    try {
      input.replaceAll(" ", "");
      var searchResult = await http.get(Uri.parse(searchApiUrl +
          "fb300dacca6d454a9be190729211909" +
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

      fetchPollenIndex();

      var forecast = result["forecast"]["forecastday"];

      for (var i = 0; i < 7; i++) {
        setState(() {
          minTemperatureForecast[i] = forecast[i]["day"]["mintemp_c"];
          maxTemperatureForecast[i] = forecast[i]["day"]["maxtemp_c"];
          avgtempForecast[i] = forecast[i]["day"]["avgtemp_c"];
          maxwindForecast[i] = forecast[i]["day"]["maxwind_kph"];
          totalPrecipForecast[i] = forecast[i]["day"]["totalprecip_mm"];
          humidityForecast[i] = forecast[i]["day"]["totalprecip_mm"];
          uvForecast[i] = forecast[i]["day"]["uv"];
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
  // de geolocalización recibidos.
  void fetchLocation() async {
    await getLocation();

    var locationResult = await http.get(Uri.parse(searchApiUrl +
        "fb300dacca6d454a9be190729211909" +
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

    fetchPollenIndex();

    var forecast = result["forecast"]["forecastday"];

    for (var i = 0; i < 7; i++) {
      setState(() {
        minTemperatureForecast[i] = forecast[i]["day"]["mintemp_c"];
        maxTemperatureForecast[i] = forecast[i]["day"]["maxtemp_c"];
        avgtempForecast[i] = forecast[i]["day"]["avgtemp_c"];
        maxwindForecast[i] = forecast[i]["day"]["maxwind_kph"];
        totalPrecipForecast[i] = forecast[i]["day"]["totalprecip_mm"];
        humidityForecast[i] = forecast[i]["day"]["totalprecip_mm"];
        uvForecast[i] = forecast[i]["day"]["uv"];
        iconForecast[i] = forecast[i]["day"]["condition"]["icon"];
      });
    }
  }

  // Método que muestra un modal con datos de la calidad del aire
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
          return ModalICA(
              epaIndex: epaIndex,
              icaValue: icaValue,
              pm2_5: pm2_5,
              pm10: pm10,
              so2: so2,
              no2: no2,
              o3: o3,
              co: co,
              icaTip: icaTip);
        });
  }

  // Método que muestra un modal con datos del polen ambiental
  onShowPolen() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return ModalPollen(
              grass_pollen: grass_pollen,
              tree_pollen: tree_pollen,
              weed_pollen: weed_pollen,
              grass_pollen_risk: grass_pollen_risk,
              tree_pollen_risk: tree_pollen_risk,
              weed_pollen_risk: weed_pollen_risk);
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
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                temperature.toStringAsFixed(0),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 150,
                                    fontWeight: FontWeight.w300),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('°C',
                                      style: TextStyle(
                                          fontSize: 50,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300)),
                                  Text(''),
                                  Text(''),
                                  Text(''),
                                  Text(''),
                                  Text(''),
                                ],
                              )
                            ],
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              city,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.0),
                            ),
                          ),
                          Center(
                            child: Text(
                              region + "(" + country + ")",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                          Center(
                              child: Padding(
                            padding:
                                const EdgeInsets.only(top: 40.0, bottom: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton.icon(
                                    icon: Icon(LineIcons.industry),
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
                                                : (epaIndex >= 7 &&
                                                        epaIndex <= 9)
                                                    ? Color.fromRGBO(
                                                        249, 65, 68, 0.7)
                                                    : Color.fromRGBO(
                                                        106, 4, 15, 0.7))),
                                TextButton.icon(
                                    icon: Icon(LineIcons.spa),
                                    label: Text('Polen'),
                                    onPressed: onShowPolen,
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        primary: Colors.white,
                                        backgroundColor: grass_pollen_risk ==
                                                    'Moderado' ||
                                                tree_pollen_risk ==
                                                    'Moderado' ||
                                                weed_pollen_risk == 'Moderado'
                                            ? Color.fromRGBO(248, 150, 30, 0.7)
                                            : (grass_pollen_risk == 'Alto' ||
                                                    tree_pollen_risk ==
                                                        'Alto' ||
                                                    weed_pollen_risk == 'Alto')
                                                ? Color.fromRGBO(
                                                    106, 4, 15, 0.7)
                                                : (grass_pollen_risk ==
                                                            'Muy Alto' ||
                                                        tree_pollen_risk ==
                                                            'Muy Alto' ||
                                                        weed_pollen_risk ==
                                                            'Muy Alto')
                                                    ? Color.fromRGBO(
                                                        206, 48, 255, 0.7)
                                                    : Color.fromRGBO(
                                                        144, 190, 109, 0.7)))
                              ],
                            ),
                          )),
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
                                  maxTemperatureForecast[i],
                                  avgtempForecast[i],
                                  maxwindForecast[i],
                                  totalPrecipForecast[i],
                                  humidityForecast[i],
                                  uvForecast[i]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: FabCircularMenu(
                        key: fabKey,
                        alignment: Alignment.topRight,
                        ringColor: Color.fromRGBO(20, 33, 61, 0.8),
                        ringDiameter: 500.0,
                        ringWidth: 150.0,
                        fabSize: 50.0,
                        fabOpenColor: Color.fromRGBO(205, 212, 228, 1),
                        fabCloseColor: Color.fromRGBO(20, 33, 61, 1),
                        fabOpenIcon: Icon(Icons.menu, color: Colors.white),
                        children: <Widget>[
                          Text(''),
                          TextButton.icon(
                              onPressed: () {
                                fetchLocation();
                                fabKey.currentState.close();
                              },
                              icon: Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 35,
                              ),
                              label: Text(
                                'Localización',
                                style: TextStyle(color: Colors.white),
                              )),
                          TextButton.icon(
                              onPressed: () async {
                                final cityToSearch = await showSearch(
                                    context: context,
                                    delegate: CitySearchDelegate(
                                        'Buscar ciudad...', history));

                                if (cityToSearch != null) {
                                  fetchSearch(cityToSearch.name);
                                  setState(() {
                                    this.selectedCity = cityToSearch;
                                    if (!history.contains(cityToSearch)) {
                                      this.history.insert(0, cityToSearch);
                                    }
                                  });
                                }
                                fabKey.currentState.close();
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 35,
                              ),
                              label: Text('Buscar',
                                  style: TextStyle(color: Colors.white))),
                          Text(''),
                        ]),
                  ))),
    );
  }
}
