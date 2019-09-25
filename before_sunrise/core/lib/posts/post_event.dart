import 'package:core/import.dart';

@immutable
abstract class PostEvent {
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc});
}

class LoadPostEvent extends PostEvent {
  LoadPostEvent({@required this.category, @required this.post});
  @override
  String toString() => 'LoadPostEvent';
  final IPostProvider _postProvider = PostProvider();
  final IProfileProvider _profileProvider = ProfileProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  final String category;
  final Post post;

  @override
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc}) async {
    try {
      QuerySnapshot snapshot = await _postProvider.fetchPosts(
          category: category, lastVisiblePost: post);
      List<Post> posts = List<Post>();
      if (snapshot == null) {
        return EmptyPostState();
      }
      if (snapshot.documents.length <= 0) {
        return EmptyPostState();
      }

      String userID = await _authProvider.getUserID();
      for (var document in snapshot.documents) {
        Post post = Post();
        post.initialize(document);
        DocumentSnapshot snapshot =
            await _profileProvider.fetchProfile(userID: post.userID);
        Profile profile = Profile();
        profile.initialize(snapshot);
        post.profile = profile;

        post.isLike = await _postProvider.isLike(
            category: post.category, postID: post.postID, userID: userID);
        DocumentSnapshot likeSnapshot =
            await _shardsProvider.postLikeCount(postID: post.postID);
        if (likeSnapshot != null && likeSnapshot.data != null) {
          post.likeCount = likeSnapshot.data["count"];
        }

        DocumentSnapshot commentSnapshot =
            await _shardsProvider.commentCount(postID: post.postID);
        if (commentSnapshot != null && commentSnapshot.data != null) {
          post.commentCount = commentSnapshot.data["count"];
        }

        DocumentSnapshot reportSnapshot =
            await _shardsProvider.reportCount(postID: post.postID);
        if (reportSnapshot != null && reportSnapshot.data != null) {
          post.warningCount = reportSnapshot.data["count"];
        }

        DocumentSnapshot viewSnapshot =
            await _shardsProvider.viewCount(postID: post.postID);
        if (viewSnapshot != null && viewSnapshot.data != null) {
          post.viewCount = viewSnapshot.data["count"];
        }

        posts.add(post);
      }

      return new FetchedPostState(posts: posts);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}

class ToggleLikePostEvent extends PostEvent {
  ToggleLikePostEvent({@required this.post, this.isLike});
  @override
  String toString() => 'ToggleLikePostEvent';
  final IPostProvider _postProvider = PostProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();

  final Post post;
  final bool isLike;

  @override
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      if (isLike == true) {
        await _postProvider.addToLike(
            category: post.category, postID: post.postID, userID: userID);
        await _shardsProvider.increasePostLikeCount(
            category: post.category, postID: post.postID);
      } else {
        await _postProvider.removeFromLike(
            category: post.category, postID: post.postID, userID: userID);
        await _shardsProvider.decreasePostLikeCount(
            category: post.category, postID: post.postID);
      }

      return currentState;
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}

class CreatePostEvent extends PostEvent {
  CreatePostEvent(
      {@required this.post,
      @required this.byteDatas,
      this.removedImageUrls,
      this.alreadyImageUrls})
      : _firestoreTimestamp = FieldValue.serverTimestamp();
  @override
  String toString() => 'CreatePostEvent';
  final IPostProvider _postProvider = PostProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IFImageProvider _imageProvider = FImageProvider();
  FieldValue _firestoreTimestamp;
  List<ByteData> byteDatas;
  List<String> removedImageUrls;
  List<String> alreadyImageUrls;

  Post post;

  @override
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc}) async {
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
        final String imageFolder = '$userID/posts/${post.imageFolder}';

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
        DocumentSnapshot snapshot = await _postProvider.updatePost(
            category: post.category, data: post.data());

        Post updatedPost = Post();
        updatedPost.initialize(snapshot);
        updatedPost.profile = post.profile;
        updatedPost.isLike = post.isLike;
        updatedPost.likeCount = post.likeCount;
        updatedPost.commentCount = post.commentCount;
        updatedPost.warningCount = post.warningCount;
        updatedPost.viewCount = post.viewCount;

        return new SuccessPostState(post: updatedPost);
      }

      DocumentReference reference = await _postProvider.createPost(
          category: post.category, data: post.data());
      if (reference == null) {
        return ErrorPostState("error");
      }

      return new SuccessPostState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}

class ReportPostEvent extends PostEvent {
  ReportPostEvent({@required this.post, @required this.isReport});
  @override
  String toString() => 'ReportPostEvent';
  final IPostProvider _postProvider = PostProvider();
  final IAuthProvider _authProvider = AuthProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();

  Post post;
  bool isReport = false;

  @override
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc}) async {
    try {
      String userID = await _authProvider.getUserID();
      if (isReport == true) {
        await _postProvider.addToReport(
            category: post.category, postID: post.postID, userID: userID);
        await _shardsProvider.increaseReportCount(
            category: post.category, postID: post.postID);
      } else {
        await _postProvider.removeFromReport(
            category: post.category, postID: post.postID, userID: userID);
        await _shardsProvider.decreaseReportCount(
            category: post.category, postID: post.postID);
      }

      return currentState;
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}

class ViewPostEvent extends PostEvent {
  ViewPostEvent({@required this.post, @required this.userID});
  @override
  String toString() => 'ViewPostEvent';
  final IPostProvider _postProvider = PostProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();

  String userID;
  Post post;

  @override
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc}) async {
    try {
      await _postProvider.addToView(
          category: post.category, postID: post.postID, userID: userID);
      await _shardsProvider.increaseViewCount(
          category: post.category, postID: post.postID);

      return FetchedPostState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}

class RemovePostEvent extends PostEvent {
  RemovePostEvent({@required this.post});
  @override
  String toString() => 'RemovePostEvent';
  final IPostProvider _postProvider = PostProvider();
  final IShardsProvider _shardsProvider = ShardsProvider();
  final IProfileProvider _profileProvider = ProfileProvider();
  final IFImageProvider _imageProvider = FImageProvider();
  final ICommentProvider _commentProvider = CommentProvider();

  Post post;

  @override
  Future<PostState> applyAsync({PostState currentState, PostBloc bloc}) async {
    try {
      if (post.imageUrls != null && post.imageUrls.length > 0) {
        for (var url in post.imageUrls) {
          await _imageProvider.removeImage(imageUrl: url);
        }
      }

      await _commentProvider.removeComments(
          postID: post.postID, category: post.category);

      await _shardsProvider.removePostLikeCount(postID: post.postID);
      await _shardsProvider.removeCommentCount(postID: post.postID);
      await _shardsProvider.removeReportCount(postID: post.postID);
      await _shardsProvider.removeViewCount(postID: post.postID);

      await _postProvider.removePost(
          postID: post.postID, category: post.category);

      return new SuccessRemovePostState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorPostState(_?.toString());
    }
  }
}
