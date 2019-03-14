import 'dart:convert';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const kGoogleApiKey = "AIzaSyCYovHQVIy52u4De26rse958g_-q5hdinY";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController controller;
  Map response = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Search("Koo");
    controller = new TextEditingController();
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: new TextField(
        controller: controller,
        decoration: new InputDecoration(
            //prefixIcon: new Icon(Icons.search),
            hintText: 'Search...',
            border: InputBorder.none),
      ),
      leading: new IconButton(
        icon: new Icon(Icons.search),
        onPressed: () => Search(controller.text),
      ),
    );
  }

  void Search(var SearchString) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$SearchString&types=geocode&components=country:in&key=AIzaSyCYovHQVIy52u4De26rse958g_-q5hdinY";
    response = await apiRequest(url);
    print(response["predictions"]);
    setState(() {});
  }

  Future<Map> apiRequest(String url) async {
    var response = await http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        encoding: Encoding.getByName("utf-8"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    if (response.isNotEmpty) print(response["predictions"][0]["description"]);
    return Scaffold(
      appBar: _buildBar(context),
      body: (response.isNotEmpty)
          ? ListView.builder(
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () async {
                    String str = response["predictions"][i]["description"];
                    str = str.replaceAll(" ", "+");
                    var url =
                        "https://maps.googleapis.com/maps/api/place/textsearch/json?query=${response["predictions"][i]["description"]}&key=AIzaSyCYovHQVIy52u4De26rse958g_-q5hdinY";
                    var response1 = await apiRequest(url);
                    print(response1);
                  },
                  child: Card(
                    child: Container(
                      height: 50.0,
                      child: Center(
                        child: new Text(
                          response["predictions"][i]["description"],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: response["predictions"].length,
            )
          : Container(),
    );
  }
}
