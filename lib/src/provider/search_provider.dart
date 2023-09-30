import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../core/util/constants.dart';

class SearchProvider with ChangeNotifier {
  String? _response;

  // Adding a variable to track if data is fetched.
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? get response {
    return _response;
  }

  Future<void> searchResponse(String query) async {
    _isLoading = true;
    log('DATALOGGING: 0');
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final Map<String, String> requestBody = {
      "args": query,
    };

    final response = await http.post(
      Uri.parse('$kBaseUrl/cli/'),
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
      _response = output;
    } else {
      log('API request failed with status code ${response.statusCode}');
    }
    _isLoading = false;
    notifyListeners();
  }
}
