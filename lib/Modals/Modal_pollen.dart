import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalPollen extends StatelessWidget {
  const ModalPollen({
    Key key,
    @required this.grass_pollen,
    @required this.tree_pollen,
    @required this.weed_pollen,
    @required this.grass_pollen_risk,
    @required this.tree_pollen_risk,
    @required this.weed_pollen_risk,
  }) : super(key: key);

  final int grass_pollen;
  final int tree_pollen;
  final int weed_pollen;
  final String grass_pollen_risk;
  final String tree_pollen_risk;
  final String weed_pollen_risk;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(children: [
        Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(10, 10, 10, 0.95),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: <Widget>[
                  Text(
                    'Índices Globales de Polen',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                  Divider(height: 10, thickness: 1, color: Colors.grey),
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Partículas por m3',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(grass_pollen.toString(),
                                style: TextStyle(color: Colors.white)),
                            Text('Gramíneas',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            Text(tree_pollen.toString(),
                                style: TextStyle(color: Colors.white)),
                            Text('Árboles',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            Text(weed_pollen.toString(),
                                style: TextStyle(color: Colors.white)),
                            Text('Otras hierbas',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 10, thickness: 1, color: Colors.grey),
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Riesgo',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(grass_pollen_risk,
                                style: TextStyle(
                                    color: grass_pollen_risk == 'Moderado'
                                        ? Color.fromRGBO(
                                            248, 150, 30, 0.7)
                                        : grass_pollen_risk == 'Alto'
                                            ? Color.fromRGBO(
                                                249, 65, 68, 0.7)
                                            : grass_pollen_risk ==
                                                    'Muy Alto'
                                                ? Color.fromRGBO(
                                                    206, 48, 255, 0.7)
                                                : Color.fromRGBO(
                                                    144, 190, 109, 0.7))),
                            Text('Gramíneas',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            Text(tree_pollen_risk,
                                style: TextStyle(
                                    color: tree_pollen_risk == 'Moderado'
                                        ? Color.fromRGBO(
                                            248, 150, 30, 0.7)
                                        : tree_pollen_risk == 'Alto'
                                            ? Color.fromRGBO(
                                                249, 65, 68, 0.7)
                                            : tree_pollen_risk ==
                                                    'Muy Alto'
                                                ? Color.fromRGBO(
                                                    206, 48, 255, 0.7)
                                                : Color.fromRGBO(
                                                    144, 190, 109, 0.7))),
                            Text('Árboles',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            Text(weed_pollen_risk,
                                style: TextStyle(
                                    color: weed_pollen_risk == 'Moderado'
                                        ? Color.fromRGBO(
                                            248, 150, 30, 0.7)
                                        : weed_pollen_risk == 'Alto'
                                            ? Color.fromRGBO(
                                                249, 65, 68, 0.7)
                                            : weed_pollen_risk ==
                                                    'Muy Alto'
                                                ? Color.fromRGBO(
                                                    206, 48, 255, 0.7)
                                                : Color.fromRGBO(
                                                    144, 190, 109, 0.7))),
                            Text('Otras hierbas',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                'Riesgo leve para personas con problemas respiratorios graves. Sin riesgo para el público en general',
                                style: TextStyle(
                                    color: Color.fromRGBO(
                                        144, 190, 109, 0.7)),
                              )),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Riesgo para personas con problemas respiratorios graves. Riesgo leve para el público en general',
                                style: TextStyle(
                                    color: Color.fromRGBO(
                                        248, 150, 30, 0.7)),
                              )),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Arriesgado para todos los grupos de personas',
                                style: TextStyle(
                                    color:
                                        Color.fromRGBO(249, 65, 68, 0.7)),
                              )),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'De alto riesgo para todos los grupos de personas',
                                style: TextStyle(
                                    color: Color.fromRGBO(
                                        206, 48, 255, 0.7)),
                              )),
                        ],
                      )),
                ]),
              ),
            ))
      ]),
    );
  }
}