class ModelUser {
  String uuid;
  String username;
  String email;
  String phoneNumber;
  String publicKey;
  String? profilePicture;

  ModelUser({
    required this.uuid,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.publicKey,
    required this.profilePicture,
  });

  factory ModelUser.fromJson(Map<String, dynamic> json) {
    return ModelUser(
      uuid: json["uuid"],
      username: json["username"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      publicKey: json["public_key"],
      profilePicture: json["profile_picture"],
    );
  }
}
