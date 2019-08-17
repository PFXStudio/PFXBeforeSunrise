import 'package:before_sunrise/import.dart';

enum PostState { Default, Loading, Success, Failure }

class PostBloc with ChangeNotifier {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final ImageRepository _imageRepository;
  final ProfileBloc _profileBloc;
  final ProfileRepository _profileRepository;

  PostState _postState = PostState.Default;
  PostState _likePostState = PostState.Default;
  PostState _profilePostState = PostState.Default;

  List<Post> _posts = [];
  List<Post> _likedPosts = [];
  List<Post> _profilePosts = [];

  UniqueKey _postFormKey;

  bool _morePostsAvailable = true;
  bool _fetchingMorePosts = false;

  bool _moreProfilePostsAvailable = true;
  bool _fetchingMoreProfilePosts = false;

  PostBloc.instance()
      : _postRepository = PostRepository(),
        _authBloc = AuthBloc.instance(),
        _imageRepository = ImageRepository(),
        _profileBloc = ProfileBloc.instance(),
        _profileRepository = ProfileRepository() {
    fetchPosts();
    fetchLikedPosts();
  }

  // getters
  PostState get postState => _postState;
  PostState get likePostState => _likePostState;
  PostState get profilePostState => _profilePostState;

  List<Post> get posts => _posts;
  List<Post> get profilePosts => _profilePosts;
  List<Post> get likedPosts =>
      _likedPosts.where((Post post) => post.isLiked == true).toList();

  UniqueKey get postFormKey => _postFormKey;

  bool get morePostsAvailable => _morePostsAvailable;
  bool get fetchingMorePosts => _fetchingMorePosts;

  bool get moreProfilePostsAvailable => _moreProfilePostsAvailable;
  bool get fetchingMoreProfilePosts => _fetchingMoreProfilePosts;

  set postFormKey(UniqueKey formKey) {
    _postFormKey = formKey;
    print('This is the post form key $formKey');
    notifyListeners();
  }

  void ready() {
    _postState = PostState.Default;
  }

  // methods
  Future<List<String>> _uploadPostImage(
      {@required String userID, @required List<ByteData> datas}) async {
    try {
      final String fileLocation = '$userID/posts';

      final List<String> imageUrls = await _imageRepository.uploadPostImages(
          fileLocation: fileLocation, datas: datas);

      print('Image uploaded ${imageUrls.toList()}');
      return imageUrls;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Post> _getLikePost({String postID}) async {
    final String _currentUserId = await _authBloc.getUser; // get current-user

    DocumentSnapshot _document =
        await _postRepository.fetchPost(postID: postID);

    print('Get likePost');

    final String _postID = _document.documentID;
    final String _userID = _document.data['userID'];

    await _profileBloc.fetchProfile(userID: _userID);

    final Profile _profile =
        _profileBloc.postProfile; // fetch user for current post

    final _post = Post();
    _post.initialize(_document);

    // get post like status for current user
    final bool _isLiked =
        await _postRepository.isLiked(postID: _postID, userID: _currentUserId);

    // get post user following status for current user
    final bool _isFollowing = await _profileRepository.isSubscribedTo(
        postUserId: _userID, userID: _currentUserId);

    // get post like count
    QuerySnapshot _snapshot =
        await _postRepository.fetchPostLikes(postID: _postID);
    final int _postLikeCount = _snapshot.documents.length;

    return _post.copyWith(
        isLiked: _isLiked,
        likeCount: _postLikeCount,
        profile: _profile.copyWith(isFollowing: _isFollowing));
  }

  Future<Post> _getPost({DocumentSnapshot document}) async {
    final String _currentUserId = await _authBloc.getUser; // get current-user

    DocumentSnapshot _document = document;

    final String _postID = _document.documentID;
    final String _userID = _document.data['userID'];

    await _profileBloc.fetchProfile(
        userID: _userID); // fetch user for current post

    final Profile _profile = _profileBloc.postProfile;

    final _post = Post();
    _post.initialize(_document);

    // get post like status for current user
    final bool _isLiked =
        await _postRepository.isLiked(postID: _postID, userID: _currentUserId);

    // get post user following status for current user
    final bool _isFollowing = await _profileRepository.isSubscribedTo(
        postUserId: _userID, userID: _currentUserId);

    // get post like count
    QuerySnapshot _snapshot =
        await _postRepository.fetchPostLikes(postID: _postID);
    final int _postLikeCount = _snapshot.documents.length;

    return _post.copyWith(
        isLiked: _isLiked,
        likeCount: _postLikeCount,
        profile: _profile.copyWith(isFollowing: _isFollowing));
  }

  Future<void> toggleLikeStatus({@required Post post}) async {
    final Post _recievedPost = post;

    final bool _likeStatus = _recievedPost.isLiked;
    final bool _newLikeStatus = !_likeStatus;

    final String _userID = await _authBloc.getUser;
    final String _postID = _recievedPost.postID;

    final int _updatedLikeCount = _newLikeStatus
        ? _recievedPost.likeCount + 1
        : _recievedPost.likeCount - 1;

    final Post _updatedPost = _recievedPost.copyWith(
        isLiked: _newLikeStatus,
        likeCount: _updatedLikeCount); // update like status

    // get post index in _posts;
    final int _postIndex =
        _posts.indexWhere((Post post) => post.postID == _postID);

    if (_postIndex != -1) {
      _posts[_postIndex] =
          _updatedPost; // update post in List<post> (optimistic update) in _posts
    }

    final int _profilePostIndex = _profilePosts.indexWhere((Post post) =>
        post.postID == _postID); // get post index in _profilePosts;

    if (_profilePostIndex != -1) {
      _profilePosts[_profilePostIndex] =
          _updatedPost; // update post in List<post> (optimistic update) in _profilePost
    }

    // update post in List<post> (optimistic update) in ProfileBloc.latestFollowingProfilePost
    final List<Post> _latestFollowingProfilePost =
        ProfileBloc.latestProfileSubscriptionPosts;

    final latestFollowingProfilePostIndex = _latestFollowingProfilePost
        .indexWhere((Post post) => post.postID == _postID);

    if (latestFollowingProfilePostIndex != -1) {
      // ProfileBloc.latestFollowingProfilePost[latestFollowingProfilePostIndex] =
      //     _updatedPost;

      _latestFollowingProfilePost[latestFollowingProfilePostIndex] =
          _updatedPost;

      ProfileBloc.setLatestSubscribedProfilePost(
          followingProfilePosts: _latestFollowingProfilePost);
      notifyListeners();
    }

    // update post in List<post> (optimistic update) in _likedPosts
    if (_newLikeStatus) {
      _likedPosts.insert(0, _updatedPost);
    } else {
      _likedPosts.removeWhere((Post likedPost) => likedPost.postID == _postID);
    }
    notifyListeners();

    try {
      if (_newLikeStatus) {
        await _postRepository.addToLike(postID: _postID, userID: _userID);
      } else {
        await _postRepository.removeFromLike(postID: _postID, userID: _userID);
      }

      // set post like in user collection
      await _profileBloc.togglePostLikeStatus(post: post, userID: _userID);

      return;
    } catch (e) {
      print(e.toString());

      final int _updatedLikeCount = !_newLikeStatus
          ? _recievedPost.likeCount + 1
          : _recievedPost.likeCount - 1;

      final Post _updatedPost = _recievedPost.copyWith(
          isLiked: !_newLikeStatus, likeCount: _updatedLikeCount);

      if (_postIndex != -1) {
        _posts[_postIndex] = _updatedPost;
      }

      if (_profilePostIndex != -1) {
        // _profilePosts[_profilePostIndex] =
        //     _updatedPost; // update post in List<post> (optimistic update) in _profilePost

        _latestFollowingProfilePost[latestFollowingProfilePostIndex] =
            _updatedPost;

        ProfileBloc.setLatestSubscribedProfilePost(
            followingProfilePosts: _latestFollowingProfilePost);
        notifyListeners();
      }

      if (_newLikeStatus) {
        _likedPosts
            .removeWhere((Post likedPost) => likedPost.postID == _postID);
      } else {
        _likedPosts.insert(0, _updatedPost);
      }
      notifyListeners();
    }
  }

  Future<void> toggleFollowProfilePageStatus(
      {@required Profile currentPostProfile}) async {
    final Profile _profile = currentPostProfile;
    final String _currentUserId = await _authBloc.getUser;

    final bool _followingStatus = _profile.isFollowing;
    final bool _newFollowingStatus = !_followingStatus;

    final int _updateFollowersCount = _newFollowingStatus
        ? _profile.followersCount + 1
        : _profile.followersCount - 1;

    final Profile _updatedProfile = _profile.copyWith(
        isFollowing: _newFollowingStatus,
        followersCount: _updateFollowersCount);

    final List<Post> _userPosts = _posts
        .where((Post post) => post.userID == currentPostProfile.userID)
        .toList(); // get all posts with current post userID

    for (int i = 0; i < _userPosts.length; i++) {
      final String _postID = _userPosts[i].postID;
      final Post _updatedPost =
          _userPosts[i].copyWith(profile: _updatedProfile);

      final int _postIndex =
          _posts.indexWhere((Post post) => post.postID == _postID);

      _posts[_postIndex] = _updatedPost;
      notifyListeners();
    }

    try {
      if (_newFollowingStatus) {
        await _profileRepository.addToSubscribers(
            postUserId: _profile.userID, userID: _currentUserId);
      } else {
        await _profileRepository.removeFromSubscribers(
            postUserId: _profile.userID, userID: _currentUserId);
      }

      // set user following in user collection
      await _profileBloc.toggleFollowProfilePageStatus(profile: _profile);

      return;
    } catch (e) {
      print(e.toString());

      final int _updateFollowersCount = !_newFollowingStatus
          ? _profile.followersCount + 1
          : _profile.followersCount - 1;

      final Profile _updatedProfile = _profile.copyWith(
          isFollowing: _newFollowingStatus,
          followersCount: _updateFollowersCount);

      final List<Post> _userPosts = _posts
          .where((Post post) => post.userID == _profile.userID)
          .toList(); // get all posts with current post userID

      _userPosts.forEach((Post post) {
        final String _postID = post.postID;
        final Post _updatedPost = post.copyWith(profile: _updatedProfile);

        final int _postIndex =
            _posts.indexWhere((Post post) => post.postID == _postID);

        _posts[_postIndex] = _updatedPost;
        notifyListeners();
      });
    }
  }

  Future<void> fetchLikedPosts() async {
    try {
      _likePostState = PostState.Loading;
      notifyListeners();

      final String _currentUserId = await _authBloc.getUser;
      QuerySnapshot _snapshot = await _profileRepository.fetchProfileLikedPosts(
          userID: _currentUserId);

      List<Post> posts = [];

      for (int i = 0; i < _snapshot.documents.length; i++) {
        final DocumentSnapshot document = _snapshot.documents[i];
        final String _postID = document.documentID;
        final Post _post = await _getLikePost(postID: _postID);

        posts.add(_post);
      }

      _likedPosts = posts;

      _likePostState = PostState.Success;
      notifyListeners();
      return;
    } catch (e) {
      print(e.toString());

      _likePostState = PostState.Failure;
      notifyListeners();
    }
  }

  Future<void> fetchPosts() async {
    try {
      _postState = PostState.Loading;
      notifyListeners();

      QuerySnapshot _snapshot =
          await _postRepository.fetchPosts(lastVisiblePost: null);

      List<Post> posts = [];

      for (int i = 0; i < _snapshot.documents.length; i++) {
        final DocumentSnapshot document = _snapshot.documents[i];
        final Post _post = await _getPost(document: document);

        posts.add(_post);
      }
      _posts = posts;

      _postState = PostState.Success;
      notifyListeners();

      return;
    } catch (e) {
      print(e.toString());

      _postState = PostState.Failure;
      notifyListeners();
      return;
    }
  }

  Future<void> fetchMorePosts() async {
    try {
      final List<Post> currentPosts = _posts;
      final Post lastVisiblePost = currentPosts[currentPosts.length - 1];

      if (_fetchingMorePosts == true) {
        print('Fetching more categories!');
        return;
      }

      _morePostsAvailable = true;
      _fetchingMorePosts = true;
      notifyListeners();

      final QuerySnapshot _snapshot =
          await _postRepository.fetchPosts(lastVisiblePost: lastVisiblePost);

      if (_snapshot.documents.length < 1) {
        _morePostsAvailable = false;
        _fetchingMorePosts = false;
        notifyListeners();
        print('No more post available!');
        return;
      }

      List<Post> posts = [];

      for (int i = 0; i < _snapshot.documents.length; i++) {
        final DocumentSnapshot document = _snapshot.documents[i];
        final Post _post = await _getPost(document: document);

        posts.add(_post);
      }

      posts.isEmpty ? _posts = currentPosts : _posts += posts;
      _fetchingMorePosts = false;
      notifyListeners();

      return;
    } catch (e) {
      print(e.toString());

      _fetchingMorePosts = false;
      return;
    }
  }

  Future<void> fetchProfilePosts({@required String userID}) async {
    try {
      _profilePostState = PostState.Loading;
      notifyListeners();

      QuerySnapshot _snapshot = await _postRepository.fetchProfilePosts(
          lastVisiblePost: null, userID: userID);

      List<Post> profilePosts = [];

      for (int i = 0; i < _snapshot.documents.length; i++) {
        final DocumentSnapshot document = _snapshot.documents[i];
        final Post _post = await _getPost(document: document);

        profilePosts.add(_post);
      }
      _profilePosts = profilePosts;

      _profilePostState = PostState.Success;
      notifyListeners();

      return;
    } catch (e) {
      print(e.toString());

      _profilePostState = PostState.Failure;
      notifyListeners();
      return;
    }
  }

  Future<void> fetchMoreProfilePosts({@required String userID}) async {
    try {
      final List<Post> currentProfilePosts = _profilePosts;
      final Post lastVisiblePost =
          currentProfilePosts[currentProfilePosts.length - 1];

      if (_fetchingMoreProfilePosts == true) {
        print('Fetching more profile posts!');
        return;
      }

      _moreProfilePostsAvailable = true;
      _fetchingMoreProfilePosts = true;
      notifyListeners();

      final QuerySnapshot _snapshot = await _postRepository.fetchProfilePosts(
          lastVisiblePost: lastVisiblePost, userID: userID);

      if (_snapshot.documents.length < 1) {
        _moreProfilePostsAvailable = false;
        _fetchingMoreProfilePosts = false;
        notifyListeners();
        print('No more profile post available!');
        return;
      }

      List<Post> profilePosts = [];

      for (int i = 0; i < _snapshot.documents.length; i++) {
        final DocumentSnapshot document = _snapshot.documents[i];
        final Post _post = await _getPost(document: document);

        profilePosts.add(_post);
      }

      profilePosts.isEmpty
          ? _profilePosts = currentProfilePosts
          : _profilePosts += profilePosts;
      _fetchingMoreProfilePosts = false;
      notifyListeners();

      return;
    } catch (e) {
      print(e.toString());

      _fetchingMoreProfilePosts = false;
      return;
    }
  }

  Future<bool> createPost({
    @required Post post,
    @required List<ByteData> datas,
  }) async {
    try {
      _postState = PostState.Loading;
      notifyListeners();

      final String userID = await _authBloc.getUser;
      post.userID = userID;

      List<String> imageUrls = [];
      if (datas != null && datas.length > 0) {
        imageUrls = await _uploadPostImage(userID: userID, datas: datas);
      }
      post.imageUrls = imageUrls;

      await _postRepository.createPost(data: post.data());

      _postState = PostState.Success;
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());
      _postState = PostState.Failure;
      notifyListeners();

      return false;
    }
  }
}
