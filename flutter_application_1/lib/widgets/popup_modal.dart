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
    if (!isVisible) return const SizedBox.shrink();

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Dark overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: () {},
              child: Container(color: AppColors.overlayDark),
            ),
          ),

          if (isBottom)
            // Bottom sheet style
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(buttons.length, (index) {
                          final button = buttons[index];
                          final isFirst = index == 0;
                          return Column(
                            children: [
                              if (index > 0) const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: TextButton(
                                  onPressed: button.onPressed,
                                  style: TextButton.styleFrom(
                                    backgroundColor: isFirst
                                        ? const Color(0xFFEEEEEE)
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            // Center modal style
            Positioned(
              left: MediaQuery.of(context).size.width * 0.25,
              right: MediaQuery.of(context).size.width * 0.25,
              top: MediaQuery.of(context).size.height * 0.3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.modalBg,
                  borderRadius: BorderRadius.circular(20),
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
                    const Divider(
                      height: 1,
                      color: AppColors.borderGrayLight,
                      thickness: 1,
                    ),
                    Row(
                      children: List.generate(buttons.length, (index) {
                        final button = buttons[index];
                        return Expanded(
                          child: Row(
                            children: [
                              if (index > 0)
                                const VerticalDivider(
                                  width: 1,
                                  color: AppColors.borderGrayLight,
                                  thickness: 1,
                                ),
                              Expanded(
                                child: SizedBox(
                                  height: 60,
                                  child: TextButton(
                                    onPressed: button.onPressed,
                                    style: TextButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
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
                              ),
                            ],
                          ),
                        );
                      }),
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
