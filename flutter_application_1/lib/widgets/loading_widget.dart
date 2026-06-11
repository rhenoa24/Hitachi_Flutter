import 'package:flutter/material.dart';
import '../constants/colors.dart';

class LoadingWidget extends StatelessWidget {
  final String loadingText;

  const LoadingWidget({
    Key? key,
    this.loadingText = 'Loading...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 20),
          Text(
            loadingText,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
