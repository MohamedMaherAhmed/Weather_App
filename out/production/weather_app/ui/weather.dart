import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/utils/util.dart';

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();

}

class _WeatherState  extends State<Weather> {

  String cityUpdate = defaultCity;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => ChangeCity()));

    if(results != null && results.containsKey('enter')){
      cityUpdate = results['enter'];

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => _goToNextScreen(context)),
          IconButton(
              icon: Icon(Icons.cached),
              onPressed: () => setState((){})),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              "images/umbrella.jpg",
              width: 490,
              height: 800,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(35, 300, 0, 0),
            child: updateTempWidget("$cityUpdate"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 200, top: 10),
            child: Text(
              "$cityUpdate",
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Map> getWeather(String apiID, String city) async {

  var apiURL = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiID&units=metric");

  http.Response response = await http.get(apiURL);

  return json.decode(response.body);
}

Widget updateTempWidget(String city) {
  return FutureBuilder(
      future: getWeather("$apiID", "$city"),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "${content['main']['temp'].toString()}°C",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Humidity: ${content['main']['humidity'].toString()}°C",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Temp Min: ${content['main']['temp_min'].toString()}°C",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Temp Max: ${content['main']['temp_max'].toString()}°C",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        } else {
          return new Container();
        }
      });
}

class ChangeCity extends StatelessWidget {
  final TextEditingController _cityFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change City"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              "images/b917a57a1daf25f5e2512f4a090f136e.png",
              width: 400,
              height: 600,
              fit: BoxFit.fill,
            ),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  controller: _cityFieldController,
                  decoration: InputDecoration(
                      labelText: "Enter City",
                      fillColor: Colors.white,
                      filled: true),
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: TextButton(
                  onPressed: () {
                    Navigator.pop(
                        context, {'enter': _cityFieldController.text});
                  },
                  style: TextButton.styleFrom(primary: Colors.black54) ,
                  child: Text(
                    "Get Weather",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
