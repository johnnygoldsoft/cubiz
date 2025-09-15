import 'dart:convert';
import 'package:cubiz/models/provider_detail.dart';
import 'package:http/http.dart' as http;
import '../core/config.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> getList(String path) async {
    final uri = Uri.parse('${AppConfig.baseUrl}$path');
    final resp = await client.get(uri).timeout(Duration(seconds: 15));
    if (resp.statusCode == 200) {
      final decoded = json.decode(resp.body);
      if (decoded is List) return List<Map<String, dynamic>>.from(decoded);
      // si API enveloppe: { data: [...] }
      if (decoded is Map && decoded['data'] is List) {
        return List<Map<String, dynamic>>.from(decoded['data']);
      }
      throw Exception('Unexpected response format');
    } else {
      throw Exception('Error ${resp.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getItem(String path) async {
    final uri = Uri.parse('${AppConfig.baseUrl}$path');
    final resp = await client.get(uri).timeout(Duration(seconds: 15));
    if (resp.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(resp.body));
    } else {
      throw Exception('Error ${resp.statusCode}');
    }
  }

  Future<ProviderDetail> fetchProviderDetail(int providerId) async {
    final jsonData = await getItem('/providers/$providerId');
    return ProviderDetail.fromJson(jsonData);
  }
}
