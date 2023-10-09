import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';



class PlanetsListPage extends StatelessWidget {
  List<Planet> planets = [];
  final String apiUrl =
      'https://api.le-systeme-solaire.net/rest/bodies?filter%5B%5D=isPlanet,neq,false&data=%20id%2Cname%2CenglishName%2CdiscoveredBy%2CdiscoveryDate%2CsemimajorAxis%2Cmass%2Cdiameter%2Cgravity%2Cescape%2CmeanRadius%2Cperihelion%2Caphelion%2Cinclination%2CdiscoveredBy%2CdiscoveryDate%2CisPlanet%2Cmoons%2CaroundPlanet%2CaxialTilt%2Cdensity%2CavgTemp';

  Future<List<Planet>> _getPlanets() async {
    final response = await http.get(Uri.parse(apiUrl));
    final decodedJson = jsonDecode(response.body)['bodies'];

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
        child: FutureBuilder(
          future: _getPlanets(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Planet>> snapshot) {
            if (snapshot.hasData) {
              List<Planet> planets = snapshot.data!;

              return Container(
                height: 250.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(678),
                  ),
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      // set options such as auto play, enable infinite scroll, etc.
                      autoPlay: false,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      initialPage: 2,
                      enableInfiniteScroll: true,
                      autoPlayInterval: Duration(seconds: 5),
                      viewportFraction: 0.4,
                    ),
                    itemCount: planets.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlanetDetailsPage(planet: planets[index]),
                              ),
                            );
                          },
                          child: Container(
                              child: ListView(
                                children: <Widget>[
                                  
                                  Container(
                                    height: 145,
                                    decoration:BoxDecoration(borderRadius: BorderRadius.circular(200), image:  DecorationImage(
                                        image: AssetImage(
                                            "assets/images/${planets[index].englishName.toLowerCase().replaceAll(' ', '')}.jpg"),
                                        fit: BoxFit.cover,
                                      ),),
                                      child: Text(
                                        planets[index].name,
                                        style: TextStyle(
                                          
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                                      ),
                                    
                                  ),
                                ],
                              
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error} on ${snapshot.data}');
            }
            return CircularProgressIndicator();
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
                  image: AssetImage(
                      "assets/images/${planet.englishName.toLowerCase()}.jpg"),
                  fit: BoxFit.cover,
                ),
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

Future<List<Planet>> fetchPlanets() async {
  final response = await http.get(Uri.https(
      'api.le-systeme-solaire.net', '/rest/bodies/', {'filter[]': 'isPlanet'}));

  if (response.statusCode == 200) {
    final List<dynamic> planetsList = json.decode(response.body)['bodies'];

    return planetsList.map((json) => Planet.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch planets');
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


  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
  ];

  Color _getRandomColor() {
    final random = Random();
    return _colors[random.nextInt(_colors.length)];
  }

class PlanetCard extends StatelessWidget {
  final Planet planet;

  const PlanetCard({required this.planet});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanetDetails(planet: planet),
          ),
        );
      },
      child: Container(
        color: _getRandomColor(),
        margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        width: 200.0,
        child: Card(
          color: _getRandomColor(),
          elevation: 0,
          child: ListView(
            children: <Widget>[
              Container(
                height: 150.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/${planet.englishName}'),
                )),
              ),
              SizedBox(height: 8.0),
              Text(
                planet.englishName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                planet.englishName,
                style: TextStyle(fontSize: 16.0,color: _getRandomColor()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanetsList extends StatelessWidget {
  final List<Planet> planets;

  const PlanetsList({required this.planets});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: planets.length,
        itemBuilder: (context, index) {
          final planet = planets[index];
          return PlanetCard(planet: planet);
        },
      ),
    );
  }
}

class PlanetsCarousel extends StatefulWidget {
  const PlanetsCarousel();

  @override
  _PlanetsCarouselState createState() => _PlanetsCarouselState();
}

class _PlanetsCarouselState extends State<PlanetsCarousel> {
  late Future<List<Planet>> _planetsFuture;

  @override
  void initState() {
    super.initState();
    _planetsFuture = fetchPlanets();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Planet>>(
      future: _planetsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: 250.0,
            child: CarouselSlider.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index, realIndex) {
                final planet = snapshot.data![index];
                return PlanetCard(planet: planet);
              },
              options: CarouselOptions(
                height: 250.0,
                viewportFraction: 0.7,
                enlargeCenterPage: true,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class PlanetDetails extends StatelessWidget {
  final Planet planet;

  const PlanetDetails({required this.planet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planet.englishName),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Container(
              height: 200.0,
              child: Image.asset(
                "assets/images/${planet.englishName.toLowerCase()}.jpg",
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              "Name: ${planet.name}",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 8.0),
            Text(
              "English Name: ${planet.englishName}",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              "Mass: ${planet.mass} kg",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              "Diameter: ${planet.diameter} km",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              "Gravity: ${planet.gravity} m/s²",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            SizedBox(height: 8.0),
            Text(
              "Mean Radius: ${planet.meanRadius} km",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
