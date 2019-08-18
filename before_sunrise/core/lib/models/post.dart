import 'package:core/import.dart';

class Post {
  Post({
    this.userID = "",
    this.postID = "",
    this.type = "",
    this.title = "",
    this.contents = "",
    this.imageUrls,
    this.youtubeUrl = "",
    this.publishType = "",
    this.enabledAnonymous = false,
    this.created,
    this.lastUpdate,
    this.isLiked = false,
    this.likeCount = 0,
    this.profile,
  });

  String userID;
  String postID;
  String type;
  String title;
  String contents;
  List<dynamic> imageUrls;
  String youtubeUrl;
  String publishType;
  bool enabledAnonymous;
  dynamic created;
  dynamic lastUpdate;
  // other database.
  bool isLiked;
  int likeCount;
  Profile profile;

  void initialize(DocumentSnapshot snapshot) {
    this.postID = snapshot.documentID;
    this.userID = snapshot["userID"];
    this.type = snapshot["type"];
    this.title = snapshot["title"];
    this.contents = snapshot["contents"];
    this.imageUrls = snapshot["imageUrls"];
    this.youtubeUrl = snapshot["youtubeUrl"];
    this.publishType = snapshot["publishType"];
    this.enabledAnonymous = snapshot["enabledAnonymous"];
    this.created = snapshot["created"];
    this.lastUpdate = snapshot["lastUpdate"];
  }

  Object data() {
    return {
      "userID": userID,
      // "postID": postID,
      "type": type,
      "title": title,
      "contents": contents,
      "imageUrls": imageUrls,
      "youtubeUrl": youtubeUrl,
      "publishType": publishType,
      "enabledAnonymous": enabledAnonymous,
      'created': created,
      'lastUpdate': lastUpdate,
    };
  }

  Post copyWith({
    String userID,
    String postID,
    String type,
    String title,
    String contents,
    List<dynamic> imageUrls,
    String youtubeUrl,
    String publishType,
    bool enabledAnonymous,
    DateTime created,
    DateTime lastUpdate,
    bool isLiked,
    int likeCount,
    Profile profile,
  }) {
    return Post(
      userID: userID ?? this.userID,
      postID: postID ?? this.postID,
      type: type ?? this.type,
      title: title ?? this.title,
      contents: contents ?? this.contents,
      imageUrls: imageUrls ?? this.imageUrls,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      publishType: publishType ?? this.publishType,
      enabledAnonymous: enabledAnonymous ?? this.enabledAnonymous,
      created: created ?? this.created,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      profile: profile ?? this.profile,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          runtimeType == other.runtimeType &&
          postID == other.postID;

  @override
  int get hashCode =>
      postID.hashCode ^
      userID.hashCode ^
      type.hashCode ^
      title.hashCode ^
      contents.hashCode ^
      imageUrls.hashCode ^
      youtubeUrl.hashCode ^
      publishType.hashCode ^
      enabledAnonymous.hashCode ^
      created.hashCode ^
      lastUpdate.hashCode;
}

class PostImageData {
  PostImageData({
    @required this.portraitSmall,
    @required this.portraitMedium,
    @required this.portraitLarge,
    @required this.landscapeSmall,
    @required this.landscapeBig,
    @required this.landscapeHd,
    @required this.landscapeHd2,
  });

  final String portraitSmall;
  final String portraitMedium;
  final String portraitLarge;
  final String landscapeSmall;
  final String landscapeBig;
  final String landscapeHd;
  final String landscapeHd2;

  String get anyAvailableImage =>
      portraitSmall ??
      portraitMedium ??
      portraitLarge ??
      landscapeSmall ??
      landscapeBig;

  PostImageData.empty()
      : portraitSmall = null,
        portraitMedium = null,
        portraitLarge = null,
        landscapeSmall = null,
        landscapeBig = null,
        landscapeHd = null,
        landscapeHd2 = null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostImageData &&
          runtimeType == other.runtimeType &&
          portraitSmall == other.portraitSmall &&
          portraitMedium == other.portraitMedium &&
          portraitLarge == other.portraitLarge &&
          landscapeSmall == other.landscapeSmall &&
          landscapeBig == other.landscapeBig &&
          landscapeHd == other.landscapeHd &&
          landscapeHd2 == other.landscapeHd2;

  @override
  int get hashCode =>
      portraitSmall.hashCode ^
      portraitMedium.hashCode ^
      portraitLarge.hashCode ^
      landscapeSmall.hashCode ^
      landscapeBig.hashCode ^
      landscapeHd.hashCode ^
      landscapeHd2.hashCode;
}
