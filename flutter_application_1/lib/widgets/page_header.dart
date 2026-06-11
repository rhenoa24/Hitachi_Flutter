import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PageHeader extends StatelessWidget {
  final VoidCallback onBackPressed;
  final String title;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const PageHeader({
    Key? key,
    required this.onBackPressed,
    required this.title,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? AppColors.textPrimary;
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackPressed,
            color: fg,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
