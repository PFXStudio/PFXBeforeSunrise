import 'package:before_sunrise/import.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/profile";
  ProfileScreen({
    Key key,
    @required this.profile,
  }) : super(key: key);

  final Profile profile;

  @override
  ProfileScreenState createState() {
    return new ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  final MyPostBloc _myPostBloc = MyPostBloc();

  Profile get _profile => widget.profile;

  int _currentDisplayedPageIndex = 0;
  bool _isCurrentUserProfile = false;
  List<Post> _posts = List<Post>();
  bool _enabeldMorePosts = false;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _myPostBloc.dispatch(
        LoadMyPostEvent(category: DefineStrings.categories.first, post: null));
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      print('sroll next');
      _myPostBloc.dispatch(LoadMyPostEvent(post: null));
    }
  }

  bool isMyProfile() {
    if (widget.profile.userID == ProfileBloc().signedProfile.userID) {
      return true;
    }

    return false;
  }

  SliverAppBar _buildSliverAppBar(
      BuildContext context, double _deviceHeight, double _deviceWidth) {
    return SliverAppBar(
      pinned: true,
      title: Text(
        '${_profile.nickname}',
      ),
      expandedHeight: 360.0,
      actions: <Widget>[
        Icon(FontAwesomeIcons.ellipsisV),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildFlexibleSpace(
            context: context,
            deviceHeight: _deviceHeight,
            deviceWidth: _deviceWidth),
      ),
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(5.0),
          child: ProfileBottomBar(
            isCurrentUserProfile: _isCurrentUserProfile,
            onActiveIndexChange: (int index) {
              setState(() {
                _currentDisplayedPageIndex = index;
              });

// TODO :
              // if (_currentDisplayedPageIndex == 0) {
              //   _myPostBloc.fetchProfilePosts(userId: _profile.userId);
              // } else if (_currentDisplayedPageIndex == 1) {
              //   _profileBloc.fetchUserProfileFollowing();
              // }

              print(_currentDisplayedPageIndex);
            },
          )),
    );
  }

  Widget _buildProfileAvatar() {
    return _profile.hasProfileImage()
        ? CachedNetworkImage(
            imageUrl: '${_profile.imageUrl}',
            placeholder: (context, imageUrl) =>
                Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
            errorWidget: (context, imageUrl, error) =>
                Center(child: Icon(FontAwesomeIcons.exclamationCircle)),
            imageBuilder: (BuildContext context, ImageProvider image) {
              return Hero(
                tag: '${_profile.imageUrl}',
                child: Container(
                  height: 120.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: image, fit: BoxFit.cover),
                    border: Border.all(width: 1.0, color: Colors.white),
                  ),
                ),
              );
            },
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Image.asset('assets/avatars/avatar.png', fit: BoxFit.cover),
          );
  }

  Widget _buildProfileName() {
    return Text(
      '${_profile.nickname}',
      style: TextStyle(
          color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildProfileFollowButton() {
    return Consumer<MyPostBloc>(
        builder: (BuildContext context, MyPostBloc postBloc, Widget child) {
      final double _containerHeight = _profile.isFollowing ? 30.0 : 30.0;
      final double _containerWidth =
          _isCurrentUserProfile ? 100.0 : _profile.isFollowing ? 110.0 : 140.0;

      return Material(
        elevation: 10.0,
        type: MaterialType.button,
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          splashColor: Colors.black38,
          borderRadius: BorderRadius.circular(20.0),
          onTap: _isCurrentUserProfile
              ? null
              : () {
                  // TODO :
                  // postBloc.toggleFollowProfilePageStatus(
                  //     currentPostProfile: _profile);
                },
          child: AnimatedContainer(
            height: _containerHeight,
            width: _containerWidth,
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _isCurrentUserProfile
                    ? Container()
                    : _profile.isFollowing
                        ? Flexible(
                            child: Center(
                              child: Icon(
                                FontAwesomeIcons.smileWink,
                                size: 20.0,
                                color: Colors.black38,
                                // color: Colors.red,
                              ),
                            ),
                          )
                        : Flexible(
                            child: Text(
                              'Follow',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  // color: Colors.black45,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                _isCurrentUserProfile ? Container() : SizedBox(width: 5.0),
                _isCurrentUserProfile
                    ? Container()
                    : Container(
                        height: 15.0,
                        width: 1.0,
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                _isCurrentUserProfile ? Container() : SizedBox(width: 10.0),
                Text(
                  '${_profile.followersCount} ${_profile.followersCount > 1 ? 'followers' : 'follower'}',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProfileContactButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              shape: BoxShape.circle),
          child: IconButton(
            tooltip: 'Call ${_profile.nickname}',
            icon: Icon(
              FontAwesomeIcons.mobileAlt,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(width: 10.0),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              shape: BoxShape.circle),
          child: IconButton(
            tooltip: 'Chat with ${_profile.nickname}',
            icon: Icon(
              FontAwesomeIcons.comment,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildFlexibleSpace(
      {@required BuildContext context,
      @required double deviceHeight,
      @required double deviceWidth}) {
    return Container(
      height: 200.0,
      width: deviceWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildProfileAvatar(),
          SizedBox(height: 5.0),
          _buildProfileName(),
          SizedBox(height: 5.0),
          // _buildProfileFollowButton(),
          SizedBox(height: 10.0),
          _buildProfileContactButtons(),
        ],
      ),
    );
  }

  Widget _buildDynamicSliverContent() {
    Widget _dynamicSliverContent;

    switch (_currentDisplayedPageIndex) {
      case 0:
        _dynamicSliverContent = TimelineTabPage(
          posts: _posts,
          enabeldMorePosts: _enabeldMorePosts,
        );
        break;
      default:
        _dynamicSliverContent = ProfileTabPage(profile: _profile);
        break;

      //   case 1:
      //     _dynamicSliverContent = isMyProfile()
      //         ? SubscriptionTabPage(isRefreshing: _isRefreshing)
      //         : ProfileTabPage(profile: _profile);
      //     break;

      //   case 2:
      //     break;

      //   default:
      //     _dynamicSliverContent = TimelineTabPage(
      //         userId: _profile.userId, isRefreshing: _isRefreshing);
      //     break;
    }
    return _dynamicSliverContent;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPostBloc, MyPostState>(
        bloc: _myPostBloc,
        builder: (
          BuildContext context,
          MyPostState currentState,
        ) {
          if (currentState is FetchingMyPostState) {
            if (_posts.length == 0) {
              return _buildLoadingPosts(context);
            }

            return _buildPosts(context, null);
          }

          if (currentState is FetchedMyPostState) {
            return _buildPosts(context, currentState.posts);
          }

          return _buildPosts(context, null);

          // if (currentState is FetchingPostState) {
          //   if (_posts.length == 0) {
          //     return Center(
          //       child: CircularProgressIndicator(),
          //     );
          //   }

          //   return _buildPosts(null);
          // }

          // if (currentState is FetchedPostState) {
          //   return _buildPosts(currentState.posts);
          // }

          // return _buildPosts(null);
        });
  }

  Widget _buildLoadingPosts(BuildContext context) {
    final double _deviceHeight = kDeviceHeight;
    final double _deviceWidth = kDeviceWidth;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          _buildSliverAppBar(context, _deviceHeight, _deviceWidth),
          SliverToBoxAdapter(
              child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 30,
              bottom: 30,
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildPosts(BuildContext context, List<Post> posts) {
    final double _deviceHeight = kDeviceHeight;
    final double _deviceWidth = kDeviceWidth;
    _enabeldMorePosts = false;
    if (posts != null) {
      if (posts.length >= CoreConst.maxLoadPostCount) {
        _enabeldMorePosts = true;
      }

      if (posts.length > 0) {
        _posts.addAll(posts);
        posts.clear();
      }
    }

    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () async {
              _posts.clear();
              _enabeldMorePosts = true;
              this._myPostBloc.dispatch(LoadMyPostEvent(post: null));
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (_currentDisplayedPageIndex == 1) {
                  return;
                }

                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  print(_myPostBloc.currentState.toString());
                  _loadMore();
                }
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  _buildSliverAppBar(context, _deviceHeight, _deviceWidth),
                  _buildDynamicSliverContent(),
                ],
              ),
            )));
  }

  void _loadMore() {
    if (_enabeldMorePosts == false) {
      return;
    }

    _enabeldMorePosts = false;
    if (_posts.length > 0) {
      Post post = _posts.last;
      this._myPostBloc.dispatch(LoadMyPostEvent(post: post));
      return;
    }
  }
}
