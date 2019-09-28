import 'package:before_sunrise/import.dart';

class CommentList extends StatefulWidget {
  CommentList({this.category, this.postID, this.isReport});
  @override
  _CommentListState createState() => _CommentListState();
  final String category;
  final String postID;
  final bool isReport;
}

class _CommentListState extends State<CommentList> {
  List<Comment> _comments = List<Comment>();
  bool _isAllLoad = false;
  final TextEditingController _textController = TextEditingController();
  ByteData _selectedOriginalData;
  ByteData _parentOriginalData;
  final _commentBloc = CommentBloc();
  ScrollController _scrollController = ScrollController();
  Widget _commentLoadingIndicator = CircularProgressIndicator(
      strokeWidth: 2.0, backgroundColor: Colors.transparent);

  Comment _editComment;
  Comment _parentComment;

  @override
  void initState() {
    super.initState();
    print("commentlist init");

    if (widget.isReport == true) {
      return;
    }

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
                    _selectedOriginalData = null;
                    _editComment = null;
                    _parentComment = null;
                    _parentOriginalData = null;
                    print("commentlist SuccessCommentState");

                    _isAllLoad = false;
                    _comments.clear();
                    this._commentBloc.dispatch(LoadCommentEvent(
                        category: widget.category,
                        comment: null,
                        postID: widget.postID));

                    return;
                  } else if (state is EditCommentState) {
                    _parentComment = null;
                    _parentOriginalData = null;
                    _editComment = state.comment;
                    if (_editComment == null) {
                      return;
                    }

                    _textController.text = _editComment.text;
                    if (_editComment.imageUrls == null ||
                        _editComment.imageUrls.isEmpty == true) {
                      setState(() {});
                      return;
                    }
                    downloadAllImages(_editComment.imageUrls, (imageMap) {
                      if (imageMap == null || imageMap.isEmpty == true) {
                        return;
                      }

                      _selectedOriginalData = imageMap.values.first;
                      setState(() {});
                    });
                  } else if (state is ReplyCommentState) {
                    _editComment = null;
                    _selectedOriginalData = null;
                    _parentComment = state.parentComment;
                    if (_parentComment == null) {
                      return;
                    }

                    _textController.text = "";
                    if (_parentComment.imageUrls != null) {
                      downloadAllImages(_parentComment.imageUrls, (imageMap) {
                        if (imageMap == null || imageMap.isEmpty == true) {
                          return;
                        }

                        _parentOriginalData = imageMap.values.first;
                        setState(() {});
                      });
                    }
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
                          return CommentBubble(
                              category: widget.category,
                              postID: widget.postID,
                              comment: comment);
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
                  _parentComment == null
                      ? SizedBox()
                      : Row(
                          children: <Widget>[
                            FlatIconTextButton(
                              width: kDeviceWidth * 0.3,
                              color: MainTheme.enabledButtonColor,
                              iconData: FontAwesomeIcons.solidTimesCircle,
                              text: "댓글 취소",
                              onPressed: () {
                                _parentComment = null;
                                _parentOriginalData = null;
                                _selectedOriginalData = null;
                                _textController.text = "";
                                setState(() {});
                              },
                            ),
                            _parentOriginalData != null
                                ? Padding(
                                    padding: EdgeInsets.all(5),
                                    child: ThumbnailItem(
                                      data: _parentOriginalData,
                                      width: 50,
                                      height: 50,
                                      quality: 50,
                                    ))
                                : Text(_parentComment.text),
                          ],
                        ),
                  _editComment == null
                      ? SizedBox()
                      : FlatIconTextButton(
                          width: kDeviceWidth,
                          color: MainTheme.enabledButtonColor,
                          iconData: FontAwesomeIcons.solidTimesCircle,
                          text: "편집 취소",
                          onPressed: () {
                            _editComment = null;
                            _selectedOriginalData = null;
                            _textController.text = "";
                            setState(() {});
                          },
                        ),
                  _selectedOriginalData == null
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
                            minLines: 1,
                            maxLines: 5,
                            maxLength: 128,
                          ),
                          trailing: _buildSendButton(),
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

  Widget _buildSendButton() {
    if (_editComment != null) {
      return IconButton(
        icon: Icon(
          FontAwesomeIcons.solidEdit,
          color: MainTheme.enabledButtonColor,
        ),
        onPressed: () {
          _touchedSendButton();
        },
      );
    } else if (_parentComment != null) {
      return IconButton(
        icon: Icon(
          FontAwesomeIcons.reply,
          color: MainTheme.enabledButtonColor,
        ),
        onPressed: () {
          _touchedSendButton();
        },
      );
    }

    return IconButton(
      icon: Icon(
        FontAwesomeIcons.paperPlane,
        color: MainTheme.enabledButtonColor,
      ),
      onPressed: () {
        _touchedSendButton();
      },
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
    if (_selectedOriginalData == null) {
      return Container();
    }

    return ListTile(
      contentPadding: EdgeInsets.all(10),
      title: Stack(children: <Widget>[
        ThumbnailItem(
          data: _selectedOriginalData,
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
              _selectedOriginalData = null;
              setState(() {});
              print("deleted");
            },
          ),
        ),
      ]),
      trailing: IconButton(
        icon: Icon(
          _parentComment != null
              ? FontAwesomeIcons.reply
              : _editComment == null
                  ? FontAwesomeIcons.paperPlane
                  : FontAwesomeIcons.solidEdit,
          color: MainTheme.enabledButtonColor,
        ),
        onPressed: () {
          _touchedSendImageButton();
        },
      ),
    );
  }

  void _touchedSendButton() {
    if (widget.isReport == true) {
      FailSnackbar().show("fail_report_post", null);
      return;
    }

    if (_textController.text.length <= 0) {
      FailSnackbar().show("E41122", null);
      return;
    }

    Comment comment = Comment();
    if (_editComment != null) {
      comment = _editComment.copyWith();
    }

    if (_parentComment != null) {
      comment.parentCommentID = _parentComment.commentID;
      comment.parentImageUrls = _parentComment.imageUrls;
      comment.parentText = _parentComment.text;
    }

    comment.text = _textController.text;

    this._commentBloc.dispatch(CreateCommentEvent(
        category: widget.category,
        postID: widget.postID,
        comment: comment,
        editComment: _editComment,
        byteDatas: null));
  }

  void _touchedSendImageButton() {
    if (widget.isReport == true) {
      FailSnackbar().show("fail_report_post", null);
      return;
    }

    if (_selectedOriginalData == null) {
      FailSnackbar().show("E41123", null);
      return;
    }

    Comment comment = Comment();
    if (_editComment != null) {
      comment = _editComment.copyWith();
    }

    if (_parentComment != null) {
      comment.parentCommentID = _parentComment.commentID;
      comment.parentImageUrls = _parentComment.imageUrls;
      comment.parentText = _parentComment.text;
    }

    this._commentBloc.dispatch(CreateCommentEvent(
        category: widget.category,
        postID: widget.postID,
        comment: comment,
        editComment: _editComment,
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
