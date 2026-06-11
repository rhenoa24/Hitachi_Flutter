import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../services/auth_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/otp_input_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _otpController = TextEditingController();
  String _step = 'username'; // username or otp
  bool _isLoading = false;
  bool _showError = false;
  bool _loginFailed = false;
  String _usernameError = '';
  String _loadingText = 'Logging In';

  @override
  void dispose() {
    _usernameController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  bool _isValidUsername(String username) {
    if (username.isEmpty) {
      _usernameError = 'Please enter your username';
      return false;
    }
    if (username.length > 24) {
      _usernameError = 'Must not exceed 24 characters';
      return false;
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
      _usernameError = 'Values must be alphanumeric';
      return false;
    }
    return true;
  }

  void _submitUsername() {
    if (!_isValidUsername(_usernameController.text)) {
      setState(() {
        _showError = true;
      });
      return;
    }

    setState(() {
      _step = 'otp';
      _showError = false;
      _loginFailed = false;
    });
  }

  void _submitOtp() async {
    if (_otpController.text.length != 6 ||
        !RegExp(r'^[0-9]{6}$').hasMatch(_otpController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _loadingText = 'Logging In';
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.login(
      _usernameController.text,
      _otpController.text,
    );

    if (result != null) {
      setState(() {
        _loadingText = 'Fetching Data';
      });
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } else {
      _clearInput();
      setState(() {
        _isLoading = false;
        _loadingText = 'Logging In';
        _loginFailed = true;
        _step = 'username';
      });
    }
  }

  void _closeOtp() {
    setState(() {
      _step = 'username';
    });
  }

  void _clearInput() {
    _usernameController.clear();
    _otpController.clear();
  }

  void _closeError() {
    setState(() {
      _loginFailed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? LoadingWidget(loadingText: _loadingText)
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Logo section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final imgSize = constraints.maxWidth * 0.48;
                                final dx = imgSize * 0.55;
                                final dy = imgSize * 0.35;
                                return SizedBox(
                                  height: imgSize + dy * 2,
                                  width: double.infinity,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Transform.translate(
                                        offset: Offset(-dx, -dy),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Image.asset(
                                            'assets/youtube.png',
                                            width: imgSize,
                                            height: imgSize,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          'assets/spotify.png',
                                          width: imgSize,
                                          height: imgSize,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(dx, dy),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Image.asset(
                                            'assets/facebook.png',
                                            width: imgSize,
                                            height: imgSize,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          // Login form
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(
                              children: [
                                TextField(
                                  controller: _usernameController,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: 'Username',
                                    hintStyle: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                        color: AppColors.borderGray,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: _showError
                                            ? AppColors.primaryRed
                                            : AppColors.primaryDarkBlue,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _showError = !_isValidUsername(value);
                                    });
                                  },
                                  onSubmitted: (_) => _submitUsername(),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 17,
                                  child: _showError && _step == 'username'
                                      ? Text(
                                          _usernameError,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: AppColors.primaryRed,
                                            fontSize: 12,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed:
                                        _isValidUsername(
                                          _usernameController.text,
                                        )
                                        ? _submitUsername
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryGreen,
                                      disabledBackgroundColor: const Color(
                                        0xFFDCDCDC,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Enter',
                                      style: TextStyle(
                                        color:
                                            _isValidUsername(
                                              _usernameController.text,
                                            )
                                            ? Colors.white
                                            : const Color(0xFF898989),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // OTP Modal
                  if (_step == 'otp')
                    Material(
                      type: MaterialType.transparency,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                // Don't close on overlay tap
                              },
                              child: Container(color: AppColors.overlayDark),
                            ),
                          ),
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
                                        const Text(
                                          "Verify It's You",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Please enter your 6 digit PIN',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        OtpInputWidget(
                                          controller: _otpController,
                                          onChanged: (value) {
                                            setState(() {
                                              _otpController.text = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: AppColors.borderGrayLight,
                                    thickness: 1,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 60,
                                          child: TextButton(
                                            onPressed: _submitOtp,
                                            child: const Text(
                                              'Enter',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.primaryGreen,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 60,
                                        color: AppColors.borderGrayLight,
                                        thickness: 1,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 60,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color:
                                                    AppColors.borderGrayLight,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: TextButton(
                                            onPressed: _closeOtp,
                                            child: const Text(
                                              'Close',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.primaryRed,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Error Modal
                  if (_loginFailed)
                    Material(
                      type: MaterialType.transparency,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                // Don't close on overlay tap
                              },
                              child: Container(color: AppColors.overlayDark),
                            ),
                          ),
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
                                        const Text(
                                          'Error',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Login Failed. Please try again.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textPrimary,
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
                                  SizedBox(
                                    height: 60,
                                    child: TextButton(
                                      onPressed: _closeError,
                                      child: const Text(
                                        'Close',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryRed,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
