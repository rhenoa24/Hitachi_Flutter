import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PopupModal extends StatelessWidget {
  final String title;
  final String message;
  final List<PopupButton> buttons;
  final bool isVisible;
  final bool isBottom;

  const PopupModal({
    Key? key,
    required this.title,
    required this.message,
    required this.buttons,
    required this.isVisible,
    this.isBottom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Dark overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                // Don't close on overlay tap
              },
              child: Container(
                color: AppColors.overlayDark,
              ),
            ),
          ),
          // Modal content
          Positioned(
            bottom: isBottom ? 0 : null,
            left: 0,
            right: 0,
            top: !isBottom ? null : null,
            child: Container(
              margin: isBottom
                  ? EdgeInsets.zero
                  : EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.25,
                      right: MediaQuery.of(context).size.width * 0.25,
                      top: MediaQuery.of(context).size.height * 0.3,
                    ),
              decoration: BoxDecoration(
                color: AppColors.modalBg,
                borderRadius: isBottom
                    ? BorderRadius.zero
                    : BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(35),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.borderGrayLight,
                    thickness: 1,
                  ),
                  Padding(
                    padding: isBottom
                        ? const EdgeInsets.all(30)
                        : EdgeInsets.zero,
                    child: Row(
                      children: List.generate(
                        buttons.length,
                        (index) {
                          final button = buttons[index];
                          return Expanded(
                            child: Column(
                              children: [
                                if (index > 0 && !isBottom)
                                  Divider(
                                    height: 1,
                                    color: AppColors.borderGrayLight,
                                    thickness: 1,
                                  ),
                                SizedBox(
                                  height: 60,
                                  child: TextButton(
                                    onPressed: button.onPressed,
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: isBottom
                                            ? BorderRadius.circular(8)
                                            : BorderRadius.zero,
                                      ),
                                    ),
                                    child: Text(
                                      button.label,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: button.color,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isBottom && index < buttons.length - 1)
                                  const SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PopupButton {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  PopupButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });
}
