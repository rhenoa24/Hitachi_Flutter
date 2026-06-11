import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/social.dart';
import '../widgets/page_header.dart';

class SocialCardPage extends StatelessWidget {
  final Social social;

  const SocialCardPage({Key? key, required this.social}) : super(key: key);

  Color _getThemeColor() {
    switch (social.name.toLowerCase()) {
      case 'youtube':
        return AppColors.primaryRed;
      case 'spotify':
        return AppColors.primaryGreen;
      case 'facebook':
        return AppColors.primaryBlue;
      default:
        return AppColors.textPrimary;
    }
  }

  void _openViewer(BuildContext context) {
    Navigator.of(context).pushNamed('/social-viewer', arguments: social);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header sits outside SafeArea so it colors the status bar area too
          Container(
            color: themeColor,
            child: Padding(
              padding: EdgeInsets.only(
                top:
                    MediaQuery.of(context).padding.top *
                    0.6, // adjust multiplier (0–1)
              ),
              child: PageHeader(
                onBackPressed: () => Navigator.pop(context),
                title: social.name,
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          // Rest of content wrapped in SafeArea (sides + bottom only)
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image reaches full width
                    Image.network(
                      social.imgUrl,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 300,
                          color: AppColors.bgGray,
                          child: const Center(
                            child: Text('Image not available'),
                          ),
                        );
                      },
                    ),
                    // Only text and button get padding
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            social.history,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => _openViewer(context),
                              child: Text(
                                'Visit ${social.name}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
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
