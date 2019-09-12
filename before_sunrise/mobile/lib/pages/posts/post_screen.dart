import 'package:before_sunrise/import.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    Key key,
    @required String category,
    @required PostBloc postBloc,
  })  : _postBloc = postBloc,
        _category = category,
        super(key: key);

  final PostBloc _postBloc;
  final String _category;

  @override
  PostScreenState createState() {
    return new PostScreenState(_postBloc);
  }
}

class PostScreenState extends State<PostScreen> {
  final PostBloc _postBloc;
  PostScreenState(this._postBloc);
  List<Post> _posts = List<Post>();
  bool _enabeldMorePosts = false;

  @override
  void initState() {
    super.initState();
    this
        ._postBloc
        .dispatch(LoadPostEvent(category: widget._category, post: null));
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
          print(">>>" + currentState.toString());
          if (currentState is FetchingPostState) {
            if (_posts.length == 0) {
              return Column(
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }

            return _buildPosts(null, true);
          }

          if (currentState is FetchedPostState) {
            return _buildPosts(currentState.posts, false);
          }

          return _buildPosts(null, false);
        });
  }

  Widget _buildPosts(List<Post> posts, bool isBottomLoading) {
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
          this
              ._postBloc
              .dispatch(LoadPostEvent(category: widget._category, post: null));
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
                      isBottomLoading ? BottomLoader() : Container(),
                      SizedBox(height: 240),
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
      this
          ._postBloc
          .dispatch(LoadPostEvent(category: widget._category, post: post));
      return;
    }
  }
}
