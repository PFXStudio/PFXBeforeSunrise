import 'package:before_sunrise/import.dart';

class PostFormScreen extends StatefulWidget {
  static const String routeName = "/postForm";
  const PostFormScreen({
    Key key,
  }) : super(key: key);

  @override
  PostFormScreenState createState() {
    return new PostFormScreenState();
  }
}

class PostFormScreenState extends State<PostFormScreen> {
  PostBloc _postBloc = PostBloc();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentsFocusNode = FocusNode();
  final FocusNode _youtubeFocusNode = FocusNode();

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _contentsController = new TextEditingController();
  TextEditingController _youtubeController = new TextEditingController();

// multi image picker 이미지 데이터가 사라짐. 받아오면 바로 백업.
  final List<ByteData> _selectedThumbDatas = List<ByteData>();
  final List<ByteData> _selectedOriginalDatas = List<ByteData>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

// 이 값은 초기에 초기화 되기 때문에 재 진입해야 적용 됨.
  double _maxContentsHeight = 1200;
  final int _maxPicturesCount = 20;
  Post _post = Post();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _contentsFocusNode.dispose();
    _youtubeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _contents = _buildContents();
    return Scaffold(
      appBar: PostFormTopBar(),
      key: _scaffoldKey,
      body: _contents,
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
        child: Container(
      width: MediaQuery.of(context).size.width,
      height: _selectedThumbDatas.length == 0 ? 900 : _maxContentsHeight,
      decoration: new BoxDecoration(
        gradient: MainTheme.primaryLinearGradient,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: _buildHeader(),
            ),
          ),
          Expanded(
            flex: 10,
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: _buildForms(context),
            ),
          ),
          Expanded(
              flex: _selectedThumbDatas.length == 0 ? 8 : 15,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Column(children: <Widget>[
                  _buildGalleryFiles(context),
                  _buildLineDecoration(context),
                  _buildRegistButton(context),
                ]),
              )),
        ],
      ),
    ));
  }

  Future<void> _loadAssets() async {
    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: _maxPicturesCount - _selectedThumbDatas.length,
      );

      if (resultList.length > 0) {
        for (Asset asset in resultList) {
          ByteData data = await asset.getThumbByteData(
            100,
            100,
            quality: 50,
          );
          _selectedThumbDatas.add(data);

          ByteData originalData = await asset.getByteData();
          _selectedOriginalDatas.add(originalData);
          setState(() {});
        }
      }
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      if (_selectedThumbDatas.length > _maxPicturesCount) {
        int end = _selectedThumbDatas.length - _maxPicturesCount - 1;
        _selectedThumbDatas.removeRange(0, end);

        _selectedOriginalDatas.removeRange(0, end);
      }
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: MainTheme.edgeInsets.top),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width -
                      MainTheme.edgeInsets.left,
                  height: 100,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  DialogPostType(
                                    callback: (type) {
                                      setState(() {
                                        _post.type = type;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  DialogPublishTypeWidget(
                                    callback: (type) {
                                      setState(() {
                                        _post.publishType = type;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              LocalizableLoader.of(context)
                                  .text("anonymous_checkbox"),
                              style: TextStyle(color: Colors.black54),
                            ),
                            Checkbox(
                              value: _post.enabledAnonymous,
                              onChanged: (bool value) {
                                setState(() {
                                  _post.enabledAnonymous = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForms(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(top: MainTheme.edgeInsets.top),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Card(
                    elevation: 2.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width -
                          MainTheme.edgeInsets.left,
                      height: 400,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 5, bottom: 5),
                            child: TextFormField(
                              // TextField(
                              focusNode: _titleFocusNode,
                              controller: _titleController,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.pencilAlt,
                                  color: Colors.black54,
                                  size: 18.0,
                                ),
                                hintText: LocalizableLoader.of(context)
                                    .text("board_title_hint_text"),
                                hintStyle: TextStyle(fontSize: 17.0),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width -
                                MainTheme.edgeInsets.left * 2,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 20, top: 5, bottom: 5),
                              child: TextFormField(
                                // TextField(
                                focusNode: _contentsFocusNode,
                                controller: _contentsController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 15,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.alignJustify,
                                    size: 18.0,
                                    color: Colors.black54,
                                  ),
                                  hintText: LocalizableLoader.of(context)
                                      .text("board_contents_hint_text"),
                                  hintStyle: TextStyle(fontSize: 17.0),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildGalleryFiles(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MainTheme.edgeInsets.top),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width -
                      MainTheme.edgeInsets.left,
                  height: (_selectedThumbDatas.length > 0) ? 400 : 114,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 7, top: 5, bottom: 5),
                          child: FlatButton.icon(
                              focusColor: Colors.red,
                              icon: Icon(
                                Icons.photo_library,
                                color: MainTheme.enabledButtonColor,
                              ),
                              label: Text(
                                sprintf(
                                    LocalizableLoader.of(context)
                                        .text("add_pictures_button"),
                                    [
                                      _selectedThumbDatas.length,
                                      _maxPicturesCount
                                    ]),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MainTheme.enabledButtonColor),
                              ),
                              onPressed: () {
                                if (_selectedThumbDatas.length >=
                                    _maxPicturesCount) {
                                  FailSnackbar().show(
                                      LocalizableLoader.of(context)
                                          .text("notice_remove_pictures"),
                                      null);
                                  return;
                                }

                                _loadAssets();
                              })),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width -
                                MainTheme.edgeInsets.left * 2,
                            height: 1.0,
                            color: Colors.grey[400],
                          )),
                      Expanded(child: _buildGridView(context)),
                      _selectedThumbDatas.length == 0
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width -
                                    MainTheme.edgeInsets.left * 2,
                                height: 1.0,
                                color: Colors.grey[400],
                              )),
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                        child: TextField(
                          focusNode: _youtubeFocusNode,
                          controller: _youtubeController,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.youtube,
                              color: Colors.black54,
                              size: 18.0,
                            ),
                            hintText: LocalizableLoader.of(context)
                                .text("board_youtube_hint_text"),
                            hintStyle: TextStyle(fontSize: 17.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    if (_selectedThumbDatas.length <= 0) {
      return Container();
    }

    return GridView.count(
      padding: MainTheme.edgeInsets,
      crossAxisCount: 4,
      children: List.generate(_selectedThumbDatas.length, (index) {
        ByteData data = _selectedThumbDatas[index];
        return Stack(children: <Widget>[
          ThumbnailItem(
            data: data,
            width: 100,
            height: 100,
            quality: 50,
          ),
          CircleAvatar(
            backgroundColor: MainTheme.disabledButtonColor,
            child: IconButton(
              icon: Icon(
                Icons.delete,
              ),
              color: MainTheme.enabledIconColor,
              onPressed: () {
                _selectedThumbDatas.removeAt(index);
                _selectedOriginalDatas.removeAt(index);
                setState(() {});
                print("deleted");
              },
            ),
          ),
        ]);
      }),
    );
  }

  Widget _buildLineDecoration(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MainTheme.edgeInsets.top),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.white10,
                    Colors.white,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: MediaQuery.of(context).size.width / 2,
            height: 1.0,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white10,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: 100.0,
            height: 1.0,
          ),
        ],
      ),
    );
  }

  Widget _buildRegistButton(BuildContext context) {
    return BlocListener(
        bloc: _postBloc,
        listener: (context, state) async {},
        child: BlocBuilder<PostBloc, PostState>(
            bloc: _postBloc,
            builder: (
              BuildContext context,
              PostState currentState,
            ) {
              return Container(
                margin: MainTheme.edgeInsets,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: MainTheme.gradientStartColor,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: MainTheme.gradientEndColor,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: MainTheme.buttonLinearGradient,
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.red,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        LocalizableLoader.of(context)
                            .text("board_regist_button"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      _requestRegist();
                    }),
              );
              ;
            }));
  }

  void _requestRegist() {
    if (_titleController.text.length <= 0) {
      FailSnackbar().show("error_post_form_empty_title", null);
      return;
    }

    if (_contentsController.text.length <= 0) {
      FailSnackbar().show("error_post_form_empty_contents", null);
      return;
    }

    if (_post.type.length <= 0) {
      FailSnackbar().show("error_post_form_empty_type", null);
      return;
    }

    if (_post.publishType.length <= 0) {
      FailSnackbar().show("error_post_form_publish_type", null);
      return;
    }

    _post.title = _titleController.text;
    _post.contents = _contentsController.text;
    _post.youtubeUrl = _youtubeController.text;
    _post.created = DateTime.now().millisecondsSinceEpoch;
    _postBloc.dispatch(
        CreatePostEvent(post: _post, byteDatas: _selectedOriginalDatas));
  }
}
