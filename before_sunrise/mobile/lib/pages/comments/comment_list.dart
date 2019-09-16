import 'package:before_sunrise/import.dart';

class CommentList extends StatefulWidget {
  CommentList({this.category, this.postID});
  @override
  _CommentListState createState() => _CommentListState();
  String category;
  String postID;
}

class _CommentListState extends State<CommentList> {
  List<Comment> _comments = List<Comment>();
  bool _isAllLoad = false;
  final TextEditingController _textController = TextEditingController();
  ByteData _selectedThumbData;
  ByteData _selectedOriginalData;
  final _commentBloc = CommentBloc();
  ScrollController _scrollController = ScrollController();
  Widget _commentLoadingIndicator = CircularProgressIndicator(
      strokeWidth: 2.0, backgroundColor: Colors.transparent);

  @override
  void initState() {
    super.initState();
    print("commentlist init");
    this._commentBloc.dispatch(LoadCommentEvent(
        category: widget.category, comment: null, postID: widget.postID));

    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kDeviceHeight - (kDeviceHeight - 500),
      child: Column(
        children: <Widget>[
          _commentLoadingIndicator,
          SizedBox(height: 20),
          Flexible(
            child: BlocListener(
                bloc: _commentBloc,
                listener: (context, state) async {
                  if (state is FetchingCommentState) {
                    _commentLoadingIndicator = CircularProgressIndicator(
                        strokeWidth: 2.0, backgroundColor: Colors.transparent);
                    setState(() {});
                    return;
                  } else if (state is SuccessCommentState) {
                    _textController.text = "";
                    _selectedThumbData = null;
                    print("commentlist SuccessCommentState");

                    _isAllLoad = false;
                    _comments.clear();
                    this._commentBloc.dispatch(LoadCommentEvent(
                        category: widget.category,
                        comment: null,
                        postID: widget.postID));

                    return;
                  } else {
                    _commentLoadingIndicator = SizedBox();
                    setState(() {});

                    return;
                  }
                },
                child: BlocBuilder<CommentBloc, CommentState>(
                    bloc: _commentBloc,
                    builder: (
                      BuildContext context,
                      CommentState currentState,
                    ) {
                      if (currentState is FetchedCommentState) {
                        if (currentState.comments == null ||
                            currentState.comments.length <= 0) {
                          _isAllLoad = true;
                        } else {
                          if (currentState.comments.length <
                              CoreConst.maxLoadCommentCount) {
                            _isAllLoad = true;
                          }

                          _comments.addAll(currentState.comments);
                          currentState.comments.clear();

                          this._commentBloc.dispatch(BindingCommentEvent());
                        }
                      }

                      if (_comments == null || _comments.length <= 0) {
                        return Container();
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        itemCount: _comments.length,
                        reverse: true,
                        itemBuilder: (BuildContext context, int index) {
                          Comment comment = _comments[index];
                          return CommentBubble(comment: comment);
                        },
                      );
                    })),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
//                height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[900],
                    offset: Offset(0.0, 1.5),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              constraints: BoxConstraints(
                maxHeight: 190,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Flexible(
                  //   child:
                  _selectedThumbData == null
                      ? ListTile(
                          leading: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.image,
                              color: MainTheme.enabledButtonColor,
                            ),
                            onPressed: () {
                              _loadAssets();
                            },
                          ),
                          contentPadding: EdgeInsets.all(0),
                          title: TextField(
                            controller: _textController,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Theme.of(context).textTheme.title.color,
                            ),
                            decoration: InputDecoration(
                              focusColor: Colors.black,
                              fillColor: Colors.black,
                              hoverColor: Colors.black,
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: LocalizableLoader.of(context)
                                  .text("comment_hint_text"),
                            ),
                            maxLines: null,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.paperPlane,
                              color: MainTheme.enabledButtonColor,
                            ),
                            onPressed: () {
                              _touchedSendButton();
                            },
                          ),
                        )
                      : _buildGridView(context),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
      );

      if (resultList == null) {
        return;
      }

      if (resultList.length <= 0) {
        return;
      }

      for (Asset asset in resultList) {
        ByteData data = await asset.getThumbByteData(
          100,
          100,
          quality: 50,
        );
        _selectedThumbData = data;

        ByteData originalData = await asset.getByteData();
        _selectedOriginalData = originalData;
        setState(() {});
        break;
      }
    } catch (e) {
      error = e.message;
      print(e.message);
    }

    if (!mounted) return;
  }

  Widget _buildGridView(BuildContext context) {
    if (_selectedThumbData == null) {
      return Container();
    }

    return ListTile(
      contentPadding: EdgeInsets.all(10),
      title: Stack(children: <Widget>[
        ThumbnailItem(
          data: _selectedThumbData,
          width: 50,
          height: 50,
          quality: 50,
        ),
        CircleAvatar(
          backgroundColor: MainTheme.disabledButtonColor,
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.trash,
            ),
            color: MainTheme.enabledIconColor,
            onPressed: () {
              _selectedThumbData = null;
              _selectedOriginalData = null;
              setState(() {});
              print("deleted");
            },
          ),
        ),
      ]),
      trailing: IconButton(
        icon: Icon(
          FontAwesomeIcons.paperPlane,
          color: MainTheme.enabledButtonColor,
        ),
        onPressed: () {
          _touchedSendImageButton();
        },
      ),
    );
  }

  void _touchedSendButton() {
    if (_textController.text.length <= 0) {
      FailSnackbar().show("E41122", null);
      return;
    }

    Comment comment = Comment();
    comment.text = _textController.text;

    this._commentBloc.dispatch(CreateCommentEvent(
        category: widget.category,
        postID: widget.postID,
        comment: comment,
        byteDatas: null));
  }

  void _touchedSendImageButton() {
    if (_selectedOriginalData == null) {
      FailSnackbar().show("E41123", null);
      return;
    }

    Comment comment = Comment();

    this._commentBloc.dispatch(CreateCommentEvent(
        category: widget.category,
        postID: widget.postID,
        comment: comment,
        byteDatas: [_selectedOriginalData]));
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_commentBloc.currentState is IdleCommentState) {
        if (_isAllLoad == true) {
          return;
        }
        print("commentlist scroll");

        this._commentBloc.dispatch(LoadCommentEvent(
            category: widget.category,
            comment: _comments.last,
            postID: widget.postID));
      }
    }
  }
}
