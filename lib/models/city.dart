class City {
  final String name;

  City({this.name});

  static City fromJson(Map json) {
    return City(
      name: json['name'],
    );
  }

  @override
  String toString() {
    return 'Instance of City: $name';
  }
}
