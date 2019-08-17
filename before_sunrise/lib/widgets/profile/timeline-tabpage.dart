import 'package:before_sunrise/import.dart';

class TimelineTabPage extends StatelessWidget {
  final String userID;
  final bool isRefreshing;

  const TimelineTabPage(
      {Key key, @required this.userID, @required this.isRefreshing})
      : super(key: key);

  String get _userID => userID;
  bool get _isRefreshing => isRefreshing;

  Widget _buildSliverList({@required PostBloc postBloc}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return index >= postBloc.profilePosts.length
              ? BottomLoader()
              : PostItemCardDefault(
                  post: postBloc.profilePosts[index], isProfilePost: true);
        },
        childCount: postBloc.moreProfilePostsAvailable
            ? postBloc.profilePosts.length + 1
            : postBloc.profilePosts.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostBloc>(
        builder: (BuildContext context, PostBloc postBloc, Widget child) {
      return _isRefreshing
          ? _buildSliverList(postBloc: postBloc)
          : postBloc.profilePostState == PostState.Loading
              ? SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      _isRefreshing ? Container() : CircularProgressIndicator(),
                    ],
                  ),
                )
              : postBloc.profilePosts.length == 0
                  ? SliverToBoxAdapter(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 50.0),
                          FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.refresh),
                                Text('refresh'),
                              ],
                            ),
                            onPressed: () {
                              postBloc.fetchProfilePosts(userID: _userID);
                            },
                          ),
                          Text('No Post(s) Loaded'),
                        ],
                      ),
                    )
                  : _buildSliverList(postBloc: postBloc);
    });
  }
}
