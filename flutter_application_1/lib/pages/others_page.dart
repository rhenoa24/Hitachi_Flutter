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
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  @override
  void dispose() {
    _stopAutoplay();
    _pageController?.dispose();
    super.dispose();
  }

  void _startAutoplay() {
    _autoplayTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted && (_pageController?.hasClients ?? false)) {
        _pageController!.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
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
    _pageController = PageController(
      viewportFraction: 0.78,
      initialPage: brands.length * 500,
    );
    setState(() {
      _brands = brands;
      _isLoading = false;
    });
    _startAutoplay();
  }

  void _prev() {
    _pageController?.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _resetAutoplay();
  }

  void _next() {
    _pageController?.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _resetAutoplay();
  }

  void _goTo(int index) {
    if (_pageController == null || !_pageController!.hasClients) return;
    final currentPage = _pageController!.page!.round();
    final currentInLoop = currentPage % _brands.length;
    int diff = index - currentInLoop;
    if (diff > _brands.length / 2) diff -= _brands.length;
    if (diff < -(_brands.length / 2)) diff += _brands.length;
    _pageController!.animateToPage(
      currentPage + diff,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentIndex = index);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child: Text(
                        'You might also like',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Carousel — no horizontal padding
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 260,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index % _brands.length;
                              });
                            },
                            itemBuilder: (context, index) {
                              final brand = _brands[index % _brands.length];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.10),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(24),
                                  child: Image.asset(
                                    brand.logoUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Center(child: Text(brand.name)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    // Rest of content back inside padding
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
