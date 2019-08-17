import 'package:before_sunrise/import.dart';

class LikePage extends StatefulWidget {
  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  bool _isRefreshing = false;

  Widget _buildSliverList({@required PostBloc postBloc}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext contex, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PostItemCardSmall(
                likePost: postBloc.likedPosts[index],
              ),
            ],
          );
        },
        childCount: postBloc.likedPosts.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final PostBloc _postBloc = Provider.of<PostBloc>(context);

    return Scaffold(
      body: Consumer<PostBloc>(
          builder: (BuildContext context, PostBloc postBloc, Widget child) {
        return RefreshIndicator(
          onRefresh: () async {
            setState(() => _isRefreshing = true);
            await postBloc.fetchLikedPosts();
            setState(() => _isRefreshing = false);
          },
          child: CustomScrollView(
            slivers: <Widget>[
              _isRefreshing
                  ? _buildSliverList(postBloc: postBloc)
                  : postBloc.likePostState == PostState.Loading
                      ? SliverToBoxAdapter(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 50.0),
                              _isRefreshing
                                  ? Container()
                                  : CircularProgressIndicator(),
                            ],
                          ),
                        )
                      : postBloc.likedPosts.length == 0
                          ? SliverToBoxAdapter(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 50.0),
                                  FlatButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(Icons.refresh),
                                        Text('refresh'),
                                      ],
                                    ),
                                    onPressed: () {
                                      postBloc.fetchLikedPosts();
                                    },
                                  ),
                                  Text('No Liked Post(s) Loaded'),
                                ],
                              ),
                            )
                          : _buildSliverList(postBloc: postBloc),
              SliverToBoxAdapter(
                child: SizedBox(height: 170.0),
              )
            ],
          ),
        );
      }),
    );
  }
}
