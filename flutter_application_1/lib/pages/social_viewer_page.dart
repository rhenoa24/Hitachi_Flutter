import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../models/social.dart';

class SocialViewerPage extends StatelessWidget {
  final Social social;

  const SocialViewerPage({
    Key? key,
    required this.social,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(social.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Opening ${social.name}...',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse(social.webUrl))) {
                  await launchUrl(Uri.parse(social.webUrl));
                }
              },
              child: const Text('Visit Website'),
            ),
          ],
        ),
      ),
    );
  }
}
