import 'dart:async';
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
  Timer? _autoplayTimer;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  @override
  void dispose() {
    _stopAutoplay();
    super.dispose();
  }

  void _startAutoplay() {
    _autoplayTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _brands.length;
        });
      }
    });
  }

  void _stopAutoplay() {
    _autoplayTimer?.cancel();
    _autoplayTimer = null;
  }

  void _resetAutoplay() {
    _stopAutoplay();
    _startAutoplay();
  }

  void _loadBrands() async {
    final socialService = Provider.of<SocialService>(context, listen: false);
    final brands = await socialService.getBrands();
    setState(() {
      _brands = brands;
      _isLoading = false;
    });
    _startAutoplay();
  }

  void _prev() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _brands.length) % _brands.length;
    });
    _resetAutoplay();
  }

  void _next() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _brands.length;
    });
    _resetAutoplay();
  }

  void _goTo(int index) {
    setState(() {
      _currentIndex = index;
    });
    _resetAutoplay();
  }

  void _visitWebsite() async {
    final brand = _brands[_currentIndex];
    final uri = Uri.parse(brand.webUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open ${brand.name} website')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentBrand = _brands[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: AppColors.primaryYellow,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top * 0.6,
              ),
              child: PageHeader(
                onBackPressed: () => Navigator.pop(context),
                title: 'Others',
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'You might also like',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
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
                                child: Image.asset(
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
                            backgroundColor: AppColors.primaryYellow,
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
                                    ? AppColors.primaryYellow
                                    : AppColors.borderGray,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
