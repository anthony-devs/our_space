import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
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
    print(jsonData); // Do something with the data
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String rsp;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 29, 29),
        body: ListView(
      children: [
        PlanetsListPage(),
        CarouselSlider(
            items: [
              Container(
                width: 145,
                height: 145,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MilkyWay(),
                              ),
                            );
                          },
                          child: Container(
                              child: ListView(
                                children: <Widget>[
                                  
                                  Container(
                                    height: 145,
                                    width: 145,
                                    decoration:BoxDecoration(borderRadius: BorderRadius.circular(200), image:  DecorationImage(
                                        image: AssetImage(
                                            "assets/images/milkyway.jpg"),
                                        fit: BoxFit.cover,
                                      ),),
                                      child: Text(
                                        'The Stars',
                                        style: TextStyle(
                                          
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                                      ),
                                    
                                  ),
                                ],
                              
                            ),
                          ),
                        ),
                      ),
              Container(
                width: 145,
                height: 145,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MoonsListPage(),
                              ),
                            );
                          },
                          child: Container(
                              child: ListView(
                                children: <Widget>[
                                  
                                  Container(
                                    height: 145,
                                    width: 145,
                                    decoration:BoxDecoration(borderRadius: BorderRadius.circular(200), image:  DecorationImage(
                                        image: AssetImage(
                                            "assets/images/moon.jpg"),
                                        fit: BoxFit.cover,
                                      ),),
                                      child: Text(
                                        'Moons',
                                        style: TextStyle(
                                          
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                                      ),
                                    
                                  ),
                                ],
                              
                            ),
                          ),
                        ),
                      ),


              Container(
                width: 145,
                height: 145,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ExoplanetList(),
                              ),
                            );
                          },
                          child: Container(
                              child: ListView(
                                children: <Widget>[
                                  
                                  Container(
                                    height: 145,
                                    width: 145,
                                    decoration:BoxDecoration(borderRadius: BorderRadius.circular(200), image:  DecorationImage(
                                        image: AssetImage(
                                            "assets/images/exoplanets.jpg"),
                                        fit: BoxFit.cover,
                                      ),),
                                      child: Text(
                                        'Exoplanets',
                                        style: TextStyle(
                                          
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                                      ),
                                    
                                  ),
                                ],
                              
                            ),
                          ),
                        ),
                      ),
            ],
            options: CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              initialPage: 1,
              enableInfiniteScroll: true,
              autoPlayInterval: Duration(seconds: 5),
              viewportFraction: 0.8,
            ))
      ],
    ));
  }
}
