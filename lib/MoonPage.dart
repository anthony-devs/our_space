import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Moon {
  final String name;
  final String diameter;
  final String mass;
  final String gravity;
  final String avgTemp;
  final String discoveryDate;
  final String discoveredBy;

  Moon({
    required this.name,
    required this.diameter,
    required this.mass,
    required this.gravity,
    required this.avgTemp,
    required this.discoveryDate,
    required this.discoveredBy,
  });

  factory Moon.fromJson(Map<String, dynamic> json) {
    return Moon(
      name: json['englishName'] ?? '',
      diameter: json['diameter'] != null ? '${json['diameter']} km' : 'Unknown',
      mass:
          json.containsKey('massvalue') ? '${json['massvalue']} kg' : 'Unknown',
      gravity:
          json.containsKey('gravity') ? '${json['gravity']} m/s²' : 'Unknown',
      avgTemp: json.containsKey('avgTemp') ? '${json['avgTemp']} K' : 'Unknown',
      discoveryDate: json['discoveryDate'] ?? 'Unknown',
      discoveredBy: json['discoveredBy'] ?? 'Unknown',
    );
  }
}

class MoonsListPage extends StatefulWidget {
  @override
  _MoonsListPageState createState() => _MoonsListPageState();
}

class _MoonsListPageState extends State<MoonsListPage> {
  late Future<List<Moon>> futureMoons;

  @override
  void initState() {
    super.initState();
    futureMoons = fetchMoons();
  }

  Future<List<Moon>> fetchMoons() async {
    final response = await http.get(Uri.https(
        'api.le-systeme-solaire.net', '/rest/bodies/', {'filter[]': 'isMoon'}));

    if (response.statusCode == 200) {
      final List<dynamic> moonsJson = json.decode(response.body)['bodies'];
      return moonsJson.map((json) => Moon.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load moons');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moons List'),
      ),
      body: Center(
        child: FutureBuilder<List<Moon>>(
          future: futureMoons,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final moons = snapshot.data!;
              return ListView.builder(
                itemCount: moons.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(moons[index].name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MoonDetailsPage(moon: moons[index]),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class MoonDetailsPage extends StatelessWidget {
  final Moon moon;

  MoonDetailsPage({required this.moon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(moon.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Diameter: ${moon.diameter}'),
            Text('Mass: ${moon.mass}'),
            Text('Gravity: ${moon.gravity}'),
            Text('Average Temperature: ${moon.avgTemp}'),
            Text('Discovery Date: ${moon.discoveryDate}'),
            Text('Discovered By: ${moon.discoveredBy}'),
          ],
        ),
      ),
    );
  }
}
