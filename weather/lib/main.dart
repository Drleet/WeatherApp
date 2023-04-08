import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  String key = '302696fea5f9baf392e3bc9f7ae3011a';
  String city = 'Agadir';
  final textcontroller = TextEditingController();

  Future getWeather(String city) async {
    http.Response response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=${city}&units=metric&appid=${key}"));
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather(city);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Weather App"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 108, 162, 255),
          elevation: 0,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: textcontroller,
                  )),
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      onPressed: () => getWeather(textcontroller.text),
                      icon: Icon(Icons.search_rounded)),
                ],
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              height: 200,
              width: 400,
              color: Color.fromARGB(255, 108, 162, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Currently in ${textcontroller.text}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    temp != null ? temp.toString() + "\u00B0C" : "Loading",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    currently != null ? currently.toString() : "Loading",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.thermostat_outlined),
                      title: Text("Temperature"),
                      trailing: Text(temp != null
                          ? temp.toString() + " \u00B0C"
                          : "Loading"),
                    ),
                    ListTile(
                      leading: Icon(Icons.cloud_outlined),
                      title: Text("Weather"),
                      trailing: Text(description != null
                          ? description.toString()
                          : "Loading"),
                    ),
                    ListTile(
                      leading: Icon(Icons.opacity_outlined),
                      title: Text("Humidity"),
                      trailing: Text(
                          humidity != null ? humidity.toString() : "Loading"),
                    ),
                    ListTile(
                      leading: Icon(Icons.air_outlined),
                      title: Text("Wind Speed"),
                      trailing: Text(
                          windSpeed != null ? windSpeed.toString() : "Loading"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
