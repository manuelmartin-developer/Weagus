import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(Weagus());
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
  String weather = 'sleet';
  String icon = '//cdn.weatherapi.com/weather/64x64/night/116.png';
  String errorMessage = '';
  String API_KEY = dotenv.env['WEATHER_API_KEY'];
  String searchApiUrl = "http://api.weatherapi.com/v1/forecast.json?key=";
  List<double> minTemperatureForecast = List.filled(7, 0);
  List<double> maxTemperatureForecast = List.filled(7, 0);
  List<String> iconForecast =
      List.filled(7, '//cdn.weatherapi.com/weather/64x64/night/116.png');

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
      var searchInput = input.replaceAll(" ", "");
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
    debugPrint("results: $result");
    setState(() {
      city = result["location"]["name"];
      region = result["location"]["region"];
      country = result["location"]["country"];
      temperature = result["current"]["temp_c"];
      icon = result["current"]["condition"]["icon"];
      weather = result["current"]["condition"]["text"]
          .replaceAll(' ', '')
          .toLowerCase();
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

// Método que se llama por el usuario al realizar la búsqueda
  void onTextFieldSubmitted(String input) {
    fetchSearch(input);
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
                  Colors.black.withOpacity(0.6), BlendMode.dstATop),
            ),
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
                      )
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
                          Container(
                            width: 300,
                            child: TextField(
                              onSubmitted: (String input) {
                                onTextFieldSubmitted(input);
                              },
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              decoration: InputDecoration(
                                hintText: 'Busca otra localización...',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 32.0, left: 32.0),
                            child: Text(errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize:
                                        Platform.isAndroid ? 15.0 : 20.0)),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Center(
                            child: Image.network(
                              'http:' + icon,
                              width: 100,
                            ),
                          ),
                          Center(
                            child: Text(
                              temperature.toString() + ' °C',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 60.0),
                            ),
                          ),
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
        color: Color.fromRGBO(205, 212, 228, 0.2),
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
