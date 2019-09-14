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
    this.imageFolder = "",
    this.imageUrls,
    this.youtubeUrl = "",
    this.created,
    this.lastUpdate,
    this.memberProfiles,
    this.isLike = false,
    this.likeCount = 0,
    this.commentCount = 0,
    this.warningCount = 0,
    this.viewCount = 0,
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
  String imageFolder;
  List<dynamic> imageUrls;
  String youtubeUrl;
  dynamic created;
  dynamic lastUpdate;
  // other database.
  List<Profile> memberProfiles;
  bool isLike;
  int likeCount;
  int commentCount;
  int warningCount;
  int viewCount;
  Profile profile;

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
    this.imageFolder = snapshot.data["imageFolder"];
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
      "imageFolder": imageFolder,
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
    String imageFolder,
    List<dynamic> imageUrls,
    String youtubeUrl,
    DateTime created,
    DateTime lastUpdate,
    List<dynamic> memberProfiles,
    bool isLike,
    int likeCount,
    int commentCount,
    int warningCount,
    int viewCount,
    Profile profile,
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
      imageFolder: imageFolder ?? this.imageFolder,
      imageUrls: imageUrls ?? this.imageUrls,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      created: created ?? this.created,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      memberProfiles: memberProfiles ?? this.memberProfiles,
      isLike: isLike ?? this.isLike,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      warningCount: warningCount ?? this.warningCount,
      viewCount: viewCount ?? this.viewCount,
      profile: profile ?? this.profile,
    );
  }

  String countText() {
    return "총 인원 : ${this.totalCount}, 모집 인원 : ${this.restCount}";
  }

  String cocktailText() {
    return "${this.hardCount}하드, ${this.champagneCount}샴, ${this.serviceCount}서비스";
  }

  String priceText() {
    return "${this.tablePrice}+${this.tipPrice} = ${this.tablePrice + this.tipPrice}만원";
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
    return "${this.dateText()}, ${this.clubID}, ${this.restCount}명 모집, 인당 ${price.toStringAsFixed(1)}만원";
  }

  String synopsisItemText() {
    double price = (this.tablePrice + this.tipPrice) / this.totalCount;
    return "${this.restCount}명 모집, 인당 ${price.toStringAsFixed(1)}만원";
  }

  String category() {
    return "/together/posts";
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
      imageFolder.hashCode ^
      contents.hashCode ^
      imageUrls.hashCode ^
      youtubeUrl.hashCode ^
      created.hashCode ^
      lastUpdate.hashCode;
}
