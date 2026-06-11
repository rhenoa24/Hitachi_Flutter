import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/social.dart';
import '../models/brand.dart';

class SocialService extends ChangeNotifier {
  static const _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://indexcodex.com',
  );

  List<Social> _socials = [];
  List<Brand> _brands = [];
  Future<List<Social>>? _cachedSocialsFuture;

  List<Social> get socials => _socials;
  List<Brand> get brands => _brands;

  Future<List<Social>> getSocials() {
    _cachedSocialsFuture ??= _fetchSocials();
    return _cachedSocialsFuture!;
  }

  Future<List<Social>> _fetchSocials() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/socials'),
        headers: {'CLIENT_ID': 'rgbexam'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data is List
            ? data
            : data['socials'] ?? data['data'] ?? [];
        _socials = list.map((item) => Social.fromJson(item)).toList();
        notifyListeners();
        return _socials;
      } else {
        if (kDebugMode) {
          print(
            'Failed to fetch socials: ${response.statusCode} - ${response.body}',
          );
        }
        _cachedSocialsFuture = null; // allow retry on failure
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching socials: $e');
      }
      _cachedSocialsFuture = null; // allow retry on failure
      return [];
    }
  }

  Future<List<Brand>> getBrands() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _brands = [
        Brand(
          name: 'Samsung',
          logoUrl: 'assets/samsung.png',
          webUrl: 'https://samsung.com',
        ),
        Brand(
          name: 'Apple',
          logoUrl: 'assets/apple.png',
          webUrl: 'https://apple.com',
        ),
        Brand(
          name: 'Microsoft',
          logoUrl: 'assets/windows.png',
          webUrl: 'https://microsoft.com',
        ),
      ];

      notifyListeners();
      return _brands;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching brands: $e');
      }
      return [];
    }
  }

  Social? getSocialByName(String name) {
    try {
      return _socials.firstWhere(
        (social) => social.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
