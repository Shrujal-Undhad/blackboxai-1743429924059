import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AIService {
  static const String _baseUrl = 'https://api.example-ai.com/v1';
  String? _apiKey;

  void setApiKey(String key) {
    _apiKey = key;
  }

  Future<Uint8List> removeBackground(Uint8List imageBytes) async {
    if (_apiKey == null) throw Exception('API key not set');
    
    final uri = Uri.parse('$_baseUrl/remove-background');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $_apiKey'
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'image.png',
      ));

    final response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.toBytes();
    } else {
      throw Exception('Failed to remove background: ${response.statusCode}');
    }
  }

  Future<Uint8List> applyStyleTransfer(
    Uint8List imageBytes,
    String style,
  ) async {
    if (_apiKey == null) throw Exception('API key not set');

    final uri = Uri.parse('$_baseUrl/style-transfer');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $_apiKey'
      ..fields['style'] = style
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'image.png',
      ));

    final response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.toBytes();
    } else {
      throw Exception('Failed to apply style: ${response.statusCode}');
    }
  }

  Future<Uint8List> enhanceImage(Uint8List imageBytes) async {
    if (_apiKey == null) throw Exception('API key not set');

    final uri = Uri.parse('$_baseUrl/enhance');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $_apiKey'
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'image.png',
      ));

    final response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.toBytes();
    } else {
      throw Exception('Failed to enhance image: ${response.statusCode}');
    }
  }

  Future<Uint8List> upscaleImage(Uint8List imageBytes) async {
    if (_apiKey == null) throw Exception('API key not set');

    final uri = Uri.parse('$_baseUrl/upscale');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $_apiKey'
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'image.png',
      ));

    final response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.toBytes();
    } else {
      throw Exception('Failed to upscale image: ${response.statusCode}');
    }
  }
}