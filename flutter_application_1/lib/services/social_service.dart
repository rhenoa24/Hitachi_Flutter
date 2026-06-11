import 'package:flutter/foundation.dart';
import '../models/social.dart';
import '../models/brand.dart';

class SocialService extends ChangeNotifier {
  List<Social> _socials = [];
  List<Brand> _brands = [];

  List<Social> get socials => _socials;
  List<Brand> get brands => _brands;

  Future<List<Social>> getSocials() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _socials = [
        Social(
          name: 'YouTube',
          history: 'YouTube is a video sharing platform founded in 2005.',
          iconUrl: 'assets/youtube.png',
          imgUrl: 'https://via.placeholder.com/400x300?text=YouTube',
          webUrl: 'https://youtube.com',
        ),
        Social(
          name: 'Spotify',
          history: 'Spotify is a music streaming service founded in 2006.',
          iconUrl: 'assets/spotify.png',
          imgUrl: 'https://via.placeholder.com/400x300?text=Spotify',
          webUrl: 'https://spotify.com',
        ),
        Social(
          name: 'Facebook',
          history: 'Facebook is a social media platform founded in 2004.',
          iconUrl: 'assets/facebook.png',
          imgUrl: 'https://via.placeholder.com/400x300?text=Facebook',
          webUrl: 'https://facebook.com',
        ),
      ];

      notifyListeners();
      return _socials;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching socials: $e');
      }
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
