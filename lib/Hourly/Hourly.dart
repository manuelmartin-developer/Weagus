import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget hourlyElement(hTime, hTemperature, hIsDay, hIcon, hLocalTime) {
  var hTimeFormatted = hTime.toString().substring((hTime.toString().length)-5);
  var hLocalTimeFormatted = hLocalTime.toString().substring((hLocalTime.toString().length)-5);
  return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(left: 16.0, right: 0.0, top: 20.0, bottom: 0.0),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: int.parse(hTimeFormatted.substring(0, (hTimeFormatted.length -3))) ==
                 int.parse(hLocalTimeFormatted.substring(0, (hLocalTimeFormatted.length -3))) ?
           Color.fromRGBO(12, 12, 12, 0.4) :
           Color.fromRGBO(205, 212, 228, 0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                hTimeFormatted,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Image.network('https:' + hIcon),
              Text(hTemperature.toString() + ' °C',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ));
}
