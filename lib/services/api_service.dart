import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/models/farmer.dart';

class ApiService {
  static const baseUrl = 'http://192.168.68.130:8000';

  static Future<Map<String, dynamic>> checkEligibility(
    Farmer farmer,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/eligibility'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': farmer.name,
        'land_size': farmer.landSize,
        'land_unit': farmer.landUnit,
        'crop_type': farmer.sowingCrop,
        'past_yield': farmer.pastYield,
        'income_bracket': farmer.incomeBracket,
        'income': farmer.income,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Eligibility request failed');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}