import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PageHeader extends StatelessWidget {
  final VoidCallback onBackPressed;
  final String title;

  const PageHeader({
    Key? key,
    required this.onBackPressed,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackPressed,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
