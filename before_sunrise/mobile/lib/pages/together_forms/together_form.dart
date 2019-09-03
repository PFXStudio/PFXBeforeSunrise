import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/pages/together_forms/together_form_club.dart';
import 'package:before_sunrise/pages/together_forms/together_form_price.dart';

class TogetherForm extends StatefulWidget {
  static const String routeName = "/togetherForm";
  TogetherForm({Key key}) : super(key: key);

  @override
  _TogetherFormState createState() => new _TogetherFormState();
}

class _TogetherFormState extends State<TogetherForm>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TogetherBloc _togetherBloc = TogetherBloc();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentsFocusNode = FocusNode();
  final FocusNode youtubeFocusNode = FocusNode();

  TextEditingController titleController = new TextEditingController();
  TextEditingController contentsController = new TextEditingController();
  TextEditingController youtubeController = new TextEditingController();

// multi image picker 이미지 데이터가 사라짐. 받아오면 바로 백업.
  final List<ByteData> selectedThumbDatas = List<ByteData>();
  final List<ByteData> selectedOriginalDatas = List<ByteData>();
  String _error;

// 이 값은 초기에 초기화 되기 때문에 재 진입해야 적용 됨.
  double maxContentsHeight = 1250;
  double minContentsHeight = 970;
  final int maxPicturesCount = 20;
  final Together together = Together();
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: _togetherBloc,
        listener: (context, state) async {
          if (state is SuccessTogetherState) {
            SuccessSnackbar().show("success_post", () {
              Navigator.pop(context);
            });

            return;
          }
        },
        child: BlocBuilder<TogetherBloc, TogetherState>(
            bloc: _togetherBloc,
            builder: (
              BuildContext context,
              TogetherState currentState,
            ) {
              return Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: TogetherFormTopBar(),
                  ),
                  key: _scaffoldKey,
                  body: SingleChildScrollView(
                      child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: selectedThumbDatas.length == 0
                        ? minContentsHeight
                        : maxContentsHeight,
                    decoration: new BoxDecoration(
                      gradient: MainTheme.primaryLinearGradient,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildTogether(context),
                          ),
                        ),
                        Expanded(
                          flex: 11,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildContents(context),
                          ),
                        ),
                        Expanded(
                            flex: selectedThumbDatas.length == 0 ? 9 : 16,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: Column(children: <Widget>[
                                _buildGalleryFiles(context),
                                _buildLineDecoration(context),
                                _buildCheckBox(context),
                                _buildRegistButton(context),
                              ]),
                            )),
                      ],
                    ),
                  )));
            }));
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    contentsFocusNode.dispose();
    youtubeFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  Future<void> _loadAssets() async {
    setState(() {});

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxPicturesCount - selectedThumbDatas.length,
      );

      if (resultList.length > 0) {
        for (Asset asset in resultList) {
          ByteData data = await asset.getThumbByteData(
            100,
            100,
            quality: 50,
          );
          selectedThumbDatas.add(data);

          ByteData originalData = await asset.getByteData();
          selectedOriginalDatas.add(originalData);
        }
      }
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      if (selectedThumbDatas.length > maxPicturesCount) {
        int end = selectedThumbDatas.length - maxPicturesCount - 1;
        selectedThumbDatas.removeRange(0, end);

        selectedOriginalDatas.removeRange(0, end);
      }

      if (error == null) _error = 'No Error Dectected';
    });
  }

  Widget _buildTogether(BuildContext context) {
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
                  height: 130,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TogetherFormDate(callback: (dateTime) {
                                    together.dateString = CoreConst
                                        .togetherDateFormat
                                        .format(dateTime);
                                  }),
                                  TogetherFormClub(
                                    callback: (clubID) {
                                      print(clubID);
                                      together.clubID = clubID;
                                    },
                                  ),
                                  TogetherFormPrice(
                                      callback: (tablePrice, tipPrice) {
                                    together.tablePrice = tablePrice;
                                    together.tipPrice = tipPrice;
                                    setState(() {});
                                  })
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TogetherFormMemberCount(
                                        callback: (totalCount, restCount) {
                                      together.totalCount = totalCount;
                                      together.restCount = restCount;
                                      setState(() {});
                                    }),
                                    TogetherFormCocktailCount(
                                      callback: (hardCount, champagneCount,
                                          serviceCount) {
                                        together.hardCount = hardCount;
                                        together.champagneCount =
                                            champagneCount;
                                        together.serviceCount = serviceCount;
                                      },
                                    ),
                                    FlatIconTextButton(
                                        width: 200,
                                        color: Colors.black54,
                                        iconData:
                                            FontAwesomeIcons.moneyBillWave,
                                        text: (together.totalCount != 0 &&
                                                together.tablePrice != 0)
                                            ? "${together.tablePrice + together.tipPrice}만원 / ${together.totalCount}명 = ${((together.tablePrice + together.tipPrice) / together.totalCount.toDouble()).toStringAsFixed(1)} 만원"
                                            : "자동 입력 됩니다."),
                                  ],
                                )),
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

  Widget _buildContents(BuildContext context) {
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
                  height: 400,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                        child: TextField(
                          focusNode: titleFocusNode,
                          controller: titleController,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
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
                          padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                          child: TextField(
                            focusNode: contentsFocusNode,
                            controller: contentsController,
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
    );
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
                  height: (selectedThumbDatas.length > 0) ? 400 : 114,
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
                                      selectedThumbDatas.length,
                                      maxPicturesCount
                                    ]),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MainTheme.enabledButtonColor),
                              ),
                              onPressed: () {
                                if (selectedThumbDatas.length >=
                                    maxPicturesCount) {
                                  showInSnackBar(LocalizableLoader.of(context)
                                      .text("notice_remove_pictures"));
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
                      selectedThumbDatas.length == 0
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
                          focusNode: youtubeFocusNode,
                          controller: youtubeController,
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
    if (selectedThumbDatas.length <= 0) {
      return Container();
    }

    return GridView.count(
      padding: MainTheme.edgeInsets,
      crossAxisCount: 4,
      children: List.generate(selectedThumbDatas.length, (index) {
        ByteData data = selectedThumbDatas[index];
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
                selectedThumbDatas.removeAt(index);
                selectedOriginalDatas.removeAt(index);
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

  Widget _buildCheckBox(BuildContext context) {
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
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 7, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(
                                value: enabled,
                                onChanged: (bool value) {
                                  setState(() {
                                    enabled = value;
                                  });
                                },
                              ),
                              Text(
                                LocalizableLoader.of(context)
                                    .text("phone_number_agree_checkbox"),
                                style: MainTheme.contentsTextStyle,
                              ),
                            ],
                          )),
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

  Widget _buildRegistButton(BuildContext context) {
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
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              LocalizableLoader.of(context).text("board_regist_button"),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          onPressed: () {
            _requestRegist(context);
          }),
    );
  }

  void _requestRegist(BuildContext context) {
    if (together.dateString == null || together.dateString.length <= 0) {
      FailSnackbar().show("error_together_form_date", null);
      return;
    }

    if (together.totalCount < 2 || together.restCount < 1) {
      FailSnackbar().show("error_together_form_count", null);
      return;
    }

    if (together.clubID == null || together.clubID.length <= 0) {
      FailSnackbar().show("error_together_form_club", null);
      return;
    }

    if (together.hardCount == 0 && together.champagneCount == 0) {
      FailSnackbar().show("error_together_form_cocktail", null);
      return;
    }

    if (together.tablePrice <= 0) {
      FailSnackbar().show("error_together_form_price", null);
      return;
    }

    if (titleController.text.length <= 0) {
      FailSnackbar().show("error_together_form_title", null);
      return;
    }

    if (contentsController.text.length <= 0) {
      FailSnackbar().show("error_together_form_title", null);
      return;
    }

    together.title = titleController.text;
    together.contents = contentsController.text;
    together.youtubeUrl = youtubeController.text;

    _togetherBloc.dispatch(CreateTogetherEvent(
        together: together, byteDatas: selectedOriginalDatas));

    return;
  }
}
