import 'package:core/import.dart';

enum ProfileState { Default, Loading, Success, Failure }

class ProfileBloc with ChangeNotifier {
  final ProfileRepository _profileRepository;
  final ImageRepository _imageRepository;
  final PostRepository _postRepository;

  ByteData _profileImage;
  Profile _postProfile;
  Profile _userProfile;
  List<Profile> _profileSubscriptions;
  static List<Post> _latestProfileSubscriptionPosts;

  ProfileState _profileState = ProfileState.Default;
  ProfileState _profileSubscriptionState = ProfileState.Default;
  ProfileState _userProfileState = ProfileState.Default;
  ProfileState _postProfileState = ProfileState.Default;

  ProfileBloc.instance()
      : _profileRepository = ProfileRepository(),
        _imageRepository = ImageRepository(),
        _postRepository = PostRepository() {
    fetchUserProfile();
    fetchUserProfileSubscriptions();
  }

  // getters
  Future<bool> get hasProfile async {
    final String _userID = await AuthBloc().getUserID();
    final DocumentSnapshot _snapshot =
        await _profileRepository.hasProfile(userID: _userID);

    final bool _hasProfile =
        _snapshot.exists ? _snapshot.data['hasProfile'] : false;

    return _hasProfile == null || !_hasProfile ? false : true;
  }

  ByteData get profileImage => _profileImage;
  Profile get postProfile => _postProfile;
  Profile get userProfile => _userProfile;
  List<Profile> get profileSubscriptions => _profileSubscriptions;
  static List<Post> get latestProfileSubscriptionPosts =>
      _latestProfileSubscriptionPosts != null
          ? _latestProfileSubscriptionPosts
          : []; // returns empty list if _latestFollowingProfilePost is null

  ProfileState get profileState => _profileState;
  ProfileState get profileSubscriptionState => _profileSubscriptionState;
  ProfileState get userProfileState => _userProfileState;
  ProfileState get postProfileState => _postProfileState;

  // setters
  void setProfileImage({@required ByteData profileImage}) {
    _profileImage = profileImage;
    notifyListeners();
  }

  void setProfile({@required Profile postProfile}) {
    _postProfile = postProfile;
    notifyListeners();
  }

  void setUserProfile({@required Profile userProfile}) {
    _userProfile = userProfile;
    notifyListeners();
  }

  static void setLatestSubscribedProfilePost(
      {@required List<Post> followingProfilePosts}) {
    _latestProfileSubscriptionPosts = followingProfilePosts;
  }

  Future<void> togglePostLikeStatus(
      {@required Post post, @required String userID}) async {
    final bool _likeStatus = post.isLiked;
    final bool _newLikeStatus = !_likeStatus;

    final String _postID = post.postID;

    try {
      if (_newLikeStatus) {
        await _profileRepository.addToLike(postID: _postID, userID: userID);
      } else {
        await _profileRepository.removeFromLike(
            postID: _postID, userID: userID);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> toggleFollowProfilePageStatus(
      {@required Profile profile}) async {
    // final String _profileId = profile.userID;
    final String _userID = await AuthBloc().getUserID();

    final String _postUserId = profile.userID;

    final bool _followingStatus = profile.isFollowing;
    final bool _newFollowingStatus = !_followingStatus;

    try {
      if (_newFollowingStatus) {
        await _profileRepository.subscribeTo(
            postUserId: _postUserId, userID: _userID);
      } else {
        await _profileRepository.unsubscribeFrom(
            postUserId: _postUserId, userID: _userID);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Post> _getPost(
      {@required DocumentSnapshot document,
      @required Profile postUserProfile}) async {
    final String _currentUserId = await AuthBloc().getUserID();

    DocumentSnapshot _document = document;

    final String _postID = _document.documentID;
    final String _userID = _document.data['userID'];

    final Profile _profile = postUserProfile;

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

  Future<Profile> _fetchSubscribedProfile(
      {@required String postUserId, @required String currentUserId}) async {
    DocumentSnapshot _snapshot =
        await _profileRepository.fetchProfile(userID: postUserId);

    final Profile _postProfile = Profile(
      userID: _snapshot.documentID,
      firstName: _snapshot.data['firstName'],
      lastName: _snapshot.data['lastName'],
      businessName: _snapshot.data['businessName'],
      businessDescription: _snapshot.data['businessDescription'],
      phoneNumber: _snapshot.data['phoneNumber'],
      otherPhoneNumber: _snapshot.data['otherPhoneNumber'],
      businessLocation: _snapshot.data['businessLocation'],
      profileImageUrl: _snapshot.data['profileImageUrl'],
      hasProfile: _snapshot.data['hasProfile'],
      created: _snapshot.data['created'],
      lastUpdate: _snapshot.data['lastUpdate'],
    );

    // get post user following status for current user
    final bool _isFollowing = await _profileRepository.isSubscribedTo(
        postUserId: postUserId, userID: currentUserId);

    // get follower count
    final QuerySnapshot snapshot =
        await _profileRepository.fetchProfileSubscribers(userID: postUserId);
    final int _profileSubscribersCount = snapshot.documents.length;

    return _postProfile.copyWith(
        followersCount: _profileSubscribersCount, isFollowing: _isFollowing);
  }

  Future<Post> _fetchSubscribedLatestPosts(
      {@required String postUserId, @required Profile postUserProfile}) async {
    QuerySnapshot _snapshot =
        await _postRepository.fetchSubscribedLatestPosts(userID: postUserId);

    final List<Post> _latesPosts = [];

    for (int i = 0; i < _snapshot.documents.length; i++) {
      final DocumentSnapshot document = _snapshot.documents[i];
      final Post _post =
          await _getPost(document: document, postUserProfile: postUserProfile);

      _latesPosts.add(_post);
    }

    // return the first-post of this subscription profile
    return _latesPosts[0];
  }

  Future<void> fetchUserProfileSubscriptions() async {
    try {
      _profileSubscriptionState = ProfileState.Loading;
      notifyListeners();

      final String _userID = await AuthBloc().getUserID();

      final QuerySnapshot _snapshot =
          await _profileRepository.fetchProfileSubscriptions(userID: _userID);

      final List<Profile> profile = [];
      final List<Post> profileLatestPost = [];

      print(
          'UserProfileFollowing Snapshot lenght ${_snapshot.documents.length}');

      for (int i = 0; i < _snapshot.documents.length; i++) {
        final DocumentSnapshot document = _snapshot.documents[i];
        final String _profileId = document.documentID;
        final Profile _profile = await _fetchSubscribedProfile(
            postUserId: _profileId, currentUserId: _userID);

        final Post _profileLatestPost = await _fetchSubscribedLatestPosts(
            postUserId: _profileId, postUserProfile: _profile);

        profile.add(_profile);
        profileLatestPost.add(_profileLatestPost);
      }

      _profileSubscriptions = profile; // get profile of subscriptions
      _latestProfileSubscriptionPosts =
          profileLatestPost; // get profile-post first-post of subscriptions
      _profileSubscriptionState = ProfileState.Success;
      notifyListeners();

      return;
    } catch (e) {
      print(e.toString());

      _profileSubscriptionState = ProfileState.Failure;
      notifyListeners();
      return;
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      // _userProfileState = ProfileState.Loading;
      // notifyListeners();

      final String _userID = await AuthBloc().getUserID();
      DocumentSnapshot _snapshot =
          await _profileRepository.fetchProfile(userID: _userID);

      if (!_snapshot.exists) {
        print('UserId do not exit');
        return;
      }

      final Profile _userProfile = Profile(
        userID: _snapshot.documentID,
        firstName: _snapshot.data['firstName'],
        lastName: _snapshot.data['lastName'],
        businessName: _snapshot.data['businessName'],
        businessDescription: _snapshot.data['businessDescription'],
        phoneNumber: _snapshot.data['phoneNumber'],
        otherPhoneNumber: _snapshot.data['otherPhoneNumber'],
        businessLocation: _snapshot.data['businessLocation'],
        profileImageUrl: _snapshot.data['profileImageUrl'],
        hasProfile: _snapshot.data['hasProfile'],
        created: _snapshot.data['created'],
        lastUpdate: _snapshot.data['lastUpdate'],
      );

      final QuerySnapshot snapshot =
          await _profileRepository.fetchProfileSubscribers(userID: _userID);
      final int _userProfileFollowersCount = snapshot.documents.length;

      setUserProfile(
          userProfile: _userProfile.copyWith(
              followersCount: _userProfileFollowersCount));
      _userProfileState = ProfileState.Success;
      // notifyListeners();
      return;
    } catch (e) {
      print(e.toString());

      // _userProfileState = ProfileState.Failure;
      // notifyListeners();
      return;
    }
  }

  Future<bool> fetchProfile({@required String userID}) async {
    try {
      _postProfileState = ProfileState.Loading;
      notifyListeners();

      DocumentSnapshot _snapshot =
          await _profileRepository.fetchProfile(userID: userID);

      if (!_snapshot.exists) {
        print('UserId do not exit');
        return true;
      }

      final Profile _postProfile = Profile(
        userID: _snapshot.documentID,
        firstName: _snapshot.data['firstName'],
        lastName: _snapshot.data['lastName'],
        businessName: _snapshot.data['businessName'],
        businessDescription: _snapshot.data['businessDescription'],
        phoneNumber: _snapshot.data['phoneNumber'],
        otherPhoneNumber: _snapshot.data['otherPhoneNumber'],
        businessLocation: _snapshot.data['businessLocation'],
        profileImageUrl: _snapshot.data['profileImageUrl'],
        hasProfile: _snapshot.data['hasProfile'],
        created: _snapshot.data['created'],
        lastUpdate: _snapshot.data['lastUpdate'],
      );

      // get follower count
      final QuerySnapshot snapshot =
          await _profileRepository.fetchProfileSubscribers(userID: userID);
      final int _profileSubscribersCount = snapshot.documents.length;

      setProfile(
          postProfile:
              _postProfile.copyWith(followersCount: _profileSubscribersCount));

      _postProfileState = ProfileState.Success;
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());

      _postProfileState = ProfileState.Failure;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createProfile(
      {@required String firstName,
      @required String lastName,
      @required String businessName,
      @required String businessDescription,
      @required String phoneNumber,
      String otherPhoneNumber,
      @required String businessLocation}) async {
    try {
      _profileState = ProfileState.Loading;
      notifyListeners();

      final String _userID = await AuthBloc().getUserID();

      final String _profileImageUrl = await _imageRepository.saveProfileImage(
          userID: _userID, imageData: profileImage);

      await _profileRepository.createProfile(
        userID: _userID,
        firstName: firstName,
        lastName: lastName,
        businessName: businessName,
        businessDescription: businessDescription,
        phoneNumber: phoneNumber,
        otherPhoneNumber: otherPhoneNumber,
        businessLocation: businessLocation,
        profileImageUrl: _profileImageUrl,
      );

      _profileState = ProfileState.Success;
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());

      _profileState = ProfileState.Failure;
      notifyListeners();
      return false;
    }
  }
}
