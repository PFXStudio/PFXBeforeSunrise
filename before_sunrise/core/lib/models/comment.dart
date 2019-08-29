import 'package:core/import.dart';

class Comment {
  Comment({
    this.commentID = "",
    this.userID = "",
    this.parentCommentID = "",
    this.text = "",
    this.parentText = "",
    this.imageUrls,
    this.created,
    this.lastUpdate,
    this.isLiked = false,
    this.likeCount = 0,
    this.warningCount = 0,
    this.isMine = false,
    this.profile,
    this.parentProfile,
    this.parentImageUrls,
  });

  String commentID;
  String userID;
  String parentCommentID;
  String text;
  List<dynamic> imageUrls;
  dynamic created;
  dynamic lastUpdate;
  // other database.
  String parentText;
  bool isLiked;
  int likeCount;
  int warningCount;
  bool isMine;
  Profile profile;
  Profile parentProfile;
  List<dynamic> parentImageUrls;

  void initialize(DocumentSnapshot snapshot) {
    this.commentID = snapshot.documentID;
    this.userID = snapshot.data["userID"];
    this.parentCommentID = snapshot.data["parentCommentID"];
    this.text = snapshot.data["text"];
    this.imageUrls = snapshot.data["imageUrls"];
    this.created = snapshot.data["created"];
    this.lastUpdate = snapshot.data["lastUpdate"];
  }

  Object data() {
    return {
      "userID": userID,
      // "commentID": commentID, // 저장 할 이유 없음.
      "parentCommentID": parentCommentID,
      "text": text,
      "imageUrls": imageUrls,
      'created': created,
      'lastUpdate': lastUpdate,
    };
  }

  Comment copyWith({
    String commentID,
    String userID,
    String parentCommentID,
    String text,
    String parentText,
    List<dynamic> imageUrls,
    DateTime created,
    DateTime lastUpdate,
    bool isLiked,
    int likeCount,
    bool isMine,
    Profile profile,
    Profile parentProfile,
    List<dynamic> parentImageUrls,
  }) {
    return Comment(
        userID: userID ?? this.userID,
        commentID: commentID ?? this.commentID,
        parentCommentID: parentCommentID ?? this.parentCommentID,
        text: text ?? this.text,
        parentText: parentText ?? this.parentText,
        imageUrls: imageUrls ?? this.imageUrls,
        created: created ?? this.created,
        lastUpdate: lastUpdate ?? this.lastUpdate,
        isLiked: isLiked ?? this.isLiked,
        likeCount: likeCount ?? this.likeCount,
        isMine: isMine ?? this.isMine,
        profile: profile ?? this.profile,
        parentProfile: parentProfile ?? this.parentProfile,
        parentImageUrls: parentImageUrls ?? this.parentImageUrls);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          commentID == other.commentID;

  @override
  int get hashCode =>
      commentID.hashCode ^
      userID.hashCode ^
      parentCommentID.hashCode ^
      text.hashCode ^
      parentText.hashCode ^
      imageUrls.hashCode ^
      parentImageUrls.hashCode ^
      created.hashCode ^
      lastUpdate.hashCode;
}

class CommentImageData {
  CommentImageData({
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

  CommentImageData.empty()
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
      other is CommentImageData &&
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
