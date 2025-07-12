class UserModel {
  final String? email;
  final String? password;
  final String? googleId;
  final String? displayName;

  UserModel({
    this.email,
    this.password,
    this.googleId,
    this.displayName,
  });

  bool get isValid => email != null && email!.isNotEmpty;

  factory UserModel.fromGoogle(Map<String, dynamic> googleData) {
    return UserModel(
      email: googleData['email'],
      displayName: googleData['displayName'],
      googleId: googleData['id'],
    );
  }
}