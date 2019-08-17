import 'package:before_sunrise/import.dart';

class Profile {
  final String userID;
  final String firstName;
  final String lastName;
  final String businessName;
  final String businessDescription;
  final String businessLocation;
  final String phoneNumber;
  final String otherPhoneNumber;
  final String profileImageUrl;
  final bool hasProfile;
  final dynamic created;
  final dynamic lastUpdate;
  final bool isFollowing;
  final int followersCount;

  Profile({
    @required this.userID,
    @required this.firstName,
    @required this.lastName,
    @required this.businessName,
    @required this.businessDescription,
    @required this.businessLocation,
    @required this.phoneNumber,
    @required this.otherPhoneNumber,
    @required this.profileImageUrl,
    @required this.hasProfile,
    @required this.created,
    @required this.lastUpdate,
    this.isFollowing = false,
    this.followersCount = 0,
  });

  Profile copyWith(
      {String userID,
      String firstName,
      String lastName,
      String businessName,
      String businessDescription,
      String businessLocation,
      String phoneNumber,
      String otherPhoneNumber,
      String profileImageUrl,
      bool hasProfile,
      dynamic created,
      dynamic lastUpdate,
      bool isFollowing,
      int followersCount}) {
    return Profile(
      userID: userID ?? this.userID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      businessName: businessName ?? this.businessName,
      businessDescription: businessDescription ?? this.businessDescription,
      businessLocation: businessLocation ?? this.businessLocation,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otherPhoneNumber: otherPhoneNumber ?? this.otherPhoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      hasProfile: hasProfile ?? this.hasProfile,
      created: created ?? this.created,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isFollowing: isFollowing ?? this.isFollowing,
      followersCount: followersCount ?? this.followersCount,
    );
  }
}
