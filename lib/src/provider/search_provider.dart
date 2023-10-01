import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/util/constants.dart';
import '../model/data_model.dart';

class SearchProvider with ChangeNotifier {
  List<DataModel>? _response;

  // Adding a variable to track if data is fetched.
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<DataModel>? get response {
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
      final parsed = jsonDecode(response.body)['results'];
      List<DataModel> noth = dataModelFromJson(parsed);

      _response = noth;
    } else {
      log('API request failed with status code ${response.statusCode}');
    }
    _isLoading = false;
    notifyListeners();
  }
}
