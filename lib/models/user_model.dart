class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final bool rVChat;
  final String phoneNumber;
  final int following;
  final int followers;
  final String country;
  final List<String> groupId;
  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.rVChat,
    required this.phoneNumber,
    required this.following,
    required this.followers,
    required this.country,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'rVChat': rVChat,
      'phoneNumber': phoneNumber,
      'following': following,
      'followers': followers,
      'country': country,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      rVChat: map['rVChat'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      following: map['following'] ?? 0,
      followers: map['followers'] ?? 0,
      country: map['country'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }

  toList() {}
}
