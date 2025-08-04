import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Generic GET Request
  static Future<dynamic> getRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("API Error: $e");
    }
  }

  // Generic POST Request
  static Future<T> postRequest1<T>(String url, Map<String, dynamic> body,
      T Function(Map<String, dynamic>) fromJson) async {
    // try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Access-Control_Allow_Origin": "*"
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return fromJson(jsonData);
    } else {
      throw Exception('Failed to load data');
    }
    // } catch (e) {
    //   throw Exception('API Error: $e');
    // }
  }
}
