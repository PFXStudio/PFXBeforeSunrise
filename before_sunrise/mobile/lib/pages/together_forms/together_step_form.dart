import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/pages/together_forms/together_form_club.dart';
import 'package:before_sunrise/pages/together_forms/together_form_price.dart';

class TogetherStepForm extends StatefulWidget {
  static const String routeName = "/togetherStepForm";
  TogetherStepForm({Key key, this.editPost, this.editImageMap})
      : super(key: key);

  final Together editPost;
  final Map<String, dynamic> editImageMap;

  @override
  _TogetherStepFormState createState() => new _TogetherStepFormState();
}

class _TogetherStepFormState extends State<TogetherStepForm>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TogetherBloc _togetherBloc = TogetherBloc();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _contentsController = new TextEditingController();
  final TextEditingController _youtubeController = new TextEditingController();

  FocusNode _titleFocusNode = new FocusNode();
  FocusNode _contentsFocusNode = new FocusNode();
  FocusNode _youtubeFocusNode = new FocusNode();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Together _together;
// multi image picker 이미지 데이터가 사라짐. 받아오면 바로 백업.
  final List<ByteData> _selectedOriginalDatas = List<ByteData>();
  Map<String, dynamic> _editImageMap = Map<String, dynamic>();
  List<String> _removeImageUrls = List<String>();

  int currentStep = 0;
  final int maxPicturesCount = 20;
  String _error;
  bool sanctionAgreeEnabled = false;
  bool phoneNumberAgreeEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.editPost != null) {
      _together = widget.editPost.copyWith();
      if (widget.editImageMap != null) {
        var keys = widget.editImageMap.keys.toList();
        for (var key in keys) {
          ByteData byteData = widget.editImageMap[key];
          _selectedOriginalDatas.add(byteData);
          _editImageMap[key] = key;
        }
      }
    } else {
      _together = Together();
    }

    SuccessSnackbar().initialize(_scaffoldKey);
    FailSnackbar().initialize(_scaffoldKey);
    _updateEditMode();
  }

  _updateEditMode() => Future.delayed(Duration(milliseconds: 500), () async {
        if (widget.editPost == null) {
          return;
        }

        _titleController.text = widget.editPost.title;
        _contentsController.text = widget.editPost.contents;
        _youtubeController.text = widget.editPost.youtubeUrl;

        if (widget.editPost.imageUrls == null) {
          return;
        }
      });

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _contentsFocusNode.dispose();
    _youtubeFocusNode.dispose();
    _together = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Step> steps = [
      new Step(
          title: const Text('정보'),
          isActive: true,
          state: StepState.indexed,
          content: _buildInfo()),
      new Step(
          title: const Text('내용'),
          isActive: true,
          state: StepState.indexed,
          content: _buildContents()),
      new Step(
          title: const Text('미디어'),
          isActive: true,
          state: StepState.indexed,
          content: _buildGalleryFiles(context)),
      new Step(
          title: const Text('등록'),
          isActive: true,
          state: StepState.complete,
          content: _buildAgree()),
    ];

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
                resizeToAvoidBottomInset: false,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: TogetherFormTopBar(),
                ),
                key: _scaffoldKey,
                body: Container(
                  child: new ListView(
                    children: <Widget>[
                      new Stepper(
                        steps: steps,
                        type: StepperType.vertical,
                        currentStep: currentStep,
                        onStepContinue: () {
                          _touchedRegistButton(steps.length - 1);
                        },
                        onStepCancel: () {
                          setState(() {
                            if (currentStep > 0) {
                              currentStep = currentStep - 1;
                            } else {
                              currentStep = 0;
                            }
                          });
                        },
                        onStepTapped: (step) {
                          setState(() {
                            currentStep = step;
                          });
                        },
                      ),
                    ],
                    shrinkWrap: true,
                    reverse: true,
                  ),
                ),
              );
            }));
  }

  Widget _buildInfo() {
    return Card(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
            width: kDeviceWidth - MainTheme.edgeInsets.left,
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TogetherFormDate(
                    editSelectedDate: (_together.dateString != null &&
                            _together.dateString.length > 0)
                        ? CoreConst.togetherDateFormat
                            .parse(_together.dateString)
                        : null,
                    callback: (dateTime) {
                      if (dateTime == null) {
                        return;
                      }

                      _together.dateString =
                          CoreConst.togetherDateFormat.format(dateTime);
                    }),
                TogetherFormClub(
                  editSelectedClubID:
                      (_together.clubID != null && _together.clubID.length > 0)
                          ? _together.clubID
                          : null,
                  callback: (clubID) {
                    print(clubID);
                    _together.clubID = clubID;
                  },
                ),
                TogetherFormCocktailCount(
                  editCocktailCountInfo: (_together.hardCount != 0 &&
                          _together.champagneCount != 0 &&
                          _together.serviceCount != 0)
                      ? CocktailCountInfo(
                          hardCount: _together.hardCount.toDouble(),
                          champagneCount: _together.champagneCount.toDouble(),
                          serviceCount: _together.serviceCount.toDouble())
                      : null,
                  callback: (cocktailCountInfo) {
                    _together.hardCount = cocktailCountInfo.hardCount.toInt();
                    _together.champagneCount =
                        cocktailCountInfo.champagneCount.toInt();
                    _together.serviceCount =
                        cocktailCountInfo.serviceCount.toInt();
                  },
                ),
                TogetherFormPrice(
                    editPriceInfo: (_together.tablePrice != 0)
                        ? PriceInfo(
                            tablePrice: _together.tablePrice.toDouble(),
                            tipPrice: _together.tipPrice.toDouble())
                        : null,
                    callback: (priceInfo) {
                      _together.tablePrice = priceInfo.tablePrice.toInt();
                      _together.tipPrice = priceInfo.tipPrice.toInt();
                      setState(() {});
                    }),
                TogetherFormMemberCount(
                    editMemberCountInfo: (_together.totalCount != 0)
                        ? MemberCountInfo(
                            totalCount: _together.totalCount.toDouble(),
                            restCount: _together.restCount.toDouble())
                        : null,
                    callback: (memberCountInfo) {
                      _together.totalCount = memberCountInfo.totalCount.toInt();
                      _together.restCount = memberCountInfo.restCount.toInt();
                      setState(() {});
                    }),
                FlatIconTextButton(
                    color: MainTheme.enabledButtonColor,
                    iconData: FontAwesomeIcons.moneyBillWave,
                    text: (_together.totalCount != 0 &&
                            _together.tablePrice != 0)
                        ? "${_together.tablePrice + _together.tipPrice}만원 / ${_together.totalCount}명 = ${((_together.tablePrice + _together.tipPrice) / _together.totalCount.toDouble()).toStringAsFixed(1)} 만원"
                        : "..."),
              ],
            )));
  }

  Widget _buildContents() {
    return Card(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
            width: kDeviceWidth - MainTheme.edgeInsets.left,
            height: 400,
            child: Center(
                child: new ListView(
              shrinkWrap: true,
              reverse: false,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Center(
                        child: new Center(
                      child: new Stack(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 30.0, right: 30.0),
                              child: new Form(
                                autovalidate: false,
                                child: new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: new TextFormField(
                                        focusNode: _titleFocusNode,
                                        controller: _titleController,
                                        decoration: new InputDecoration(
                                            labelText: "Title",
                                            filled: false,
                                            labelStyle: MainTheme.hintTextStyle,
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 10.0,
                                                  top: 10.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              child: Icon(
                                                  FontAwesomeIcons.quoteLeft,
                                                  size: 14),
                                            )),
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0, bottom: 10),
                                      child: new TextFormField(
                                        maxLength: 512,
                                        maxLines: 10,
                                        focusNode: _contentsFocusNode,
                                        controller: _contentsController,
                                        decoration: new InputDecoration(
                                            labelText: "Contents",
                                            filled: false,
                                            labelStyle: MainTheme.hintTextStyle,
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 10.0,
                                                  top: 10.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              child: Icon(
                                                  FontAwesomeIcons.alignJustify,
                                                  size: 14),
                                            )),
                                        keyboardType: TextInputType.multiline,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ))
                  ],
                )
              ],
            ))));
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
                  width: kDeviceWidth - MainTheme.edgeInsets.left,
                  height: (_selectedOriginalDatas.length > 0) ? 300 : 114,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 7, top: 5, bottom: 5),
                          child: FlatButton.icon(
                              focusColor: Colors.red,
                              icon: Icon(
                                FontAwesomeIcons.images,
                                color: MainTheme.enabledButtonColor,
                                size: 15,
                              ),
                              label: Text(
                                sprintf(
                                    LocalizableLoader.of(context)
                                        .text("add_pictures_button"),
                                    [
                                      _selectedOriginalDatas.length,
                                      maxPicturesCount
                                    ]),
                                style: MainTheme.enabledFlatIconTextButtonStyle,
                              ),
                              onPressed: () {
                                if (_selectedOriginalDatas.length >=
                                    maxPicturesCount) {
                                  FailSnackbar()
                                      .show("notice_remove_pictures", null);

                                  return;
                                }

                                _loadAssets();
                              })),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Container(
                            width: kDeviceWidth - MainTheme.edgeInsets.left * 2,
                            height: 1.0,
                            color: Colors.grey[400],
                          )),
                      Expanded(child: _buildGridView(context)),
                      _selectedOriginalDatas.length == 0
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Container(
                                width: kDeviceWidth -
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
                              size: 15.0,
                            ),
                            hintText: LocalizableLoader.of(context)
                                .text("board_youtube_hint_text"),
                            hintStyle: MainTheme.hintTextStyle,
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
    if (_selectedOriginalDatas.length <= 0) {
      return Container();
    }

    return GridView.count(
      padding: MainTheme.edgeInsets,
      crossAxisCount: 4,
      children: List.generate(_selectedOriginalDatas.length, (index) {
        ByteData data = _selectedOriginalDatas[index];
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
                FontAwesomeIcons.trashAlt,
                size: 20,
              ),
              color: MainTheme.enabledIconColor,
              onPressed: () {
                if (_editImageMap != null &&
                    _editImageMap.keys.length > index) {
                  var keys = _editImageMap.keys.toList();
                  String key = keys[index];
                  _removeImageUrls.add(key);
                  _editImageMap.remove(keys[index]);
                }

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

  Future<void> _loadAssets() async {
    setState(() {});

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxPicturesCount - _selectedOriginalDatas.length,
      );

      if (resultList.length > 0) {
        for (Asset asset in resultList) {
          ByteData originalData = await asset.getByteData();
          _selectedOriginalDatas.add(originalData);
        }
      }
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      if (_selectedOriginalDatas.length > maxPicturesCount) {
        int end = _selectedOriginalDatas.length - maxPicturesCount - 1;
        _selectedOriginalDatas.removeRange(0, end);
      }

      if (error == null) _error = 'No Error Dectected';
    });
  }

  Widget _buildAgree() {
    return Card(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
            width: kDeviceWidth - MainTheme.edgeInsets.left,
            height: kDeviceHeight * 0.45,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    SanctionContents(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          value: sanctionAgreeEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              sanctionAgreeEnabled = value;
                            });
                          },
                        ),
                        Text(
                          LocalizableLoader.of(context)
                              .text("sanction_agree_checkbox"),
                          style: MainTheme.contentsTextStyle,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          value: phoneNumberAgreeEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              phoneNumberAgreeEnabled = value;
                            });
                          },
                        ),
                        Text(
                          LocalizableLoader.of(context)
                              .text("phone_number_agree_checkbox"),
                          style: MainTheme.contentsTextStyle,
                        ),
                      ],
                    ),
                  ],
                ))));
  }

  void _touchedRegistButton(int lastIndex) {
    if (currentStep == 0 || currentStep == lastIndex) {
      if (_together.dateString == null || _together.dateString.length <= 0) {
        FailSnackbar().show("error_together_form_date", () {
          setState(() {
            currentStep = 0;
          });
        });
        return;
      }

      if (_together.clubID == null || _together.clubID.length <= 0) {
        FailSnackbar().show("error_together_form_club", () {
          setState(() {
            currentStep = 0;
          });
        });
        return;
      }

      if (_together.hardCount == 0 && _together.champagneCount == 0) {
        FailSnackbar().show("error_together_form_cocktail", () {
          setState(() {
            currentStep = 0;
          });
        });
        return;
      }

      if (_together.tablePrice <= 0) {
        FailSnackbar().show("error_together_form_price", () {
          setState(() {
            currentStep = 0;
          });
        });
        return;
      }

      if (_together.totalCount < 2 || _together.restCount < 1) {
        FailSnackbar().show("error_together_form_count", () {
          setState(() {
            currentStep = 0;
          });
        });
        return;
      }
    }

    if (currentStep == 1 || currentStep == lastIndex) {
      if (_titleController.text.length <= 0) {
        FailSnackbar().show("error_together_form_title", () {
          setState(() {
            currentStep = 1;
          });
        });
        return;
      }

      if (_contentsController.text.length <= 0) {
        FailSnackbar().show("error_together_form_contents", () {
          setState(() {
            currentStep = 1;
          });
        });
        return;
      }
    }

    if (currentStep == 2 || currentStep == lastIndex) {}
    if (currentStep == 3 || currentStep == lastIndex) {
      if (sanctionAgreeEnabled == false || phoneNumberAgreeEnabled == false) {
        FailSnackbar().show("error_agree_check", null);
        return;
      }
    }

    setState(() {
      if (currentStep < lastIndex) {
        currentStep = currentStep + 1;
      } else {
        _together.title = _titleController.text;
        _together.contents = _contentsController.text;
        _together.youtubeUrl = _youtubeController.text;

        // _removeImageUrls 삭제 된 이미지들
        // _editImageMap 유지 된 이미지들
        List<String> alreadyImageUrls = List<String>();
        if (_editImageMap != null && _editImageMap.keys.length > 0) {
          var keys = _editImageMap.keys.toList();
          for (var key in keys) {
            alreadyImageUrls.add(key);
          }

          // _selectedOriginalDatas에서 _editImageMap 갯수 이후는 추가 된 이미지들
          var length = _editImageMap.length;
          for (int i = 0; i < length; i++) {
            _selectedOriginalDatas.removeAt(0);
          }
        }

        _togetherBloc.dispatch(CreateTogetherEvent(
            together: _together,
            byteDatas: _selectedOriginalDatas,
            removedImageUrls: _removeImageUrls,
            alreadyImageUrls: alreadyImageUrls));

        return;
      }
    });
  }
}
