import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/import.dart' as prefix0;
import 'package:timeago/timeago.dart' as timeago;

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({
    Key key,
    @required Post post,
  })  : _post = post,
        super(key: key);

  static const String routeName = "/postDetailScreen";

  final Post _post;

  @override
  PostDetailScreenState createState() {
    return new PostDetailScreenState();
  }
}

class PostDetailScreenState extends State<PostDetailScreen> {
  final PostBloc _postBloc = PostBloc();
  Post get _post => widget._post;
  int _currentPostImageIndex = 0;
  GlobalKey moreMenuKey = GlobalKey();

  Widget _buildActivePostImage() {
    return Container(
      width: 9.0,
      height: 9.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(width: 2.0, color: Theme.of(context).accentColor),
      ),
    );
  }

  Widget _buildInactivePostImage() {
    return Container(
        width: 8.0,
        height: 8.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey));
    // shape: BoxShape.circle, color: Color.fromRGBO(0, 0, 0, 0.4)));
  }

  Widget _buildPostImageCarouselIndicator() {
    List<Widget> dots = [];

    for (int i = 0; i < _post.imageUrls.length; i++) {
      dots.add(i == _currentPostImageIndex
          ? _buildActivePostImage()
          : _buildInactivePostImage());
    }

    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 20.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: dots,
      ),
    );
  }

  Widget _buildPostImageCarousel() {
    final double _deviceHeight = MediaQuery.of(context).size.height * 0.7;

    return CarouselSlider(
        height: _deviceHeight,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        onPageChanged: (int index) {
          setState(() {
            _currentPostImageIndex = index;
          });
        },
        items: _post.imageUrls.map((dynamic postImageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return CachedNetworkImage(
                imageUrl: '${postImageUrl.toString()}',
                placeholder: (context, imageUrl) =>
                    Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                errorWidget: (context, imageUrl, error) =>
                    Center(child: Icon(FontAwesomeIcons.exclamationCircle)),
                imageBuilder: (BuildContext context, ImageProvider image) {
                  return Hero(
                    tag: '${_post.postID}_${_post.imageUrls[0]}',
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: image, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }).toList());
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _post.profile.imageUrl != null && _post.profile.imageUrl.length > 0
            ? CachedNetworkImage(
                imageUrl: '${_post.profile.imageUrl}',
                placeholder: (context, imageUrl) =>
                    Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                errorWidget: (context, imageUrl, error) =>
                    Center(child: Icon(FontAwesomeIcons.exclamationCircle)),
                imageBuilder: (BuildContext context, ImageProvider image) {
                  return Hero(
                    tag: '${_post.postID}_${_post.profile.imageUrl}',
                    child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.0),
                          image:
                              DecorationImage(image: image, fit: BoxFit.cover),
                        )),
                  );
                },
              )
            : Hero(
                tag: '${_post.postID}_${_post.profile.imageUrl}',
                child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.0),
                      image: DecorationImage(
                          image: ExactAssetImage('assets/avatars/avatar.png'),
                          fit: BoxFit.fill),
                    )),
              ),
        SizedBox(width: 10.0),
        Hero(
          tag: '${_post.postID}_${_post.profile.nickname}',
          child: Text(
            '${_post.profile.nickname}',
            style: MainTheme.nickNameStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildPostCardBackgroundImage() {
    final double _deviceWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: _deviceWidth,
          color: MainTheme.bgndColor,
          child: _post.imageUrls.length > 0
              ? _buildPostImageCarousel()
              : Image.asset('assets/images/bgnd_empty.png',
                  fit: BoxFit.fitWidth),
        ),
        Positioned(
          bottom: 0.0,
          height: 80.0,
          width: _deviceWidth,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                  ]),
            ),
          ),
        ),
        _post.imageUrls.length > 1
            ? _buildPostImageCarouselIndicator()
            : Container(),
        Positioned(
          top: 0.0,
          height: 60.0,
          width: _deviceWidth,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                  ]),
            ),
          ),
        ),
        // Align(
        //   alignment: Alignment.topRight,
        //   child: Container(
        //     padding: EdgeInsets.only(top: 50.0),
        //     child:
        //   ),
        // ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context,
      {@required double deviceHeight}) {
    return SliverAppBar(
      centerTitle: true,
      title: _buildTitleRow(),
      expandedHeight: deviceHeight * 0.7,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildPostCardBackgroundImage(),
      ),
      actions: <Widget>[
        Material(
          color: Colors.transparent,
          child: IconButton(
            key: moreMenuKey,
            icon: Icon(FontAwesomeIcons.ellipsisV),
            onPressed: () {
              _touchedMoreButton(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommentTag() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        LikePostWidget.icon(
          isSparkleStay: false,
          isLiked: _post.isLiked,
          counter: _post.likeCount,
          defaultIcon: FontAwesomeIcons.kissBeam,
          filledIcon: FontAwesomeIcons.solidKissWinkHeart,
          countCircleColor: MainTheme.enabledButtonColor,
          defaultIconColor: MainTheme.enabledButtonColor,
          hasShadow: true,
          sparkleColor: MainTheme.pivotColor,
          shadowColor: MainTheme.enabledButtonColor,
          filledIconColor: MainTheme.enabledButtonColor,
          clapFabCallback: (callback) {
            PostBloc().dispatch(
                ToggleLikePostEvent(post: _post, isLike: !_post.isLiked));
            _post.isLiked = !_post.isLiked;
            if (_post.isLiked == true) {
              _post.likeCount++;
            } else {
              _post.likeCount--;
            }

            if (callback == null) {
              return;
            }

            print("isLiked : ${_post.isLiked}, count : ${_post.likeCount}");
            callback(_post.isLiked, _post.likeCount);

            // });
          },
        ),
      ],
    );
  }

  Widget _buildPostTitleInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          timeago.format(_post.lastUpdate.toDate(), locale: 'ko'),
          style: MainTheme.timeTextStyle,
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                '${_post.title}',
                overflow: TextOverflow.fade,
                style: MainTheme.titleTextStyle,
              ),
            ),
            _buildCommentTag(),
          ],
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Contents',
          style: MainTheme.barTitleTextStyle,
        ),
        SizedBox(height: 10.0),
        Text(
          '${_post.contents}',
          softWrap: true,
          textAlign: TextAlign.justify,
          style: MainTheme.contentsTextStyle,
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildYoutube() {
    if (_post.youtubeUrl == null || _post.youtubeUrl.length <= 0) {
      return SizedBox();
    }

    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Youtube',
          style: MainTheme.barTitleTextStyle,
        ),
        SizedBox(height: 10.0),
        InkWell(
          onTap: () {
            launchVideo(_post.youtubeUrl);
          },
          child: Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.youtube, size: 15.0),
              SizedBox(width: 5.0),
              Expanded(
                  child: Text(
                _post.youtubeUrl,
                style: MainTheme.contentsTextStyle,
              )),
            ],
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildPostDetails() {
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;

    final double _contentHeight = _deviceHeight * 0.7;

    final double _contentWidthPadding =
        _deviceWidth > 450.0 ? _deviceWidth - 450.0 : 30.0;

    return Material(
      elevation: 5.0,
      child: Container(
        height: _contentHeight,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: _contentWidthPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SanctionContents(),
                    _buildPostTitleInfo(),
                    _buildContents(),
                    _buildYoutube(),
                    // add similar posts
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverList() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          child: Column(
            children: <Widget>[
              _buildPostDetails(),
            ],
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceHeight = MediaQuery.of(context).size.height;
    double _panelHeightOpen = 575.0;
    double _panelHeightClosed = 95.0;
    final double _initFabHeight = 120.0;
    double _fabHeight;
    // final double _deviceWidth = MediaQuery.of(context).size.width;

    // final PostBloc _postbloc = Provider.of<PostBloc>(context);

    return Scaffold(
      // floatingActionButton: _buildControlFAB(),
      backgroundColor: MainTheme.bgndColor,
      body: Stack(
        children: [
          // Container(
          //   decoration: new BoxDecoration(
          //     gradient: MainTheme.primaryLinearGradient,
          //   ),
          // ),
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: Stack(
              children: <Widget>[
                SafeArea(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      _buildSliverAppBar(context, deviceHeight: _deviceHeight),
                      _buildSliverList(),
                    ],
                  ),
                )
              ],
            ),
            panel: _panel(),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),
        ],
      ),
    );
  }

  Widget _panel() {
    final CommentBloc _commentBloc = CommentBloc();
    final Comment comment = Comment();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
              color: MainTheme.bgndColor,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0))),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 150,
                    child: BlocListener(
                        bloc: _commentBloc,
                        listener: (context, state) async {
                          print(state.toString());
                          if (state is SuccessCommentState) {
                            widget._post.commentCount++;
                          }
                        },
                        child: BlocBuilder<CommentBloc, CommentState>(
                            bloc: _commentBloc,
                            builder: (
                              BuildContext context,
                              CommentState currentState,
                            ) {
                              return FlatIconTextButton(
                                  color: Colors.white,
                                  iconData: FontAwesomeIcons.comment,
                                  text:
                                      "Comments (${widget._post.commentCount})");
                            })),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
        CommentList(
            category: widget._post.category, postID: widget._post.postID),
      ],
    );
  }

  void _touchedMoreButton(BuildContext context) {
    bool isMine = _post.userID == ProfileBloc().signedProfile.userID;
    List<OptionItem> menuItems = [
      OptionItem(
          index: 0,
          title: '공유',
          image: Icon(
            FontAwesomeIcons.share,
            color: Colors.white,
          )),
      OptionItem(
          index: 1,
          title: '신고',
          image: Icon(
            FontAwesomeIcons.handMiddleFinger,
            color: Colors.white,
          )),
    ];

    if (isMine == true) {
      menuItems.add(OptionItem(
          index: 2,
          title: '삭제',
          image: Icon(
            FontAwesomeIcons.trash,
            color: Colors.white,
          )));
      // menuItems.add(OptionItem(
      //     index: 3,
      //     title: '삭제',
      //     image: Icon(
      //       FontAwesomeIcons.trash,
      //       color: Colors.white,
      //     )));
    }
    OptionMenu.context = context;
    OptionMenu menu = OptionMenu(
        backgroundColor: Colors.black54,
        items: menuItems,
        onClickMenu: onClickMenu,
        onDismiss: onDismiss);

    menu.show(widgetKey: moreMenuKey);
  }

  void onClickMenu(item) {
    OptionItem optionItem = item;

    print(optionItem.index);
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onDismiss() {}
}
