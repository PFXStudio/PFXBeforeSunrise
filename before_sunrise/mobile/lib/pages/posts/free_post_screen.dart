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
  final _scrollThreshold = 200.0;
  bool _isRefreshing = false;
  List<Post> _posts = List<Post>();

  @override
  void initState() {
    super.initState();
    this._postBloc.dispatch(LoadPostEvent(post: null));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      print('sroll next');
      if (_posts.length > 0) {
        Post post = _posts.last;
        this._postBloc.dispatch(LoadPostEvent(post: post));
        return;
      }

      this._postBloc.dispatch(LoadPostEvent(post: null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
        bloc: widget._postBloc,
        builder: (
          BuildContext context,
          PostState currentState,
        ) {
          if (currentState is UnPostState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (currentState is InPostState) {
            return RefreshIndicator(
                onRefresh: () async {
                  this._postBloc.dispatch(LoadPostEvent(post: null));
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    _buildSliverList(),
                    //   _isRefreshing
                    //       ? _buildSliverList()
                    //       : SliverToBoxAdapter(
                    //           child: SizedBox(height: 160.0),
                    //         )
                  ],
                ));
          }
          if (currentState is ErrorPostState) {
            return new Container(
                child: new Center(
              child: new Text(currentState.errorMessage ?? 'Error'),
            ));
          }
          return new Column(
            children: <Widget>[
              Center(
                child: new Text("В разработке"),
              ),
              Center(
                child: new Text("В разработке"),
                heightFactor: 10,
              ),
              Center(
                child: new Text("В разработке"),
                heightFactor: 10,
              ),
              Center(
                child: new Text("В разработке"),
                heightFactor: 10,
              ),
            ],
          );
        });
  }

  Widget _buildSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return index >= _posts.length
            ? BottomLoader()
            : PostItemCardDefault(post: _posts[index]);
      }, childCount: _posts.length + 1),
    );
  }
}
