import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late final TextEditingController _hiddenController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _hiddenController = widget.controller ?? TextEditingController();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (widget.controller == null) _hiddenController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final value = _hiddenController.text;

    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Hidden real input — invisible but focusable
          Opacity(
            opacity: 0,
            child: SizedBox(
              width: 40,
              height: 40,
              child: TextField(
                controller: _hiddenController,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: widget.length,
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
          ),
          // Visual digit display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (i) {
              final char = i < value.length ? value[i] : '-';
              final isActive = _focusNode.hasFocus && value.length == i;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  char,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? AppColors.primaryDarkBlue
                        : AppColors.textPrimary,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
