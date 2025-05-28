import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const API_BASE_URL = 'https://api.stellarium.org'; // Replace if needed

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
      radius:
          json['radius'] is double ? json['radius'] : json['radius'].toDouble(),
      temperature: json['temperature'],
      distance: json['distance'] is double
          ? json['distance']
          : json['distance'].toDouble(),
    );
  }
}

class ExoplanetList extends StatefulWidget {
  @override
  _ExoplanetListState createState() => _ExoplanetListState();
}

class _ExoplanetListState extends State<ExoplanetList> {
  List<Exoplanet>? exoplanets;

  @override
  void initState() {
    super.initState();
    fetchExoplanets();
  }

  void fetchExoplanets() async {
    try {
      final response =
          await http.get(Uri.parse('$API_BASE_URL/exoplanets?limit=50'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          exoplanets = data.map((json) => Exoplanet.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to fetch exoplanets');
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exoplanets'),
      ),
      body: exoplanets == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: exoplanets!.length,
              itemBuilder: (context, index) {
                final exoplanet = exoplanets![index];
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
            Text('Radius: ${exoplanet.radius} Earth radii'),
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
