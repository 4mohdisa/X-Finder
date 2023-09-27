import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const SearchApp());

class SearchApp extends StatelessWidget {
  const SearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String output = '';
  bool isLoading = false;

  Future<void> search() async {
    try {
      log('DATALOGGING: 0');
      // const apiUrl = 'http://0.0.0.0:8000/cli/';
      const apiUrl = 'http://67.219.97.234:8000/cli/';
      setState(() {
        isLoading = true;
      });

      final Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      final Map<String, String> requestBody = {
        "args": searchController.text,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(requestBody),
      );
      log('DATALOGGING: 1');
      log('DATALOGGING: ${response.statusCode}');

      log('DATALOGGING: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Get the output from the API response.
        final output = data['output'];

        setState(() {
          this.output = output;
          isLoading = false;
        });
      } else {
        log('API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      log('Error searching: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search App'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 320,
                      child: TextField(
                        controller: searchController,
                        decoration:
                            const InputDecoration(labelText: 'Search by Name'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        search();
                      },
                      child: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              Container(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                        child: Text(output),
                      ),
              ),
            ],
          ),
        ));
  }
}
