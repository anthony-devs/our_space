import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:our_space/ExoPlanets.dart';
import 'package:our_space/MilkyWay.dart';
import 'package:our_space/MoonPage.dart';
import 'package:our_space/PlanetsPage.dart';

final String apiUrl = 'https://api.le-systeme-solaire.net/rest/bodies';

Future<void> fetchData() async {
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    print(jsonData);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'image': 'assets/images/milkyway.jpg',
        'label': 'The Stars',
        'widget': MilkyWay(),
      },
      {
        'image': 'assets/images/moon.jpg',
        'label': 'Moons',
        'widget': MoonsListPage(),
      },
      {
        'image': 'assets/images/exoplanets.jpg',
        'label': 'Exoplanets',
        'widget': ExoplanetList(),
      },
    ];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 29, 29),
      body: ListView(
        children: [
          PlanetsListPage(),
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.7),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => item['widget']),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: 145,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            image: DecorationImage(
                              image: AssetImage(item['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(200),
                                bottomRight: Radius.circular(200)),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            item['label'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
