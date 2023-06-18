import 'secrets.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  final TextEditingController city1Controller = TextEditingController();
  final TextEditingController city2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Choose Cities'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose two cities',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            CityInputField(label: 'City 1', controller: city1Controller),
            SizedBox(height: 16),
            CityInputField(label: 'City 2', controller: city2Controller),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                  Fluttertoast.showToast(
                    msg: 'Hejsan',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
              child: Text('See where it snows the most'),
            ),
          ],
        ),
      ),
    );
  }
}

class CityInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller; // Add the controller parameter

  const CityInputField({Key? key, required this.label, required this.controller}) : super(key: key);

  @override
  _CityInputFieldState createState() => _CityInputFieldState();
}


class _CityInputFieldState extends State<CityInputField> {
  

  List<String> suggestions = [];
  List<String> placeIds = [];
  Map<String, dynamic> coordinates = {}; // Map to store city coordinates

  void _fetchSuggestions(String input) async {
    final endpoint = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final sessionToken = DateTime.now().millisecondsSinceEpoch.toString();

    final url = Uri.parse('$endpoint?input=$input&key=$apiKey&sessiontoken=$sessionToken');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final predictions = data['predictions'];
      setState(() {
        suggestions = predictions.map<String>((prediction) => prediction['description'] as String).toList();
        placeIds = predictions.map<String>((prediction) => prediction['place_id'] as String).toList();
        coordinates = {}; // Clear the coordinates map when suggestions change
      });
    }
  }

  void _fetchCoordinates(String placeId) async {
  final endpoint = 'https://maps.googleapis.com/maps/api/place/details/json';
  final sessionToken = DateTime.now().millisecondsSinceEpoch.toString();

  final url = Uri.parse('$endpoint?place_id=$placeId&key=$apiKey&sessiontoken=$sessionToken');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status'] == 'OK') {
      final result = data['result'];
      if (result != null && result.containsKey('geometry')) {
        final location = result['geometry']['location'];
        if (location != null && location.containsKey('lat') && location.containsKey('lng')) {
          final lat = location['lat'];
          final lng = location['lng'];

          final city = widget.controller.text;
          setState(() {
            coordinates[city] = {'lat': lat, 'lng': lng};
          });
        }
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: widget.label,
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              _fetchSuggestions(value);
            },
            onSubmitted: (value) {
              // Do something with the selected city and its coordinates
            },
          ),
        ),
        Container(
          constraints: BoxConstraints(maxHeight: 100),
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(suggestions[index]),
                onTap: () {
                  final city = suggestions[index];
                  widget.controller.text = city;
                  _fetchCoordinates(placeIds[index]);
                  setState(() {
                    suggestions.clear();
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
