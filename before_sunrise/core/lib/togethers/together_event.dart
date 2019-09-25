import 'package:core/import.dart';
import 'package:intl/intl.dart';

@immutable
abstract class TogetherEvent {
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc});
}

class LoadTogetherEvent extends TogetherEvent {
  LoadTogetherEvent(
      {@required this.dateTime, @required this.lastVisibleTogether});
  @override
  String toString() => 'LoadTogetherEvent';
  final ITogetherProvider _togetherProvider = TogetherProvider();
  final IProfileProvider _profileProvider = ProfileProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  DateTime dateTime;
  Together lastVisibleTogether;

  @override
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc}) async {
    try {
      String dateString = CoreConst.togetherDateFormat.format(dateTime);
      QuerySnapshot snapshot = await _togetherProvider.fetchTogethers(
          dateString: dateString, lastVisibleTogether: lastVisibleTogether);

      List<Together> togethers = List<Together>();
      TogetherCollection collection =
          TogetherCollection(togethers: togethers, selectedDate: dateTime);

      if (snapshot == null) {
        return EmptyTogetherState(togetherCollection: collection);
      }
      if (snapshot.documents.length <= 0) {
        return EmptyTogetherState(togetherCollection: collection);
      }

      for (var document in snapshot.documents) {
        Together together = Together();
        together.initialize(document);
        DocumentSnapshot profileSnapshot =
            await _profileProvider.fetchProfile(userID: together.userID);
        Profile userProfile = Profile();
        userProfile.initialize(profileSnapshot);
        together.profile = userProfile;
        DocumentSnapshot countSnapshot =
            await _shardsProvider.commentCount(postID: together.postID);
        if (countSnapshot != null && countSnapshot.data != null) {
          together.commentCount = countSnapshot.data["count"];
        }

        DocumentSnapshot viewCountSnapshot =
            await _shardsProvider.viewCount(postID: together.postID);
        if (viewCountSnapshot != null && viewCountSnapshot.data != null) {
          together.viewCount = viewCountSnapshot.data["count"];
        }

        collection.togethers.add(together);
      }

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

  final String postID;
  final bool isLike;

  @override
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      if (isLike == true) {
        await _togetherProvider.addToLike(postID: postID, userID: userID);
        await _shardsProvider.increasePostLikeCount(
            category: Together().category(), postID: postID);
      } else {
        await _togetherProvider.removeFromLike(postID: postID, userID: userID);
        await _shardsProvider.decreasePostLikeCount(
            category: Together().category(), postID: postID);
      }

      return currentState;
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorTogetherState(_?.toString());
    }
  }
}

class ViewTogetherEvent extends TogetherEvent {
  ViewTogetherEvent({@required this.together, @required this.userID});
  @override
  String toString() => 'ViewTogetherEvent';
  final ITogetherProvider _togetherProvider = TogetherProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();

  final String userID;
  final Together together;

  @override
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc}) async {
    try {
      await _togetherProvider.addToView(
          postID: together.postID, userID: userID);
      await _shardsProvider.increaseViewCount(
          category: together.category(), postID: together.postID);

      return FetchedTogetherState(togetherCollection: TogetherCollection());
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorTogetherState(_?.toString());
    }
  }
}

class CreateTogetherEvent extends TogetherEvent {
  CreateTogetherEvent(
      {@required this.together,
      @required this.byteDatas,
      this.removedImageUrls,
      this.alreadyImageUrls})
      : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'CreateTogetherEvent';
  final ITogetherProvider _togetherProvider = TogetherProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IFImageProvider _imageProvider = FImageProvider();
  FieldValue _firestoreTimestamp;
  List<ByteData> byteDatas;
  List<String> removedImageUrls;
  List<String> alreadyImageUrls;

  Together together;

  @override
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      if (together.imageFolder == null ||
          together.imageFolder.isEmpty == true) {
        Uuid uuid = Uuid();
        String identifier = uuid.v4(options: {
          'positionalArgs': [userID]
        });
        print("identifier : ${identifier}");
        together.imageFolder = identifier;
      }

      if (removedImageUrls != null) {
        for (int i = 0; i < removedImageUrls.length; i++) {
          await _imageProvider.removeImage(imageUrl: removedImageUrls[i]);
        }
      }

      List<String> imageUrls = List<String>();
      if (byteDatas != null) {
        final String imageFolder = '$userID/posts/${together.imageFolder}';

        imageUrls = await _imageProvider.uploadPostImages(
            imageFolder: imageFolder, byteDatas: byteDatas);
      }

      if (alreadyImageUrls != null && alreadyImageUrls.length > 0) {
        imageUrls.addAll(alreadyImageUrls);
      }

      together.userID = userID;
      together.created = _firestoreTimestamp;
      together.lastUpdate = _firestoreTimestamp;
      together.imageUrls = imageUrls;

      if (together.postID != null && together.postID.isEmpty == false) {
        DocumentSnapshot snapshot =
            await _togetherProvider.updateTogether(data: together.data());

        Together updatedPost = Together();
        updatedPost.initialize(snapshot);
        updatedPost.profile = together.profile;
        updatedPost.isLike = together.isLike;
        updatedPost.likeCount = together.likeCount;
        updatedPost.commentCount = together.commentCount;
        updatedPost.warningCount = together.warningCount;
        updatedPost.viewCount = together.viewCount;

        return new SuccessTogetherState(together: updatedPost);
      }

      DocumentReference reference =
          await _togetherProvider.createTogether(data: together.data());
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

class RemoveTogetherEvent extends TogetherEvent {
  RemoveTogetherEvent({@required this.together});
  @override
  String toString() => 'RemoveTogetherEvent';
  final ITogetherProvider _postProvider = TogetherProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  final IProfileProvider _profileProvider = ProfileProvider();
  final IFImageProvider _imageProvider = FImageProvider();
  final ICommentProvider _commentProvider = CommentProvider();

  Together together;

  @override
  Future<TogetherState> applyAsync(
      {TogetherState currentState, TogetherBloc bloc}) async {
    try {
      if (together.imageUrls != null && together.imageUrls.length > 0) {
        for (var url in together.imageUrls) {
          await _imageProvider.removeImage(imageUrl: url);
        }
      }

      await _commentProvider.removeComments(
          postID: together.postID, category: together.category());

      await _shardsProvider.removePostLikeCount(postID: together.postID);
      await _shardsProvider.removeCommentCount(postID: together.postID);
      await _shardsProvider.removeReportCount(postID: together.postID);
      await _shardsProvider.removeViewCount(postID: together.postID);

      await _postProvider.removeTogether(postID: together.postID);

      return new SuccessRemoveTogetherState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorTogetherState(_?.toString());
    }
  }
}
