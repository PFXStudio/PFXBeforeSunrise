import 'package:core/import.dart';

@immutable
abstract class ClubInfoEvent {
  final IClubInfoProvider _postProvider = ClubInfoProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  final IFImageProvider _imageProvider = FImageProvider();
  final ICommentProvider _commentProvider = CommentProvider();
  Future<ClubInfoState> applyAsync(
      {ClubInfoState currentState, ClubInfoBloc bloc});
}

class LoadClubInfoEvent extends ClubInfoEvent {
  LoadClubInfoEvent({@required this.category, @required this.post});
  @override
  String toString() => 'LoadClubInfoEvent';
  final String category;
  final ClubInfo post;

  @override
  Future<ClubInfoState> applyAsync(
      {ClubInfoState currentState, ClubInfoBloc bloc}) async {
    try {
      QuerySnapshot snapshot =
          await _postProvider.fetchClubInfos(lastVisibleClubInfo: post);
      List<ClubInfo> posts = List<ClubInfo>();
      if (snapshot == null) {
        return IdleClubInfoState();
      }
      if (snapshot.documents.length <= 0) {
        return IdleClubInfoState();
      }

      String userID = await _authProvider.getUserID();
      for (var document in snapshot.documents) {
        ClubInfo post = ClubInfo();
        post.initialize(document);
        post.isFavorite =
            await _postProvider.isFavorite(postID: post.postID, userID: userID);
        DocumentSnapshot favoriteSnapshot =
            await _shardsProvider.clubInfoFavoriteCount(postID: post.postID);
        if (favoriteSnapshot != null && favoriteSnapshot.data != null) {
          post.favoriteCount = favoriteSnapshot.data["count"];
        }

        DocumentSnapshot commentSnapshot =
            await _shardsProvider.commentCount(postID: post.postID);
        if (commentSnapshot != null && commentSnapshot.data != null) {
          post.commentCount = commentSnapshot.data["count"];
        }

        DocumentSnapshot viewSnapshot =
            await _shardsProvider.viewCount(postID: post.postID);
        if (viewSnapshot != null && viewSnapshot.data != null) {
          post.viewCount = viewSnapshot.data["count"];
        }

        posts.add(post);
      }

      return new FetchedClubInfoState(clubInfos: posts);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorClubInfoState(_?.toString());
    }
  }
}

class ToggleFavoriteClubInfoEvent extends ClubInfoEvent {
  ToggleFavoriteClubInfoEvent({@required this.post, this.isFavorite});
  @override
  String toString() => 'ToggleFavoriteClubInfoEvent';
  final ClubInfo post;
  final bool isFavorite;

  @override
  Future<ClubInfoState> applyAsync(
      {ClubInfoState currentState, ClubInfoBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      if (isFavorite == true) {
        await _postProvider.addToFavorite(postID: post.postID, userID: userID);
        await _shardsProvider.increaseClubInfoFavoriteCount(
            category: post.category(), postID: post.postID);
      } else {
        await _postProvider.removeFromFavorite(
            postID: post.postID, userID: userID);
        await _shardsProvider.decreaseClubInfoFavoriteCount(
            category: post.category(), postID: post.postID);
      }

      return IdleClubInfoState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorClubInfoState(_?.toString());
    }
  }
}

class CreateClubInfoEvent extends ClubInfoEvent {
  CreateClubInfoEvent(
      {@required this.post,
      @required this.byteDatas,
      this.removedImageUrls,
      this.alreadyImageUrls})
      : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'CreateClubInfoEvent';
  final FieldValue _firestoreTimestamp;
  final List<ByteData> byteDatas;
  final List<String> removedImageUrls;
  final List<String> alreadyImageUrls;

  final ClubInfo post;

  @override
  Future<ClubInfoState> applyAsync(
      {ClubInfoState currentState, ClubInfoBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      List<String> imageUrls = List<String>();

      if (post.imageFolder == null || post.imageFolder.isEmpty == true) {
        Uuid uuid = Uuid();
        String identifier = uuid.v4(options: {
          'positionalArgs': [userID]
        });
        print("identifier : ${identifier}");
        post.imageFolder = identifier;
      }

      if (removedImageUrls != null) {
        for (int i = 0; i < removedImageUrls.length; i++) {
          await _imageProvider.removeImage(imageUrl: removedImageUrls[i]);
        }
      }

      if (byteDatas != null && byteDatas.length > 0) {
        final String imageFolder = '$userID/clubinfos/${post.imageFolder}';

        imageUrls = await _imageProvider.uploadPostImages(
            imageFolder: imageFolder, byteDatas: byteDatas);
      }

      if (alreadyImageUrls != null && alreadyImageUrls.length > 0) {
        imageUrls.addAll(alreadyImageUrls);
      }

      post.userID = userID;
      post.created = _firestoreTimestamp;
      post.lastUpdate = _firestoreTimestamp;
      post.imageUrls = imageUrls;

      if (post.postID != null && post.postID.isEmpty == false) {
        DocumentSnapshot snapshot =
            await _postProvider.updateClubInfo(data: post.data());

        ClubInfo updatedClubInfo = ClubInfo();
        updatedClubInfo.initialize(snapshot);
        updatedClubInfo.isFavorite = post.isFavorite;
        updatedClubInfo.favoriteCount = post.favoriteCount;
        updatedClubInfo.commentCount = post.commentCount;
        updatedClubInfo.viewCount = post.viewCount;

        return new SuccessClubInfoState(
            clubInfo: updatedClubInfo, isUpdate: true);
      }

      DocumentReference reference =
          await _postProvider.createClubInfo(data: post.data());
      if (reference == null) {
        return ErrorClubInfoState("error");
      }

      return new SuccessClubInfoState(clubInfo: post);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorClubInfoState(_?.toString());
    }
  }
}

class ViewClubInfoEvent extends ClubInfoEvent {
  ViewClubInfoEvent({@required this.post, @required this.userID});
  @override
  String toString() => 'ViewClubInfoEvent';
  final String userID;
  final ClubInfo post;

  @override
  Future<ClubInfoState> applyAsync(
      {ClubInfoState currentState, ClubInfoBloc bloc}) async {
    try {
      await _postProvider.addToView(postID: post.postID, userID: userID);
      await _shardsProvider.increaseViewCount(
          category: post.category(), postID: post.postID);

      return IdleClubInfoState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorClubInfoState(_?.toString());
    }
  }
}

class RemoveClubInfoEvent extends ClubInfoEvent {
  RemoveClubInfoEvent({@required this.post});
  @override
  String toString() => 'RemoveClubInfoEvent';

  final ClubInfo post;

  @override
  Future<ClubInfoState> applyAsync(
      {ClubInfoState currentState, ClubInfoBloc bloc}) async {
    try {
      if (post.imageUrls != null && post.imageUrls.length > 0) {
        for (var url in post.imageUrls) {
          await _imageProvider.removeImage(imageUrl: url);
        }
      }

      await _commentProvider.removeComments(
          postID: post.postID, category: CoreConst.clubInfoCategory);

      await _shardsProvider.removeClubInfoFavoriteCount(postID: post.postID);
      await _shardsProvider.removeCommentCount(postID: post.postID);
      await _shardsProvider.removeReportCount(postID: post.postID);
      await _shardsProvider.removeViewCount(postID: post.postID);

      await _postProvider.removeClubInfo(postID: post.postID);

      return new SuccessRemoveClubInfoState(clubInfo: post);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorClubInfoState(_?.toString());
    }
  }
}

class BindClubInfoEvent extends ClubInfoEvent {
  BindClubInfoEvent();
  @override
  String toString() => 'BindClubInfoEvent';

  @override
  Future<ClubInfoState> applyAsync(
      {ClubInfoState currentState, ClubInfoBloc bloc}) async {
    try {
      return new IdleClubInfoState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorClubInfoState(_?.toString());
    }
  }
}

class EditClubInfoEvent extends ClubInfoEvent {
  EditClubInfoEvent();
  @override
  String toString() => 'EditClubInfoEvent';

  @override
  Future<ClubInfoState> applyAsync(
      {ClubInfoState currentState, ClubInfoBloc bloc}) async {
    try {
      return new EditClubInfoState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorClubInfoState(_?.toString());
    }
  }
}
