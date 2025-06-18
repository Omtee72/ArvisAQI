import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AirQualityService with ChangeNotifier {
  Map<String, dynamic>? _airQualityData;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get airQualityData => _airQualityData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAirQuality(double lat, double lng) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Example using OpenAQ API
      final response = await http.get(
        Uri.parse('https://api.openaq.org/v2/latest?coordinates=$lat,$lng'),
      );

      if (response.statusCode == 200) {
        _airQualityData = json.decode(response.body);
        _error = null;
      } else {
        _error = 'Failed to load air quality data: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching air quality data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
