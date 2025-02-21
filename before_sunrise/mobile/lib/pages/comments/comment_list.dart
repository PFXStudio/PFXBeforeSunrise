import 'package:before_sunrise/import.dart';

class CommentList extends StatefulWidget {
  CommentList({this.category, this.postID, this.writerID, this.isReport});
  @override
  _CommentListState createState() => _CommentListState();
  final String category;
  final String postID;
  final String writerID;
  final bool isReport;
}

class _CommentListState extends State<CommentList> {
  List<Comment> _comments = List<Comment>();
  bool _isAllLoad = false;
  final TextEditingController _textController = TextEditingController();
  ByteData _selectedOriginalData;
  ByteData _parentOriginalData;
  final _commentBloc = CommentBloc();
  Widget _commentLoadingIndicator = CircularProgressIndicator(
      strokeWidth: 2.0, backgroundColor: Colors.transparent);

  Comment _editComment;
  Comment _parentComment;
  String _moveCommentID;

  AutoScrollController _autoScrollController;
  int _findIndex = -1;
  GlobalKey _inputBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    print("commentlist init");

    if (widget.isReport == true) {
      return;
    }

    this._commentBloc.dispatch(LoadCommentEvent(
        category: widget.category, comment: null, postID: widget.postID));

    _autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);

    _autoScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    KeyboardDetector().setContext(null, 0);
    OptionMenuPopup().dismiss();
    super.dispose();
  }

  _updateKeyboard() => Future.delayed(Duration(milliseconds: 500), () async {
        if (this.mounted == false) {
          KeyboardDetector().setContext(context, 0);
          return;
        }

        KeyboardDetector()
            .setContext(context, _inputBarKey.currentContext.size.height + 4);
      });

  @override
  Widget build(BuildContext context) {
    var height = kDeviceHeight - (kDeviceHeight - 500);
    var bottom = MediaQuery.of(context).viewInsets.bottom;
    _updateKeyboard();

    return Container(
      height: height - bottom,
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
                  }

                  _hideCommentLoading();
                  if (state is SuccessCommentState) {
                    _textController.text = "";
                    _selectedOriginalData = null;
                    _editComment = null;
                    _parentComment = null;
                    _parentOriginalData = null;
                    print("commentlist SuccessCommentState");

                    Comment updateComment = state.comment;
                    if (state.isIncrease == true) {
                      _comments.insert(0, updateComment);

                      setState(() {
                        _moveScroll(0);
                      });
                    } else {
                      _updateEditComment(updateComment);
                    }

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
                  } else if (state is MoveCommentState) {
                    int findIndex = -1;
                    _moveCommentID = state.commentID;
                    for (int i = 0; i < _comments.length; i++) {
                      var comment = _comments[i];
                      if (comment.commentID == _moveCommentID) {
                        findIndex = i;
                        break;
                      }
                    }

                    if (findIndex != -1) {
                      // goto scroll.
                      print("movecomment find $_moveCommentID");
                      _moveCommentID = null;
                      _moveScroll(findIndex);
                      return;
                    }

                    if (_isAllLoad == true) {
                      // not found
                      return;
                    }

                    this._commentBloc.dispatch(LoadCommentEvent(
                        category: widget.category,
                        comment: _comments.last,
                        postID: widget.postID));
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

                          if (_moveCommentID == null) {
                            _comments.addAll(currentState.comments);
                            currentState.comments.clear();
                          } else {
                            int count = _comments.length;
                            for (int i = 0;
                                i < currentState.comments.length;
                                i++) {
                              var comment = currentState.comments[i];
                              if (comment.commentID == _moveCommentID) {
                                _findIndex = count + i;
                              }

                              _comments.add(comment);
                            }
                          }
                        }

                        this._commentBloc.dispatch(BindingCommentEvent());
                      }

                      if (currentState is SuccessCommentState) {
                        this._commentBloc.dispatch(BindingCommentEvent());
                      }

                      if (currentState is IdleCommentState) {
                        if (_findIndex != -1 && _moveCommentID != null) {
                          // goto scroll
                          print("fetched find $_moveCommentID");
                          _moveScroll(_findIndex);
                          _findIndex = -1;
                          _moveCommentID = null;
                        } else if (_moveCommentID != null) {
                          this._commentBloc.dispatch(LoadCommentEvent(
                              category: widget.category,
                              comment: _comments.last,
                              postID: widget.postID));
                        }
                      }

                      if (_comments == null || _comments.length <= 0) {
                        return Container();
                      }

                      print("comments count ${_comments.length}");

                      var listView = ListView.builder(
                        controller: _autoScrollController,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        itemCount: _comments.length,
                        reverse: true,
                        itemBuilder: (BuildContext context, int index) {
                          Comment comment = _comments[index];
                          if (comment.userID == widget.writerID) {
                            comment.isWriter = true;
                          }

                          return _wrapScrollTag(
                              index: index,
                              child: CommentBubble(
                                  category: widget.category,
                                  postID: widget.postID,
                                  comment: comment));
                        },
                      );

                      return listView;
                    })),
          ),
          Align(
            key: _inputBarKey,
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
                                FocusScope.of(this.context)
                                    .requestFocus(new FocusNode());
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
                                : Flexible(
                                    child: Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Text(
                                      _parentComment.text,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
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
                            FocusScope.of(this.context)
                                .requestFocus(new FocusNode());
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
                                  .text("comment_hint"),
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
              FocusScope.of(this.context).requestFocus(new FocusNode());
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
      FailSnackBar().show("fail_report_post", null);
      return;
    }

    if (_textController.text.length <= 0) {
      FailSnackBar().show("error_empty_text", null);
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
      FailSnackBar().show("fail_report_post", null);
      return;
    }

    if (_selectedOriginalData == null) {
      FailSnackBar().show("error_empty_image", null);
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
    OptionMenuPopup().dismiss();
    FocusScope.of(context).requestFocus(FocusNode());
    if (_autoScrollController.offset >=
            _autoScrollController.position.maxScrollExtent &&
        !_autoScrollController.position.outOfRange) {
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

  void _updateEditComment(Comment editComment) {
    for (int i = 0; i < _comments.length; i++) {
      var comment = _comments[i];
      if (comment.commentID != editComment.commentID) {
        continue;
      }

      _comments[i] = editComment.copyWith();
      setState(() {});
      break;
    }
  }

  Widget _wrapScrollTag({int index, Widget child}) => AutoScrollTag(
        key: ValueKey(index),
        controller: _autoScrollController,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.1),
      );

  void _moveScroll(int index) async {
    await _autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);

    // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
    //     duration: new Duration(seconds: 1), curve: Curves.ease);
  }

  _hideCommentLoading() {
    _commentLoadingIndicator = SizedBox();
    setState(() {});
  }
}
