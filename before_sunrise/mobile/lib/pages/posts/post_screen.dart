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
    return BlocListener(
        bloc: _postBloc,
        listener: (context, state) async {
          print(state.toString());
          if (state is SuccessRemovePostState) {
            var deletePost = state.post;
            for (int i = 0; i < _posts.length; i++) {
              var post = _posts[i];
              if (post.postID != deletePost.postID) {
                continue;
              }

              _posts.removeAt(i);
              break;
            }

            _postBloc.dispatch(BindPostEvent());
            return;
          }

          if (state is SuccessPostState) {
            var post = state.post;
            var isUpdate = state.isUpdate;
            if (isUpdate == false) {
              _posts.insert(0, post);
            } else {
              for (int i = 0; i < _posts.length; i++) {
                var checkPost = _posts[i];
                if (checkPost.postID != post.postID) {
                  continue;
                }

                _posts.removeAt(i);
                _posts.insert(i, post);
                break;
              }
            }
            _postBloc.dispatch(BindPostEvent());
            return;
          }

          if (state is FetchedPostState) {
            var posts = state.posts;
            _enabeldMorePosts = false;
            print("buildPosts $posts");
            if (posts != null) {
              if (posts.length >= CoreConst.maxLoadPostCount) {
                _enabeldMorePosts = true;
              }

              if (posts.length > 0) {
                _posts.addAll(posts);
                posts.clear();
              }
            }

            _postBloc.dispatch(BindPostEvent());
            return;
          }
        },
        child: BlocBuilder<PostBloc, PostState>(
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

                return _buildPosts(true);
              }

              return _buildPosts(false);
            }));
  }

  Widget _buildPosts(bool isBottomLoading) {
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
      print("_enabeldMorePosts is false");
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
