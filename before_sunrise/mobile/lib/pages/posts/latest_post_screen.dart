import 'package:before_sunrise/import.dart';

class LatestPostScreen extends StatefulWidget {
  const LatestPostScreen({
    Key key,
    @required PostBloc postBloc,
  })  : _postBloc = postBloc,
        super(key: key);

  final PostBloc _postBloc;

  @override
  LatestPostScreenState createState() {
    return new LatestPostScreenState(_postBloc);
  }
}

class LatestPostScreenState extends State<LatestPostScreen> {
  final PostBloc _postBloc;
  LatestPostScreenState(this._postBloc);
  List<Post> _posts = List<Post>();
  bool _enabeldMorePosts = false;

  @override
  void initState() {
    super.initState();
    this._postBloc.dispatch(LoadPostEvent(post: null));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
        bloc: widget._postBloc,
        builder: (
          BuildContext context,
          PostState currentState,
        ) {
          return Center(
            child: CircularProgressIndicator(),
          );
          /*
          if (currentState is FetchingPostState) {
            if (_posts.length == 0) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return _buildPosts(null);
          }

          if (currentState is FetchedPostState) {
            return _buildPosts(currentState.posts);
          }

          return _buildPosts(null);
          */
        });
  }

  Widget _buildPosts(List<Post> posts) {
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
    return RefreshIndicator(
        onRefresh: () async {
          _posts.clear();
          _enabeldMorePosts = true;
          this._postBloc.dispatch(LoadPostEvent(post: null));
        },
        child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                print(_postBloc.currentState.toString());
                _loadMore();
              }
            },
            child: ListView.builder(
              // shrinkWrap: true,
              itemCount: _posts.length + 1,
              itemBuilder: (context, index) {
                if (index == _posts.length) {
                  return Column(
                    children: <Widget>[
                      _enabeldMorePosts == true ? BottomLoader() : Container(),
                      SizedBox(height: 160),
                    ],
                  );
                }

                if (index == _posts.length + 1) {}

                return PostItemCardDefault(post: _posts[index]);
              },
            )));
  }

  void _loadMore() {
    if (_enabeldMorePosts == false) {
      return;
    }

    _enabeldMorePosts = false;
    if (_posts.length > 0) {
      Post post = _posts.last;
      this._postBloc.dispatch(LoadPostEvent(post: post));
      return;
    }
  }

  // Widget _buildSliverList() {
  //   return SliverList(
  //     delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
  //       if (_enabeldMorePosts == true && index >= _posts.length) {
  //         return BottomLoader();
  //       }

  //       if (index < _posts.length) {
  //         return PostItemCardDefault(post: _posts[index]);
  //       }

  //       return Container();
  //     }, childCount: _posts.length + 1),
  //   );
  // }
}
