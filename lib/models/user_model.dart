import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final bool rVChat;
  final String? phoneNumber;
  final int following;
  final int followers;
  final String country;
  final String? email;
  final bool isFake;
  final int coin;
  final DateTime lastOnlineTime;
  final String videoLink;
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
    required this.email,
    required this.isFake,
    required this.coin,
    required this.lastOnlineTime,
    required this.videoLink,
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
      'email': email,
      'isFake': isFake,
      'coin': coin,
      'lastOnlineTime': lastOnlineTime.millisecondsSinceEpoch,
      'videoLink': videoLink,
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
      email: map['email'] ?? '',
      isFake: map['isFake'] ?? false,
      coin: map['coin'] ?? 0,
      lastOnlineTime:
          DateTime.fromMillisecondsSinceEpoch(map['lastOnlineTime']),
      videoLink: map['videoLink'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }

  toList() {}
}
