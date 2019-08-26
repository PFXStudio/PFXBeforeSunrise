import 'package:core/import.dart';

class Together {
  Together({
    this.userID = "",
    this.postID = "",
    this.clubID = "",
    this.dateString = "",
    this.totalCount = 0,
    this.restCount = 0,
    this.tablePrice = 0,
    this.tipPrice = 0,
    this.title = "",
    this.contents = "",
    this.imageUrls,
    this.youtubeUrl = "",
    this.created,
    this.lastUpdate,
    this.isLiked = false,
    this.likeCount = 0,
    this.warningCount = 0,
    this.profile,
  });

  String userID;
  String postID;
  String clubID;
  String dateString;
  int totalCount;
  int restCount;
  int hardCount;
  int champagneCount;
  int serviceCount;
  int tablePrice;
  int tipPrice;
  String title;
  String contents;
  List<dynamic> imageUrls;
  String youtubeUrl;
  dynamic created;
  dynamic lastUpdate;
  // other database.
  bool isLiked;
  int likeCount;
  int warningCount;
  Profile profile;

  void initialize(DocumentSnapshot snapshot) {
    this.postID = snapshot.documentID;
    this.userID = snapshot.data["userID"];
    this.clubID = snapshot.data["clubID"];
    this.dateString = snapshot.data["dateString"];
    this.totalCount = snapshot.data["totalCount"];
    this.restCount = snapshot.data["restCount"];
    this.tablePrice = snapshot.data["tablePrice"];
    this.tipPrice = snapshot.data["tipPrice"];
    this.title = snapshot.data["title"];
    this.contents = snapshot.data["contents"];
    this.imageUrls = snapshot.data["imageUrls"];
    this.youtubeUrl = snapshot.data["youtubeUrl"];
    this.created = snapshot.data["created"];
    this.lastUpdate = snapshot.data["lastUpdate"];
  }

  Object data() {
    return {
      "userID": userID,
      // "postID": postID, // 저장 할 이유 없음.
      "clubID": clubID,
      "dateString": dateString,
      "totalCount": totalCount,
      "restCount": restCount,
      "tablePrice": tablePrice,
      "tipPrice": tipPrice,
      "title": title,
      "contents": contents,
      "imageUrls": imageUrls,
      "youtubeUrl": youtubeUrl,
      'created': created,
      'lastUpdate': lastUpdate,
    };
  }

  Together copyWith({
    String userID,
    String postID,
    String clubID,
    String dateString,
    int totalCount,
    int restCount,
    int tablePrice,
    int tipPrice,
    String title,
    String contents,
    List<dynamic> imageUrls,
    String youtubeUrl,
    DateTime created,
    DateTime lastUpdate,
    bool isLiked,
    int likeCount,
    Profile profile,
  }) {
    return Together(
      userID: userID ?? this.userID,
      postID: postID ?? this.postID,
      clubID: postID ?? this.clubID,
      dateString: dateString ?? this.dateString,
      totalCount: totalCount ?? this.totalCount,
      restCount: restCount ?? this.restCount,
      tablePrice: tablePrice ?? this.tablePrice,
      tipPrice: tipPrice ?? this.tipPrice,
      title: title ?? this.title,
      contents: contents ?? this.contents,
      imageUrls: imageUrls ?? this.imageUrls,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
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
      other is Together &&
          runtimeType == other.runtimeType &&
          postID == other.postID;

  @override
  int get hashCode =>
      postID.hashCode ^
      userID.hashCode ^
      clubID.hashCode ^
      dateString.hashCode ^
      totalCount.hashCode ^
      restCount.hashCode ^
      tablePrice.hashCode ^
      tipPrice.hashCode ^
      title.hashCode ^
      contents.hashCode ^
      imageUrls.hashCode ^
      youtubeUrl.hashCode ^
      created.hashCode ^
      lastUpdate.hashCode;
}

class TogetherImageData {
  TogetherImageData({
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

  TogetherImageData.empty()
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
      other is TogetherImageData &&
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
