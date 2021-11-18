import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalICA extends StatelessWidget {
  const ModalICA({
    Key key,
    @required this.epaIndex,
    @required this.icaValue,
    @required this.pm2_5,
    @required this.pm10,
    @required this.so2,
    @required this.no2,
    @required this.o3,
    @required this.co,
    @required this.icaTip,
  }) : super(key: key);

  final int epaIndex;
  final String icaValue;
  final double pm2_5;
  final double pm10;
  final double so2;
  final double no2;
  final double o3;
  final double co;
  final String icaTip;

  @override
  Widget build(BuildContext context) {
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
                'Índice de Calidad del Aire',
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
  }
}