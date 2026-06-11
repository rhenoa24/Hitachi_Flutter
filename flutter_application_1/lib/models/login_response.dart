class LoginResponse {
  final String userId;
  final String userName;
  final String loginStatus;
  final String profilePicture;

  LoginResponse({
    required this.userId,
    required this.userName,
    required this.loginStatus,
    required this.profilePicture,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      loginStatus: json['loginStatus'] as String,
      profilePicture: json['profilePicture'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'loginStatus': loginStatus,
      'profilePicture': profilePicture,
    };
  }
}
