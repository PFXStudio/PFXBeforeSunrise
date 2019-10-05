import 'package:core/import.dart';

class ClubInfo {
  ClubInfo({
    this.userID = "",
    this.postID = "",
    this.zone = "",
    this.name = "",
    this.genreType = 0,
    this.address = "",
    this.openTimeMap,
    this.entrancePrice = "",
    this.tablePrice = "",
    this.tableMap,
    this.drinkMap,
    this.notice = "",
    this.scheduleMap,
    this.imageFolder = "",
    this.imageUrls,
    this.created,
    this.lastUpdate,
    // other databases
    this.isFavorite = false,
    this.favoriteCount = 0,
    this.viewCount = 0,
    this.commentCount = 0,
    this.comments,
    this.youtubeUrls,
  });

  String userID;
  String postID;
  String zone;
  String name;
  int genreType;
  String address;
  Map<String, String> openTimeMap;
  String entrancePrice;
  String tablePrice;
  Map<String, List<dynamic>> tableMap;
  Map<String, List<dynamic>> drinkMap;
  String notice;
  Map<String, List<dynamic>> scheduleMap;
  String imageFolder;
  List<dynamic> imageUrls;
  dynamic created;
  dynamic lastUpdate;
  // other database.
  List<String> youtubeUrls;
  bool isFavorite;
  int favoriteCount;
  int viewCount;
  int commentCount;
  List<Comment> comments;

  void initialize(DocumentSnapshot snapshot) {
    this.postID = snapshot.documentID;
    this.userID = snapshot.data["userID"];
    this.zone = snapshot.data["zone"];
    this.name = snapshot.data["name"];
    this.genreType = snapshot.data["genreType"];
    this.address = snapshot.data["address"];
    this.openTimeMap = snapshot.data["openTimeMap"];
    this.entrancePrice = snapshot.data["entrancePrice"];
    this.tablePrice = snapshot.data["tablePrice"];
    this.tableMap = snapshot.data["tableMap"];
    this.drinkMap = snapshot.data["drinkMap"];
    this.notice = snapshot.data["notice"];
    this.drinkMap = snapshot.data["drinkMap"];
    this.scheduleMap = snapshot.data["scheduleMap"];
    this.imageFolder = snapshot.data["imageFolder"];
    this.imageUrls = snapshot.data["imageUrls"];
    this.created = snapshot.data["created"];
    this.lastUpdate = snapshot.data["lastUpdate"];
  }

  Object data() {
    return {
      "postID": postID,
      "userID": userID,
      "zone": zone,
      "name": name,
      "genreType": genreType,
      "address": address,
      "openTimeMap": openTimeMap,
      "entrancePrice": entrancePrice,
      "tablePrice": tablePrice,
      "tableMap": tableMap,
      "drinkMap": drinkMap,
      "notice": notice,
      "scheduleMap": scheduleMap,
      "imageFolder": imageFolder,
      "imageUrls": imageUrls,
      'created': created,
      'lastUpdate': lastUpdate,
    };
  }

  ClubInfo copyWith(
      {String userID,
      String postID,
      String zone,
      String name,
      int genreType,
      String address,
      Map<String, String> openTimeMap,
      String entrancePrice,
      String tablePrice,
      Map<String, List<dynamic>> tableMap,
      Map<String, List<dynamic>> drinkMap,
      String notice,
      Map<String, List<dynamic>> scheduleMap,
      String imageFolder,
      List<dynamic> imageUrls,
      dynamic created,
      dynamic lastUpdate,
      // other database.
      List<String> youtubeUrls,
      bool isFavorite,
      int favoriteCount,
      int viewCount,
      int commentCount,
      List<Comment> comments}) {
    return ClubInfo(
      userID: userID ?? this.userID,
      postID: postID ?? this.postID,
      zone: zone ?? this.zone,
      name: name ?? this.name,
      genreType: genreType ?? this.genreType,
      address: address ?? this.address,
      openTimeMap: openTimeMap ?? this.openTimeMap,
      entrancePrice: entrancePrice ?? this.entrancePrice,
      tablePrice: tablePrice ?? this.tablePrice,
      tableMap: tableMap ?? this.tableMap,
      drinkMap: drinkMap ?? this.drinkMap,
      notice: notice ?? this.notice,
      scheduleMap: scheduleMap ?? this.scheduleMap,
      imageFolder: imageFolder ?? this.imageFolder,
      imageUrls: imageUrls ?? this.imageUrls,
      created: created ?? this.created,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      youtubeUrls: youtubeUrls ?? this.youtubeUrls,
      isFavorite: isFavorite ?? this.isFavorite,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      viewCount: viewCount ?? this.viewCount,
      commentCount: commentCount ?? this.commentCount,
      comments: comments ?? this.comments,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClubInfo &&
          runtimeType == other.runtimeType &&
          postID == other.postID;

  @override
  int get hashCode => postID.hashCode ^ userID.hashCode;
}
