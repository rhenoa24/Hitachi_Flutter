import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          PageHeader(
            onBackPressed: () => Navigator.pop(context),
            title: widget.social.name,
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
