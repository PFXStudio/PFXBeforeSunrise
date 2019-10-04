import 'package:core/import.dart';

class Comment {
  Comment({
    this.commentID = "",
    this.userID = "",
    this.parentCommentID = "",
    this.text = "",
    this.parentText = "",
    this.imageFolder = "",
    this.imageUrls,
    this.isRemove = false,
    this.created,
    this.lastUpdate,
    this.isLike = false,
    this.likeCount = 0,
    this.isReport = false,
    this.reportCount = 0,
    this.isMine = false,
    this.profile,
    this.parentProfile,
    this.parentImageUrls,
    this.isWriter,
  });

  String commentID;
  String userID;
  String parentCommentID;
  String text;
  String imageFolder;
  List<dynamic> imageUrls;
  bool isRemove;
  dynamic created;
  dynamic lastUpdate;
  // other database.
  String parentText;
  bool isLike;
  int likeCount;
  bool isReport;
  int reportCount;
  bool isMine;
  Profile profile;
  Profile parentProfile;
  List<dynamic> parentImageUrls;
  bool isWriter;

  void initialize(DocumentSnapshot snapshot) {
    this.commentID = snapshot.documentID;
    this.userID = snapshot.data["userID"];
    this.parentCommentID = snapshot.data["parentCommentID"];
    this.text = snapshot.data["text"];
    this.imageFolder = snapshot.data["imageFolder"];
    this.imageUrls = snapshot.data["imageUrls"];
    this.isRemove = snapshot.data["isRemove"];
    this.created = snapshot.data["created"];
    this.lastUpdate = snapshot.data["lastUpdate"];
  }

  Object data() {
    return {
      "userID": userID,
      "commentID": commentID,
      "parentCommentID": parentCommentID,
      "text": text,
      "imageFolder": imageFolder,
      "imageUrls": imageUrls,
      'isRemove': isRemove,
      'created': created,
      'lastUpdate': lastUpdate,
    };
  }

  Comment copyWith(
      {String commentID,
      String userID,
      String parentCommentID,
      String text,
      String imageFolder,
      String parentText,
      List<dynamic> imageUrls,
      bool isRemove,
      DateTime created,
      DateTime lastUpdate,
      bool isLike,
      int likeCount,
      bool isReport,
      int reportCount,
      bool isMine,
      Profile profile,
      Profile parentProfile,
      List<dynamic> parentImageUrls,
      bool isWriter}) {
    return Comment(
        userID: userID ?? this.userID,
        commentID: commentID ?? this.commentID,
        parentCommentID: parentCommentID ?? this.parentCommentID,
        text: text ?? this.text,
        imageFolder: imageFolder ?? this.imageFolder,
        parentText: parentText ?? this.parentText,
        imageUrls: imageUrls ?? this.imageUrls,
        isRemove: isRemove ?? this.isRemove,
        created: created ?? this.created,
        lastUpdate: lastUpdate ?? this.lastUpdate,
        isLike: isLike ?? this.isLike,
        likeCount: likeCount ?? this.likeCount,
        isReport: isReport ?? this.isReport,
        reportCount: reportCount ?? this.reportCount,
        isMine: isMine ?? this.isMine,
        profile: profile ?? this.profile,
        parentProfile: parentProfile ?? this.parentProfile,
        parentImageUrls: parentImageUrls ?? this.parentImageUrls,
        isWriter: isWriter ?? this.isWriter);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          commentID == other.commentID;

  @override
  int get hashCode => commentID.hashCode ^ userID.hashCode;
}
