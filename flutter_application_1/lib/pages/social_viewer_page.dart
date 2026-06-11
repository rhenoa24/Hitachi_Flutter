import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/social.dart';
import '../widgets/page_header.dart';

class SocialViewerPage extends StatefulWidget {
  final Social social;

  const SocialViewerPage({Key? key, required this.social}) : super(key: key);

  @override
  State<SocialViewerPage> createState() => _SocialViewerPageState();
}

class _SocialViewerPageState extends State<SocialViewerPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  Color _getThemeColor() {
    switch (widget.social.name.toLowerCase()) {
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

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.social.webUrl));
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: themeColor,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top * 0.6,
              ),
              child: PageHeader(
                onBackPressed: () => Navigator.pop(context),
                title: widget.social.name,
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
