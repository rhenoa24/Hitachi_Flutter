class LoginRequest {
  final String userName;
  final String otp;

  LoginRequest({required this.userName, required this.otp});

  Map<String, dynamic> toJson() {
    return {'userName': userName, 'otp': otp};
  }

  /// Convert to form-urlencoded body for API
  String toFormBody() {
    return 'userName=$userName&otp=$otp';
  }

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      userName: json['userName'] as String,
      otp: json['otp'] as String,
    );
  }
}
