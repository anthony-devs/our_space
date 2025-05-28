import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlanetsListPage extends StatefulWidget {
  @override
  _PlanetsListPageState createState() => _PlanetsListPageState();
}

class _PlanetsListPageState extends State<PlanetsListPage> {
  final String apiUrl =
      'https://api.le-systeme-solaire.net/rest/bodies?filter%5B%5D=isPlanet,neq,false&data=%20id%2Cname%2CenglishName%2CdiscoveredBy%2CdiscoveryDate%2CsemimajorAxis%2Cmass%2Cdiameter%2Cgravity%2Cescape%2CmeanRadius%2Cperihelion%2Caphelion%2Cinclination%2CdiscoveredBy%2CdiscoveryDate%2CisPlanet%2Cmoons%2CaroundPlanet%2CaxialTilt%2Cdensity%2CavgTemp';

  late Future<List<Planet>> _planetsFuture;

  @override
  void initState() {
    super.initState();
    _planetsFuture = _getPlanets();
  }

  Future<List<Planet>> _getPlanets() async {
    final response = await http.get(Uri.parse(apiUrl));
    final decodedJson = jsonDecode(response.body)['bodies'];

    List<Planet> planets = [];
    for (var planetJson in decodedJson) {
      if (planetJson['isPlanet']) {
        planets.add(Planet.fromJson(planetJson));
      }
    }

    return planets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 29, 29, 29),
      child: Center(
        child: FutureBuilder<List<Planet>>(
          future: _planetsFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<Planet>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}',
                  style: TextStyle(color: Colors.red));
            } else if (snapshot.hasData) {
              List<Planet> planets = snapshot.data!;

              return SizedBox(
                height: 220.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: planets.length,
                  itemBuilder: (context, index) {
                    final planet = planets[index];
                    final imagePath =
                        "assets/images/${planet.englishName.toLowerCase().replaceAll(' ', '')}.jpg";
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlanetDetailsPage(planet: planet),
                          ),
                        );
                      },
                      child: Container(
                        width: 160,
                        margin: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 120,
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey,
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                planet.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Text('No data found',
                  style: TextStyle(color: Colors.white));
            }
          },
        ),
      ),
    );
  }
}

class PlanetDetailsPage extends StatelessWidget {
  final Planet planet;

  PlanetDetailsPage({required this.planet});

  @override
  Widget build(BuildContext context) {
    final imagePath =
        "assets/images/${planet.englishName.toLowerCase().replaceAll(' ', '')}.jpg";

    return Scaffold(
      appBar: AppBar(
        title: Text('${planet.name} Details'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: Icon(Icons.broken_image, size: 48),
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Name: ${planet.name}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text('English Name: ${planet.englishName}'),
            SizedBox(height: 10.0),
            Text('Discovered By: ${planet.discoveredBy}'),
            SizedBox(height: 10.0),
            Text('Discovery Date: ${planet.discoveryDate}'),
            SizedBox(height: 10.0),
            Text('Mass: ${planet.mass} kg'),
            SizedBox(height: 10.0),
            Text('Diameter: ${planet.diameter} km'),
            SizedBox(height: 10.0),
            Text('Mean Radius: ${planet.meanRadius} km'),
            SizedBox(height: 10.0),
            Text('Gravity: ${planet.gravity} m/s²'),
            SizedBox(height: 10.0),
            Text('Density: ${planet.density} g/cm³'),
            SizedBox(height: 10.0),
            Text('Average Temperature: ${planet.avgTemp} K'),
          ],
        ),
      ),
    );
  }
}

class Planet {
  final String name;
  final String englishName;
  final String discoveredBy;
  final String discoveryDate;
  final String semimajorAxis;
  final String mass;
  final String diameter;
  final String gravity;
  final String meanRadius;
  final String density;
  final String avgTemp;

  Planet({
    required this.name,
    required this.englishName,
    required this.discoveredBy,
    required this.discoveryDate,
    required this.semimajorAxis,
    required this.mass,
    required this.diameter,
    required this.gravity,
    required this.meanRadius,
    required this.density,
    required this.avgTemp,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: json['name'].toString(),
      englishName: json['englishName'].toString(),
      discoveredBy: json['discoveredBy'].toString(),
      discoveryDate: json['discoveryDate'].toString(),
      semimajorAxis: json['semimajorAxis'].toString(),
      mass: json['mass'].toString(),
      diameter: json['meanRadius'].toString(),
      gravity: json['gravity'].toString(),
      meanRadius: json['meanRadius'].toString(),
      density: json['density'].toString(),
      avgTemp: json['avgTemp'].toString(),
    );
  }
}
