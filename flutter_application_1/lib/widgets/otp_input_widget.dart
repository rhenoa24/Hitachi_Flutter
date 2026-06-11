import 'package:flutter/material.dart';
import '../constants/colors.dart';

class OtpInputWidget extends StatefulWidget {
  final int length;
  final Function(String) onChanged;
  final TextEditingController? controller;

  const OtpInputWidget({
    Key? key,
    this.length = 6,
    required this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < widget.length - 1) {
      FocusScope.of(context).nextFocus();
    }

    final otp = _controllers.map((c) => c.text).join();
    widget.onChanged(otp);

    if (widget.controller != null) {
      widget.controller!.text = otp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.length,
        (index) => Container(
          width: 45,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            controller: _controllers[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            onChanged: (value) => _onChanged(value, index),
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.borderGray,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primaryDarkBlue,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
