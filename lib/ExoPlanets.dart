import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const API_BASE_URL = 'https://api.stellarium.org';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exoplanets App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExoplanetList(),
    );
  }
}

class Exoplanet {
  final String name;
  final double mass;
  final double radius;
  final int temperature;
  final double distance;

  Exoplanet({
    required this.name,
    required this.mass,
    required this.radius,
    required this.temperature,
    required this.distance,
  });

  factory Exoplanet.fromJson(Map<String, dynamic> json) {
    return Exoplanet(
      name: json['name'],
      mass: json['mass'] is double ? json['mass'] : json['mass'].toDouble(),
      radius: json['radius'] is double ? json['radius'] : json['radius'].toDouble(),
      temperature: json['temperature'],
      distance: json['distance'],
    );
  }
}

class ExoplanetList extends StatefulWidget {
  @override
  _ExoplanetListState createState() => _ExoplanetListState();
}

class _ExoplanetListState extends State<ExoplanetList> {
  late List<Exoplanet> exoplanets;

  @override
  void initState() {
    super.initState();
    fetchExoplanets();
  }

  void fetchExoplanets() async {
    final response = await http.get(Uri.parse('$API_BASE_URL/exoplanets?limit=50'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final exoplanets = data.map((json) => Exoplanet.fromJson(json)).toList();
      setState(() {
        this.exoplanets = exoplanets;
      });
    } else {
      throw Exception('Failed to fetch exoplanets');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (exoplanets == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Exoplanets'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Exoplanets'),
        ),
        body: ListView.builder(
          itemCount: exoplanets.length,
          itemBuilder: (context, index) {
            final exoplanet = exoplanets[index];
            return ListTile(
              title: Text(exoplanet.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExoplanetDetails(exoplanet),
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }
}

class ExoplanetDetails extends StatelessWidget {
  final Exoplanet exoplanet;

  ExoplanetDetails(this.exoplanet);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exoplanet.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${exoplanet.name}'),
            SizedBox(height: 8.0),
            Text('Mass: ${exoplanet.mass} Earth masses'),
            SizedBox(height: 8.0),
            Text('Radius:${exoplanet.radius} Earth radii'),
SizedBox(height: 8.0),
Text('Temperature: ${exoplanet.temperature} K'),
SizedBox(height: 8.0),
Text('Distance: ${exoplanet.distance} pc'),
],
),
),
);
}
}

