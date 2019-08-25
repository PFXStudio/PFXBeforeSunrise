import 'package:core/import.dart';
import 'package:intl/intl.dart';

@immutable
abstract class TogetherEvent {
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc});
}

class LoadTogetherEvent extends TogetherEvent {
  LoadTogetherEvent({@required this.dateTime});
  @override
  String toString() => 'LoadTogetherEvent';
  final ITogetherProvider _togetherProvider = TogetherProvider();
  final IProfileProvider _profileProvider = ProfileProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  DateTime dateTime;

  @override
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc}) async {
    try {
      String dateString = CoreConst.togetherDateFormat.format(dateTime);
      QuerySnapshot snapshot =
          await _togetherProvider.fetchTogethers(dateString: dateString);

      List<DateTime> dates = List<DateTime>();
      DateTime currentDateTime = DateTime.now();
      DateTime selectedDate;
      for (int i = 0; i < 6; i++) {
        var addDateTime = currentDateTime.add(Duration(days: i));
        dates.add(addDateTime);
        if (currentDateTime.year == dateTime.year &&
            currentDateTime.month == dateTime.month &&
            currentDateTime.day == dateTime.day) {
          selectedDate = currentDateTime;
        }
      }

      List<Together> togethers = List<Together>();
      TogetherCollection collection = TogetherCollection(
          dates: dates, togethers: togethers, selectedDate: selectedDate);

      if (snapshot == null) {
        return EmptyTogetherState();
      }
      if (snapshot.documents.length <= 0) {
        return EmptyTogetherState();
      }

      String userID = await _authProvider.getUserID();
      return new FetchedTogetherState(togetherCollection: collection);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorTogetherState(_?.toString());
    }
  }
}

class ToggleLikeTogetherEvent extends TogetherEvent {
  ToggleLikeTogetherEvent({@required this.postID, this.isLike});
  @override
  String toString() => 'ToggleLikeTogetherEvent';
  final ITogetherProvider _togetherProvider = TogetherProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();

  String postID;
  bool isLike;

  @override
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      if (isLike == true) {
        await _togetherProvider.addToLike(postID: postID, userID: userID);
        await _shardsProvider.increaseLikeCount(postID: postID);
      } else {
        await _togetherProvider.removeFromLike(postID: postID, userID: userID);
        await _shardsProvider.decreaseLikeCount(postID: postID);
      }

      return currentState;
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorTogetherState(_?.toString());
    }
  }
}

class CreateTogetherEvent extends TogetherEvent {
  CreateTogetherEvent({@required this.post, @required this.byteDatas})
      : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'CreateTogetherEvent';
  final ITogetherProvider _togetherProvider = TogetherProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IFImageProvider _imageProvider = FImageProvider();
  FieldValue _firestoreTimestamp;
  List<ByteData> byteDatas;

  Post post;

  @override
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      List<String> imageUrls = List<String>();
      if (byteDatas != null) {
        final String fileLocation = '$userID/posts';

        imageUrls = await _imageProvider.uploadPostImages(
            fileLocation: fileLocation, byteDatas: byteDatas);
      }
      post.userID = userID;
      post.created = _firestoreTimestamp;
      post.lastUpdate = _firestoreTimestamp;
      post.imageUrls = imageUrls;
      DocumentReference reference =
          await _togetherProvider.createTogether(data: post.data());
      if (reference == null) {
        return ErrorTogetherState("error");
      }

      return new SuccessTogetherState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorTogetherState(_?.toString());
    }
  }
}
