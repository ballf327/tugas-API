import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(CovidApp());

class CovidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVID-19 Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CovidCountryList(),
    );
  }
}

class CovidCountryList extends StatefulWidget {
  @override
  _CovidCountryListState createState() => _CovidCountryListState();
}

class _CovidCountryListState extends State<CovidCountryList> {
  List<dynamic> _countries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchCovidData();
  }

  Future<void> fetchCovidData() async {
    final response = await http.get(Uri.parse("https://disease.sh/v3/covid-19/countries"));
    if (response.statusCode == 200) {
      setState(() {
        _countries = json.decode(response.body);
        _loading = false;
      });
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('COVID-19 Data by Country')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _countries.length,
              itemBuilder: (context, index) {
                final country = _countries[index];
                return ListTile(
                  leading: Image.network(
                    country['countryInfo']['flag'],
                    width: 40,
                    height: 40,
                  ),
                  title: Text(country['country']),
                  subtitle: Text('Cases: ${country['cases']} | Deaths: ${country['deaths']}'),
                );
              },
            ),
    );
  }
}
