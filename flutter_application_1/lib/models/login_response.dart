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
      userId: (json['userId'] ?? json['id'] ?? json['user_id'] ?? '')
          .toString(),
      userName: (json['userName'] ?? json['username'] ?? json['name'] ?? '')
          .toString(),
      loginStatus: (json['loginStatus'] ?? json['status'] ?? 'success')
          .toString(),
      profilePicture:
          (json['profilePicture'] ?? json['avatar'] ?? json['picture'] ?? '')
              .toString(),
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
