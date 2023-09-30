import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const SearchApp());

class SearchApp extends StatelessWidget {
  const SearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'X Finder',
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
  ValueNotifier<bool> showEmptyInputMessageNotifier =
      ValueNotifier<bool>(false);
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

  void mixAndSearch() {
    final enteredName = searchController.text;
    if (enteredName.isEmpty) {
      showEmptyInputMessageNotifier.value = true;
    } else {
      showEmptyInputMessageNotifier.value = false;
      final mixedName = enteredName.replaceAll(' ', ''); // Remove spaces
      searchController.text = mixedName; // Update the text field
      search(); // Trigger the search function with the mixed name
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.7),
          title: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
              child: SvgPicture.asset(
                'assets/app_bar.svg', // Replace with your SVG icon path
                height: 30, // Adjust the height as needed
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        cursorColor: const Color(0xFF2997ff),
                        decoration: InputDecoration(
                          hintText: 'elonmusk',
                          errorText: showEmptyInputMessageNotifier.value
                              ? 'Please enter a name first'
                              : null,
                          hoverColor: const Color(0xFF2997ff),
                          labelStyle: const TextStyle(
                              fontSize: 20, color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: const Color(0xFF2997ff)),
                              borderRadius: BorderRadius.circular(20.0)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          errorBorder: showEmptyInputMessageNotifier.value
                              ? OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20.0),
                                )
                              : OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal:
                                  20.0), // Adjust the values for vertical and horizontal padding
                        ),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                        onSubmitted: (text) {
                          mixAndSearch();
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: const Color(0xFF2997ff),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 10.0),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        // search();
                        mixAndSearch();
                      },
                      child: const Icon(
                          size: 35, color: Colors.white, Icons.search),
                    ),
                  ],
                ),
              ),
              Stack(children: [
                isLoading
                    ? const SizedBox(
                        height: 600,
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                        child: Linkify(
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                          onOpen: (link) async {
                            final url = link.url;
                            await launch(url); // Directly launch the URL
                          },
                          text: output,
                          linkStyle: const TextStyle(
                            color:
                                Color(0xFF2997ff), // Set link color to #0071e3
                          ),
                        ),
                      ),
              ]),
            ],
          ),
        ));
  }
}
