import 'package:before_sunrise/import.dart';

class FreePostScreen extends StatefulWidget {
  const FreePostScreen({
    Key key,
    @required PostBloc postBloc,
  })  : _postBloc = postBloc,
        super(key: key);

  final PostBloc _postBloc;

  @override
  FreePostScreenState createState() {
    return new FreePostScreenState(_postBloc);
  }
}

class FreePostScreenState extends State<FreePostScreen> {
  final PostBloc _postBloc;
  FreePostScreenState(this._postBloc);
  final _scrollController = ScrollController();
  List<Post> _posts = List<Post>();
  List<Widget> _slivers = List<Widget>();
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
          // if (currentState is UnPostState) {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }

          if (currentState is InPostState) {
            for (var post in currentState.posts) {
              _slivers.add(PostItemCardDefault(post: post));
            }

            _enabeldMorePosts = false;
            if (currentState.posts.length >= CoreConst.maxLoadPostCount) {
              _enabeldMorePosts = true;
              _slivers.add(BottomLoader());
            }

            _slivers.add(SizedBox(height: 160.0));

            _posts.addAll(currentState.posts);
            return RefreshIndicator(
              onRefresh: () async {
                _slivers.clear();
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
                  itemCount: _slivers.length,
                  itemBuilder: (context, index) {
                    return _slivers[index];
                  },
                ),
              ),
            );
          }
          // if (currentState is ErrorPostState) {
          //   return new Container(
          //       child: new Center(
          //     child: new Text(currentState.errorMessage ?? 'Error'),
          //   ));
          // }
          // return new Column(
          //   children: <Widget>[
          //     Center(
          //       child: new Text("В разработке"),
          //     ),
          //     Center(
          //       child: new Text("В разработке"),
          //       heightFactor: 10,
          //     ),
          //     Center(
          //       child: new Text("В разработке"),
          //       heightFactor: 10,
          //     ),
          //     Center(
          //       child: new Text("В разработке"),
          //       heightFactor: 10,
          //     ),
          //   ],
          // );
        });
  }

  void _loadMore() {
    if (_enabeldMorePosts == false) {
      return;
    }

    _enabeldMorePosts = false;
    _slivers.removeLast();
    _slivers.removeLast();
    if (_posts.length > 0) {
      Post post = _posts.last;
      this._postBloc.dispatch(LoadPostEvent(post: post));
      return;
    }

    this._postBloc.dispatch(LoadPostEvent(post: null));
  }

  bool _batchLoadListener(ScrollNotification scrollNotification) {
    if (!(scrollNotification is ScrollUpdateNotification)) return false;
    if (_scrollController.position.extentAfter > 500) return false;
    return _enabeldMorePosts;
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
