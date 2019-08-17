import 'package:before_sunrise/import.dart';

class PostCategory {
  final String userID;
  final String categoryId;
  final String title;
  final String description;
  final String imageUrl;
  final dynamic created;
  final dynamic lastUpdate;

  PostCategory({
    @required this.userID,
    @required this.categoryId,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.created,
    @required this.lastUpdate,
  });
}
