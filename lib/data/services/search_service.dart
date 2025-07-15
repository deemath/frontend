import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchService {
  static const String baseUrl = 'http://localhost:3000/search';

  Future<Map<String, dynamic>> search(String query) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$query'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load search results');
    }
  }
}