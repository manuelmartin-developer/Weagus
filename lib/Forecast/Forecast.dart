import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

Widget forecastElement(daysFromNow, icon, minTemperature, maxTemperature,
  avgtemp, maxwind, totalprecip, humidity, uv) {
  var now = new DateTime.now();
  var oneDayFromNow = now.add(new Duration(days: daysFromNow));
  return Card(
    elevation: 0.0,
    margin: EdgeInsets.only(left: 16.0, right: 0.0, top: 20.0, bottom: 0.0),
    color: Color(0x00000000),
    child: FlipCard(
      direction: FlipDirection.HORIZONTAL,
      speed: 500,
      onFlipDone: (status) {},
      front: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(205, 212, 228, 0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                new DateFormat.E().format(oneDayFromNow) == 'Mon'
                    ? 'Lunes'
                    : new DateFormat.E().format(oneDayFromNow) == 'Tue'
                        ? 'Martes'
                        : new DateFormat.E().format(oneDayFromNow) == 'Wed'
                            ? 'Miércoles'
                            : new DateFormat.E().format(oneDayFromNow) == 'Thu'
                                ? 'Jueves'
                                : new DateFormat.E().format(oneDayFromNow) ==
                                        'Fri'
                                    ? 'Viernes'
                                    : new DateFormat.E()
                                                .format(oneDayFromNow) ==
                                            'Sat'
                                        ? 'Sábado'
                                        : new DateFormat.E()
                                                    .format(oneDayFromNow) ==
                                                'Sun'
                                            ? 'Domingo'
                                            : new DateFormat.E()
                                                .format(oneDayFromNow),
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              Text(
                new DateFormat.MMMd().format(oneDayFromNow),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Image.network(
                  'https:' + icon,
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
      back: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(205, 212, 228, 0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  children: [
                    Icon(Icons.thermostat,
                        color: Color.fromRGBO(20, 33, 61, 1)),
                    Text(
                      '  ' + avgtemp.toString() + ' °C',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  children: [
                    Icon(Icons.air, color: Color.fromRGBO(20, 33, 61, 1)),
                    Text(
                      '  ' + maxwind.toString() + ' km/h',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  children: [
                    Icon(LineIcons.cloudWithRain,
                        color: Color.fromRGBO(20, 33, 61, 1)),
                    Text(
                      '  ' + totalprecip.toString() + ' mm',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_drink,
                      color: Color.fromRGBO(20, 33, 61, 1),
                    ),
                    Text(
                      '  ' + humidity.toString() + ' %',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Row(
                  children: [
                    Icon(Icons.wb_sunny, color: Color.fromRGBO(20, 33, 61, 1)),
                    Text(
                      '  ' + uv.toString() + ' UVA',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
