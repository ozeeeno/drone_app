import 'package:http/http.dart' as http;

// Import the CalculationData class

class RESTService {
  static Future<Object> sendData(String illuminance, String area) async {
    try {
      final url = Uri.parse(
          'https://drone-app-2.vercel.app/calculation?illuminance=$illuminance&area=$area');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        return response;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
