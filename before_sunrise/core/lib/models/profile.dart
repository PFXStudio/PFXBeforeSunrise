import 'package:core/import.dart';

class Profile {
  String userID;
  String nickname;
  String description;
  String phoneNumber;
  String profileImageUrl;
  int gender;
  dynamic created;
  dynamic lastUpdate;
  bool isFollowing;
  int followersCount;

  Profile({
    @required this.userID,
    @required this.nickname,
    @required this.description,
    @required this.phoneNumber,
    @required this.profileImageUrl,
    @required this.gender,
    @required this.created,
    @required this.lastUpdate,
    this.isFollowing = false,
    this.followersCount = 0,
  });

  void initialize(DocumentSnapshot snapshot) {
    this.userID = snapshot.documentID;
    this.nickname = snapshot.data["nickname"];
    this.description = snapshot.data["description"];
    this.phoneNumber = snapshot.data["phoneNumber"];
    this.profileImageUrl = snapshot.data["profileImageUrl"];
    this.gender = snapshot.data["gender"];
    this.created = snapshot.data["created"];
    this.lastUpdate = snapshot.data["lastUpdate"];
  }

  Object data() {
    return {
      "userID": userID,
      "nickname": nickname,
      "description": description,
      "phoneNumber": phoneNumber,
      "profileImageUrl": profileImageUrl,
      "gender": gender,
      "created": created,
      "lastUpdate": lastUpdate,
    };
  }

  Profile copyWith({
    String userID,
    String nickname,
    String description,
    String phoneNumber,
    String profileImageUrl,
    int gender,
    dynamic created,
    dynamic lastUpdate,
    bool isFollowing,
    int followersCount,
  }) {
    return Profile(
      userID: userID ?? this.userID,
      nickname: nickname ?? this.nickname,
      description: description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      gender: gender ?? this.gender,
      created: created ?? this.created,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isFollowing: isFollowing ?? this.isFollowing,
      followersCount: followersCount ?? this.followersCount,
    );
  }
}
