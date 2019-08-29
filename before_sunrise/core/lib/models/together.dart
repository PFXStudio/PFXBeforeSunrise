import 'package:core/import.dart';

class Together {
  Together({
    this.userID = "",
    this.postID = "",
    this.clubID = "",
    this.dateString = "",
    this.totalCount = 0,
    this.restCount = 0,
    this.hardCount = 0,
    this.champagneCount = 0,
    this.serviceCount = 0,
    this.tablePrice = 0,
    this.tipPrice = 0,
    this.title = "",
    this.contents = "",
    this.imageUrls,
    this.youtubeUrl = "",
    this.created,
    this.lastUpdate,
    this.memberProfiles,
    this.isLiked = false,
    this.likeCount = 0,
    this.warningCount = 0,
    this.profile,
    this.comments,
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
  List<Profile> memberProfiles;
  bool isLiked;
  int likeCount;
  int warningCount;
  Profile profile;
  List<Comment> comments;

  void initialize(DocumentSnapshot snapshot) {
    this.postID = snapshot.documentID;
    this.userID = snapshot.data["userID"];
    this.clubID = snapshot.data["clubID"];
    this.dateString = snapshot.data["dateString"];
    this.totalCount = snapshot.data["totalCount"];
    this.restCount = snapshot.data["restCount"];
    this.hardCount = snapshot.data["hardCount"];
    this.champagneCount = snapshot.data["champagneCount"];
    this.serviceCount = snapshot.data["serviceCount"];
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
      "hardCount": hardCount,
      "champagneCount": champagneCount,
      "serviceCount": serviceCount,
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
    int hardCount,
    int champagneCount,
    int serviceCount,
    int tablePrice,
    int tipPrice,
    String title,
    String contents,
    List<dynamic> imageUrls,
    String youtubeUrl,
    DateTime created,
    DateTime lastUpdate,
    List<dynamic> memberProfiles,
    bool isLiked,
    int likeCount,
    Profile profile,
    List<Comment> comments,
  }) {
    return Together(
      userID: userID ?? this.userID,
      postID: postID ?? this.postID,
      clubID: postID ?? this.clubID,
      dateString: dateString ?? this.dateString,
      totalCount: totalCount ?? this.totalCount,
      restCount: restCount ?? this.restCount,
      hardCount: hardCount ?? this.hardCount,
      champagneCount: champagneCount ?? this.champagneCount,
      serviceCount: serviceCount ?? this.serviceCount,
      tablePrice: tablePrice ?? this.tablePrice,
      tipPrice: tipPrice ?? this.tipPrice,
      title: title ?? this.title,
      contents: contents ?? this.contents,
      imageUrls: imageUrls ?? this.imageUrls,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      created: created ?? this.created,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      memberProfiles: memberProfiles ?? this.memberProfiles,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      profile: profile ?? this.profile,
      comments: comments ?? this.comments,
    );
  }

  String countText() {
    return "총 인원 : ${this.totalCount}, 모집 인원 : ${this.restCount}";
  }

  String cocktailText() {
    return "${this.hardCount}하드, ${this.champagneCount}샴, ${this.serviceCount}서비스";
  }

  String priceText() {
    return "${this.tablePrice} + ${this.tipPrice} = ${this.tablePrice + this.tipPrice}만원";
  }

  String douchPriceText() {
    double price = (this.tablePrice + this.tipPrice) / this.totalCount;
    return "${this.tablePrice + this.tipPrice}만원 / ${this.totalCount}명 = ${price.toStringAsFixed(1)}만원";
  }

  String dateText() {
    DateTime dateTime = DateTime.parse(this.dateString);
    return CoreConst.togetherDateTextFormat.format(dateTime);
  }

  String synopsisText() {
    double price = (this.tablePrice + this.tipPrice) / this.totalCount;
    return "${this.dateText()}, ${this.clubID}, ${this.restCount}명, ${price.toStringAsFixed(1)}만원";
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
      hardCount.hashCode ^
      champagneCount.hashCode ^
      serviceCount.hashCode ^
      tablePrice.hashCode ^
      tipPrice.hashCode ^
      title.hashCode ^
      contents.hashCode ^
      imageUrls.hashCode ^
      youtubeUrl.hashCode ^
      created.hashCode ^
      lastUpdate.hashCode ^
      comments.hashCode;
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
