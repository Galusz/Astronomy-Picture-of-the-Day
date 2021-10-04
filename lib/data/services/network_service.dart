import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';

class NetworkService {
  final baseUrl = "apodapi.herokuapp.com";
  final queryParameters = {
    'thumbs': 'true',
    'count': '20',
  };

  Future<List<dynamic>> fetchPicturesList() async {
    try {
      final response = await get(Uri.https(baseUrl, '/api/', queryParameters));
      return jsonDecode(response.body) as List;
    } catch (e) {
      print(e); //TODO: Error handling
      return [];
    }
  }

  Future<Uint8List> downloadPicture(String url) async {
    try {
      final response = await get(Uri.parse(url));
      return response.bodyBytes;
    } catch (e) {
      print(e); //TODO: Error handling
      return Uint8List(0);
    }
  }
}
