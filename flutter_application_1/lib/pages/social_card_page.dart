import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../models/social.dart';
import '../widgets/page_header.dart';

class SocialCardPage extends StatelessWidget {
  final Social social;

  const SocialCardPage({
    Key? key,
    required this.social,
  }) : super(key: key);

  void _openViewer() async {
    if (await canLaunchUrl(Uri.parse(social.webUrl))) {
      await launchUrl(Uri.parse(social.webUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PageHeader(
              onBackPressed: () => Navigator.pop(context),
              title: social.name,
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _openViewer,
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
    );
  }
}
