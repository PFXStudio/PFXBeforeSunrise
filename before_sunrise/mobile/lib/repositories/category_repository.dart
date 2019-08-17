import 'package:before_sunrise/import.dart';

class CategoryRepository {
  final FieldValue _firestoreTimestamp;
  final CollectionReference _categoryCollection;

  CategoryRepository()
      : _firestoreTimestamp = FieldValue.serverTimestamp(),
        _categoryCollection = Firestore.instance.collection('categories');

  Future<QuerySnapshot> fetchCategories(
      {@required PostCategory lastVisiblePostCategory}) {
    return lastVisiblePostCategory == null
        ? _categoryCollection
            .orderBy('lastUpdate', descending: true)
            .limit(5)
            .getDocuments()
        : _categoryCollection
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisiblePostCategory.lastUpdate])
            .limit(5)
            .getDocuments();
  }

  Future<DocumentReference> createCategory(
      {@required String imageUrl,
      @required String userID,
      @required String title,
      @required String description}) {
    return _categoryCollection.add({
      'imageUrl': imageUrl,
      'userID': userID,
      'title': title,
      'description': description,
      'created': _firestoreTimestamp,
      'lastUpdate': _firestoreTimestamp,
    });
  }
}
