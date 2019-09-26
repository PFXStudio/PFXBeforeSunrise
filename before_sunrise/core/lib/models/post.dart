import 'package:core/import.dart';

class Post {
  Post({
    this.category = "",
    this.userID = "",
    this.postID = "",
    this.type = "",
    this.title = "",
    this.contents = "",
    this.imageFolder = "",
    this.imageUrls,
    this.youtubeUrl = "",
    this.publishType = "",
    this.enabledAnonymous = false,
    this.created,
    this.lastUpdate,
    this.isLike = false,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isReport = false,
    this.reportCount = 0,
    this.viewCount = 0,
    this.profile,
    this.comments,
  });

  String category;
  String userID;
  String postID;
  String type;
  String title;
  String contents;
  String imageFolder;
  List<dynamic> imageUrls;
  String youtubeUrl;
  String publishType;
  bool enabledAnonymous;
  dynamic created;
  dynamic lastUpdate;
  // other database.
  bool isLike;
  int likeCount;
  int commentCount;
  bool isReport;
  int reportCount;
  int viewCount;
  Profile profile;
  List<Comment> comments;

  void initialize(DocumentSnapshot snapshot) {
    this.postID = snapshot.documentID;
    this.category = snapshot.data["category"];
    this.userID = snapshot.data["userID"];
    this.type = snapshot.data["type"];
    this.title = snapshot.data["title"];
    this.contents = snapshot.data["contents"];
    this.imageFolder = snapshot.data["imageFolder"];
    this.imageUrls = snapshot.data["imageUrls"];
    this.youtubeUrl = snapshot.data["youtubeUrl"];
    this.publishType = snapshot.data["publishType"];
    this.enabledAnonymous = snapshot.data["enabledAnonymous"];
    this.created = snapshot.data["created"];
    this.lastUpdate = snapshot.data["lastUpdate"];
  }

  Object data() {
    return {
      "postID": postID,
      "category": category,
      "userID": userID,
      "type": type,
      "title": title,
      "contents": contents,
      "imageFolder": imageFolder,
      "imageUrls": imageUrls,
      "youtubeUrl": youtubeUrl,
      "publishType": publishType,
      "enabledAnonymous": enabledAnonymous,
      'created': created,
      'lastUpdate': lastUpdate,
    };
  }

  Post copyWith({
    String category,
    String userID,
    String postID,
    String type,
    String title,
    String contents,
    String imageFolder,
    List<dynamic> imageUrls,
    String youtubeUrl,
    String publishType,
    bool enabledAnonymous,
    DateTime created,
    dynamic lastUpdate,
    bool isLike,
    int likeCount,
    int commentCount,
    bool isReport,
    int reportCount,
    int viewCount,
    Profile profile,
    List<Comment> comments,
  }) {
    return Post(
      category: category ?? this.category,
      userID: userID ?? this.userID,
      postID: postID ?? this.postID,
      type: type ?? this.type,
      title: title ?? this.title,
      contents: contents ?? this.contents,
      imageFolder: imageFolder ?? this.imageFolder,
      imageUrls: imageUrls ?? this.imageUrls,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      publishType: publishType ?? this.publishType,
      enabledAnonymous: enabledAnonymous ?? this.enabledAnonymous,
      created: created ?? this.created,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isLike: isLike ?? this.isLike,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isReport: isReport ?? this.isReport,
      reportCount: reportCount ?? this.reportCount,
      viewCount: viewCount ?? this.viewCount,
      profile: profile ?? this.profile,
      comments: comments ?? this.comments,
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
      imageFolder.hashCode ^
      imageUrls.hashCode ^
      youtubeUrl.hashCode ^
      publishType.hashCode ^
      enabledAnonymous.hashCode ^
      created.hashCode ^
      lastUpdate.hashCode;
}
