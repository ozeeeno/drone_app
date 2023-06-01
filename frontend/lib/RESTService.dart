import 'package:http/http.dart' as http;
import 'dart:convert';

import 'calculation_data.dart'; // Import the CalculationData class

class RESTService {
  static const String apiUrl = 'drone-app-vert.vercel.app';

  static Future<bool> sendData(String illuminance, String area) async {
    try {
      final uri = Uri.parse(apiUrl);
      final url = uri.replace(queryParameters: {
        'illuminance': illuminance,
        'area': area,
      });

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  static Future<CalculationData> getCalculationResult() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CalculationData.fromJson(json);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to load data');
    }
  }
}
