import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart';

class PostItemCardDefault extends StatefulWidget {
  final Post post;
  final bool isProfilePost;

  const PostItemCardDefault(
      {Key key, @required this.post, this.isProfilePost = false})
      : super(key: key);
  @override
  _PostItemCardDefaultState createState() => _PostItemCardDefaultState();
}

class _PostItemCardDefaultState extends State<PostItemCardDefault> {
  int _currentPostImageIndex = 0;
  bool _isCurrentUserProfile = false;

  Post get _post => widget.post;
  bool get _isProfilePost => widget.isProfilePost;

  initState() {
    super.initState();

    Profile signedProfile = ProfileBloc().signedProfile;
    if (signedProfile != null) {
      setState(() {
        signedProfile.userID == _post.profile.userID
            ? _isCurrentUserProfile = true
            : _isCurrentUserProfile = false;
      });
    }
  }

  void _navigateToPostDetailsPage() {
    if (_isProfilePost) {
      Navigator.of(context).pushNamed('/profile-post/${_post.postID}');
    } else {
      Navigator.of(context).pushNamed('/post/${_post.postID}');
    }
  }

  void _navigateToProfilePage() {
    // TODO :
    // Navigator.of(context).pushNamed('/post-profile/${_post.postID}').then((_) {
    //   final _postFormKey = UniqueKey();
    //   _postBloc.postFormKey = _postFormKey;
    // });
  }

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
        ));
  }

  Widget _buildPostImageSynopsis() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Container(
        height: 70.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.transparent, Colors.black87],
          ),
        ),
      ),
    );
  }

  Widget _buildPostImageCarousel() {
    return CarouselSlider(
        height: 400.0,
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
                    Center(child: Icon(Icons.error)),
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

  Widget _buildPostPriceTag() {
    return Positioned(
      top: 20.0,
      right: 0.0,
      child: Container(
        height: 30.0,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0)),
          // borderRadius: BorderRadius.circular(25.0),
        ),
        child: Text(
          'GHC ${_post.likeCount}',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPostCardBackgroundImage() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          child: _post.imageUrls != null && _post.imageUrls.length > 0
              ? _buildPostImageCarousel()
              : Image.asset('assets/avatars/bg-avatar.png', fit: BoxFit.cover),
        ),
        _buildPostImageSynopsis(),
        _post.imageUrls.length > 1
            ? _buildPostImageCarouselIndicator()
            : Container(),
        _buildPostPriceTag()
      ],
    );
  }

  Widget _buildFollowTrailingButton() {
    final double _containerHeight = _post.profile.isFollowing ? 40.0 : 30.0;
    final double _containerWidth = _post.profile.isFollowing ? 40.0 : 100.0;

    return InkWell(
      onTap: () {
        // TODO :
        // postBloc.toggleFollowProfilePageStatus(
        //     currentPostProfile: _post.profile);
      },
      splashColor: Colors.black38,
      borderRadius: BorderRadius.circular(15.0),
      child: AnimatedContainer(
        height: _containerHeight,
        width: _containerWidth,
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _post.profile.isFollowing
                ? Container()
                : Flexible(
                    flex: 2,
                    child: Text(
                      'FOLLOW',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
            SizedBox(width: _post.profile.isFollowing ? 0.0 : 5.0),
            Flexible(
              child: Center(
                child: Icon(
                  _post.profile.isFollowing
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 20.0,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserListTile() {
    Post post = _post;
    return ListTile(
      onTap: _isProfilePost ? null : () => _navigateToProfilePage(),
      leading: Container(
        height: 50.0,
        width: 50.0,
        child: _post != null &&
                _post.profile.profileImageUrl != null &&
                _post.profile.profileImageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: '${_post.profile.profileImageUrl}',
                placeholder: (context, imageUrl) =>
                    Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                errorWidget: (context, imageUrl, error) =>
                    Center(child: Icon(Icons.error)),
                imageBuilder: (BuildContext context, ImageProvider image) {
                  return Hero(
                    tag: '${_post.postID}_${_post.profile.profileImageUrl}',
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: image, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.asset('assets/avatars/ps-avatar.png',
                    fit: BoxFit.cover),
              ),
      ),
      title: Text('${_post.profile.nickname}',
          style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle:
          Text('${DateFormat.yMMMMEEEEd().format(_post.lastUpdate.toDate())}'),
      trailing: _isCurrentUserProfile
          ? null
          : _isProfilePost ? null : _buildFollowTrailingButton(),
    );
  }

  Widget _buildPostListTile() {
    return ListTile(
        title: Text('${_post.title}',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${_post.contents}', overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          tooltip: 'Save this post',
          icon: Icon(
            _post.isLiked ? Icons.favorite : Icons.favorite_border,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () {
            // TODO :
            // postBloc.toggleLikeStatus(post: _post);
          },
        ));
  }

  Widget _buildPostDetails() {
    return Column(
      children: <Widget>[
        _buildUserListTile(),
        _buildPostListTile(),
      ],
    );
  }

  Widget _buildPostItem() {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _contentWidth = _deviceWidth > 450.0 ? 450.0 : _deviceWidth;

    return Column(
      children: <Widget>[
        Card(
          elevation: 8.0,
          child: InkWell(
            onTap: () => _navigateToPostDetailsPage(),
            child: Container(
              width: _contentWidth,
              child: Column(
                children: <Widget>[
                  _buildPostDetails(),
                  _buildPostCardBackgroundImage()
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPostItem();
  }
}
