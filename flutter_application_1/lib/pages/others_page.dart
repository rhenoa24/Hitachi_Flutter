import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../models/brand.dart';
import '../services/social_service.dart';
import '../widgets/page_header.dart';

class OthersPage extends StatefulWidget {
  const OthersPage({Key? key}) : super(key: key);

  @override
  State<OthersPage> createState() => _OthersPageState();
}

class _OthersPageState extends State<OthersPage> {
  late List<Brand> _brands;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  void _loadBrands() async {
    final socialService = Provider.of<SocialService>(context, listen: false);
    final brands = await socialService.getBrands();
    setState(() {
      _brands = brands;
      _isLoading = false;
    });
  }

  void _prev() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _brands.length) % _brands.length;
    });
  }

  void _next() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _brands.length;
    });
  }

  void _goTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _visitWebsite() async {
    final brand = _brands[_currentIndex];
    if (await canLaunchUrl(Uri.parse(brand.webUrl))) {
      await launchUrl(Uri.parse(brand.webUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentBrand = _brands[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PageHeader(
              onBackPressed: () => Navigator.pop(context),
              title: 'Others',
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'You might also like',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Carousel
                  SizedBox(
                    height: 250,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: _prev,
                          iconSize: 32,
                        ),
                        Expanded(
                          child: Center(
                            child: Image.network(
                              currentBrand.logoUrl,
                              height: 200,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.bgGray,
                                  child: Center(
                                    child: Text(currentBrand.name),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _next,
                          iconSize: 32,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentBrand.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _visitWebsite,
                      child: Text(
                        'Visit ${currentBrand.name} Website',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _brands.length,
                      (index) => GestureDetector(
                        onTap: () => _goTo(index),
                        child: Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentIndex
                                ? AppColors.primaryGreen
                                : AppColors.borderGray,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
