import 'package:flutter/material.dart';
import '../constants/colors.dart';

class OthersButton extends StatelessWidget {
  final VoidCallback onTap;

  const OthersButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryYellow,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.exit_to_app, color: Colors.white, size: 100),
        ),
      ),
    );
  }
}
