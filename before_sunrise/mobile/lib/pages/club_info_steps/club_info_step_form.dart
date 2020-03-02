import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart';

class ClubInfoStepForm extends StatefulWidget {
  static const String routeName = "/clubInfoStepForm";
  const ClubInfoStepForm({Key key, this.editClubInfo, this.editImageMap})
      : super(key: key);

  final ClubInfo editClubInfo;
  final Map<String, dynamic> editImageMap;
  @override
  ClubInfoStepFormState createState() {
    return new ClubInfoStepFormState();
  }
}

class ClubInfoStepFormState extends State<ClubInfoStepForm>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ClubInfoBloc _clubInfoBloc = ClubInfoBloc();
  final TextFocusCreator _nameTextFocusCreator = new TextFocusCreator();
  final TextFocusCreator _regionTextFocusCreator = new TextFocusCreator();
  final TextFocusCreator _addressTextFocusCreator = new TextFocusCreator();
  final TextFocusCreator _noticeTextFocusCreator = new TextFocusCreator();
  final TextFocusCreator _youtubeTextFocusCreator = new TextFocusCreator();
  final TextFocusCreator _entrancePriceTextFocusCreator =
      new TextFocusCreator();
  final TextFocusCreator _tablePriceTextFocusCreator = new TextFocusCreator();

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
// multi image picker 이미지 데이터가 사라짐. 받아오면 바로 백업.
  final List<ByteData> _selectedOriginalDatas = List<ByteData>();
  Map<String, dynamic> _editImageMap = Map<String, dynamic>();
  List<String> _removeImageUrls = List<String>();

  bool enabledHiphop = false;
  bool enabledEDM = false;

  String timeSun = "";
  String timeMon = "";
  String timeTue = "";
  String timeWed = "";
  String timeThu = "";
  String timeFri = "";
  String timeSat = "";

  int currentStep = 0;
  final int maxPicturesCount = 20;
  String _error;
  ClubInfo _clubInfo;
  @override
  void initState() {
    super.initState();
    if (widget.editClubInfo != null) {
      _clubInfo = widget.editClubInfo.copyWith();
      if (widget.editImageMap != null) {
        var keys = widget.editImageMap.keys.toList();
        for (var key in keys) {
          ByteData byteData = widget.editImageMap[key];
          _selectedOriginalDatas.add(byteData);
          _editImageMap[key] = key;
        }
      }
    } else {
      _clubInfo = ClubInfo();
    }

    SuccessSnackBar().initialize(_scaffoldKey);
    FailSnackBar().initialize(_scaffoldKey);
    _updateEditMode();
  }

  _updateEditMode() => Future.delayed(Duration(milliseconds: 500), () async {
        if (widget.editClubInfo == null) {
          return;
        }

        _nameTextFocusCreator.textEditingController.text =
            widget.editClubInfo.name;
        _regionTextFocusCreator.textEditingController.text =
            widget.editClubInfo.regionKey;
        _addressTextFocusCreator.textEditingController.text =
            widget.editClubInfo.address;
        _noticeTextFocusCreator.textEditingController.text =
            widget.editClubInfo.notice;
        _entrancePriceTextFocusCreator.textEditingController.text =
            widget.editClubInfo.entrancePrice;
        _tablePriceTextFocusCreator.textEditingController.text =
            widget.editClubInfo.tablePrice;

        if (widget.editClubInfo.imageUrls == null) {
          return;
        }
      });

  @override
  void dispose() {
    _nameTextFocusCreator.focusNode.dispose();
    _regionTextFocusCreator.focusNode.dispose();
    _addressTextFocusCreator.focusNode.dispose();
    _noticeTextFocusCreator.focusNode.dispose();
    _entrancePriceTextFocusCreator.focusNode.dispose();
    _tablePriceTextFocusCreator.focusNode.dispose();

    _clubInfo = ClubInfo();
    SuccessSnackBar().initialize(null);
    FailSnackBar().initialize(null);
    KeyboardDetector().setContext(null, 0);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    KeyboardDetector().setContext(context, 0);
    var defaultInfoStep = new Step(
        title: Text(LocalizableLoader.of(context).text("default_info")),
        isActive: true,
        state: StepState.indexed,
        content: _buildDefaultInfos());
    var detailInfoStep = new Step(
        title: Text(LocalizableLoader.of(context).text("operation_info")),
        isActive: true,
        state: StepState.indexed,
        content: _buildDetailInfos());
    var mediaStep = new Step(
        title: Text(LocalizableLoader.of(context).text("media_info")),
        isActive: true,
        state: StepState.indexed,
        content: _buildGalleryFiles(context));
    var registStep = new Step(
        title: Text(LocalizableLoader.of(context).text("regist")),
        isActive: true,
        state: StepState.complete,
        content: _buildAgree());
    List<Step> steps = [];
    steps.add(defaultInfoStep);
    steps.add(detailInfoStep);
    steps.add(mediaStep);
    steps.add(registStep);

    return BlocListener(
        bloc: _clubInfoBloc,
        listener: (context, state) async {
          if (state is SuccessClubInfoState) {
            SuccessSnackBar().show("success_clubInfo", () {
              Navigator.pop(context);
            });

            return;
          }
        },
        child: BlocBuilder<ClubInfoBloc, ClubInfoState>(
            bloc: _clubInfoBloc,
            builder: (
              BuildContext context,
              ClubInfoState currentState,
            ) {
              return Scaffold(
                appBar: ClubInfoStepBar(),
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

  Widget _buildDefaultInfos() {
    // var check = CoreConst.hiphopType; // | CoreConst.hiphopType;
    // print("edm ${check & 1}");
    // print("hiphop ${check & (1 << 1)}");
    var selectOperatingTime =
        LocalizableLoader.of(context).text("select_operating_time");
    return Card(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
            width: kDeviceWidth - MainTheme.edgeInsets.left,
            height: 360,
            child: new ListView(
              shrinkWrap: true,
              reverse: false,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Stack(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: new Form(
                              autovalidate: false,
                              child: new Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new TextFormField(
                                    maxLength: 64,
                                    focusNode: _nameTextFocusCreator.focusNode,
                                    controller: _nameTextFocusCreator
                                        .textEditingController,
                                    decoration: new InputDecoration(
                                      labelText: LocalizableLoader.of(context)
                                          .text("input_club_name"),
                                      filled: false,
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.cocktail,
                                        size: 14,
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                  ),
                                  new TextFormField(
                                    maxLength: 64,
                                    focusNode:
                                        _regionTextFocusCreator.focusNode,
                                    controller: _regionTextFocusCreator
                                        .textEditingController,
                                    decoration: new InputDecoration(
                                      labelText: LocalizableLoader.of(context)
                                          .text("input_club_region"),
                                      filled: false,
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.mapSigns,
                                        size: 14,
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                  ),
                                  new TextFormField(
                                    maxLength: 64,
                                    focusNode:
                                        _addressTextFocusCreator.focusNode,
                                    controller: _addressTextFocusCreator
                                        .textEditingController,
                                    decoration: new InputDecoration(
                                      labelText: LocalizableLoader.of(context)
                                          .text("input_club_address"),
                                      filled: false,
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.mapMarkerAlt,
                                        size: 14,
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            value: enabledHiphop,
                                            onChanged: (bool value) {
                                              setState(() {
                                                enabledHiphop = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            LocalizableLoader.of(context)
                                                .text("hiphop_genre_checkbox"),
                                            style: MainTheme.contentsTextStyle,
                                          ),
                                          Checkbox(
                                            value: enabledEDM,
                                            onChanged: (bool value) {
                                              setState(() {
                                                enabledEDM = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            LocalizableLoader.of(context)
                                                .text("edm_genre_checkbox"),
                                            style: MainTheme.contentsTextStyle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: <Widget>[
                            Text(LocalizableLoader.of(context).text("day_sun")),
                            OperateTimeDialog(
                              title: timeSun.isNotEmpty
                                  ? timeSun
                                  : selectOperatingTime,
                              callback: (time) {
                                setState(() {
                                  timeSun = time;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(children: <Widget>[
                            Text(LocalizableLoader.of(context).text("day_mon")),
                            OperateTimeDialog(
                              title: timeMon.isNotEmpty
                                  ? timeMon
                                  : selectOperatingTime,
                              callback: (time) {
                                setState(() {
                                  timeMon = time;
                                });
                              },
                            ),
                          ])),
                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(children: <Widget>[
                            Text(LocalizableLoader.of(context).text("day_tue")),
                            OperateTimeDialog(
                              title: timeTue.isNotEmpty
                                  ? timeTue
                                  : selectOperatingTime,
                              callback: (time) {
                                setState(() {
                                  timeTue = time;
                                });
                              },
                            ),
                          ])),
                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(children: <Widget>[
                            Text(LocalizableLoader.of(context).text("day_wed")),
                            OperateTimeDialog(
                              title: timeWed.isNotEmpty
                                  ? timeWed
                                  : selectOperatingTime,
                              callback: (time) {
                                setState(() {
                                  timeWed = time;
                                });
                              },
                            ),
                          ])),
                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(children: <Widget>[
                            Text(LocalizableLoader.of(context).text("day_thu")),
                            OperateTimeDialog(
                              title: timeThu.isNotEmpty
                                  ? timeThu
                                  : selectOperatingTime,
                              callback: (time) {
                                setState(() {
                                  timeThu = time;
                                });
                              },
                            ),
                          ])),
                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(children: <Widget>[
                            Text(LocalizableLoader.of(context).text("day_fri")),
                            OperateTimeDialog(
                              title: timeFri.isNotEmpty
                                  ? timeFri
                                  : selectOperatingTime,
                              callback: (time) {
                                setState(() {
                                  timeFri = time;
                                });
                              },
                            ),
                          ])),
                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(children: <Widget>[
                            Text(LocalizableLoader.of(context).text("day_sat")),
                            OperateTimeDialog(
                              title: timeSat.isNotEmpty
                                  ? timeSat
                                  : selectOperatingTime,
                              callback: (time) {
                                setState(() {
                                  timeSat = time;
                                });
                              },
                            ),
                          ]))
                    ]),
              ],
            )));
  }

  Widget _buildDetailInfos() {
    return Card(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
            width: kDeviceWidth - MainTheme.edgeInsets.left,
            height: 360,
            child: new ListView(
              shrinkWrap: true,
              reverse: false,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Stack(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: new Form(
                              autovalidate: false,
                              child: new Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new TextFormField(
                                    maxLength: 64,
                                    focusNode: _entrancePriceTextFocusCreator
                                        .focusNode,
                                    controller: _entrancePriceTextFocusCreator
                                        .textEditingController,
                                    decoration: new InputDecoration(
                                      labelText: LocalizableLoader.of(context)
                                          .text("title_entrance_price"),
                                      filled: false,
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.wonSign,
                                        size: 14,
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                  ),
                                  new TextFormField(
                                    maxLength: 64,
                                    focusNode:
                                        _tablePriceTextFocusCreator.focusNode,
                                    controller: _tablePriceTextFocusCreator
                                        .textEditingController,
                                    decoration: new InputDecoration(
                                      labelText: LocalizableLoader.of(context)
                                          .text("title_table_price"),
                                      filled: false,
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.vectorSquare,
                                        size: 14,
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                  ),
                                  new TextFormField(
                                    maxLength: 512,
                                    maxLines: 10,
                                    focusNode:
                                        _noticeTextFocusCreator.focusNode,
                                    controller: _noticeTextFocusCreator
                                        .textEditingController,
                                    decoration: new InputDecoration(
                                      labelText: LocalizableLoader.of(context)
                                          .text("title_notice"),
                                      filled: false,
                                      labelStyle: MainTheme.hintTextStyle,
                                      prefixIcon: Icon(
                                          FontAwesomeIcons.alignJustify,
                                          size: 14),
                                    ),
                                    keyboardType: TextInputType.multiline,
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                )
              ],
            )));
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
                  height: (_selectedOriginalDatas.length > 0) ? 360 : 118,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 9, top: 5, bottom: 5),
                          child: FlatButton.icon(
                              focusColor: Colors.red,
                              icon: Icon(
                                FontAwesomeIcons.image,
                                color: MainTheme.enabledButtonColor,
                                size: 18,
                              ),
                              label: Text(
                                sprintf(
                                    LocalizableLoader.of(context)
                                        .text("add_pictures"),
                                    [
                                      _selectedOriginalDatas.length,
                                      maxPicturesCount
                                    ]),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MainTheme.enabledButtonColor),
                              ),
                              onPressed: () {
                                if (_selectedOriginalDatas.length >=
                                    maxPicturesCount) {
                                  FailSnackBar().show("remove_pictures", null);

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
                          focusNode: _youtubeTextFocusCreator.focusNode,
                          controller:
                              _youtubeTextFocusCreator.textEditingController,
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
                                .text("youtube_hint"),
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
                FontAwesomeIcons.trash,
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
            height: 250,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    SanctionContents(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[],
                    ),
                  ],
                ))));
  }

  void _touchedRegistButton(int lastIndex) {
    if (currentStep == 0 || currentStep == lastIndex) {
      if (_clubInfo.genreType == 0) {
        FailSnackBar().show("error_clubInfo_form_genre_type", null);
        return;
      }
    }

    if (currentStep == 1 || currentStep == lastIndex) {
      if (_nameTextFocusCreator.textEditingController.text.length <= 0) {
        FailSnackBar().show("error_clubInfo_form_name", null);
        return;
      }

      if (_regionTextFocusCreator.textEditingController.text.length <= 0) {
        FailSnackBar().show("error_clubInfo_form_region", null);
        return;
      }

      if (_addressTextFocusCreator.textEditingController.text.length <= 0) {
        FailSnackBar().show("error_clubInfo_form_address", null);
        return;
      }
    }

    if (currentStep == 2 || currentStep == lastIndex) {
      if (_entrancePriceTextFocusCreator.textEditingController.text.length <=
          0) {
        FailSnackBar().show("error_clubInfo_form_entrance", null);
        return;
      }

      if (_tablePriceTextFocusCreator.textEditingController.text.length <= 0) {
        FailSnackBar().show("error_clubInfo_form_table", null);
        return;
      }
    }

    setState(() {
      if (currentStep < lastIndex) {
        currentStep = currentStep + 1;
      } else {
        _clubInfo.name = _nameTextFocusCreator.textEditingController.text;
        _clubInfo.address = _addressTextFocusCreator.textEditingController.text;
        _clubInfo.youtubeUrls = [
          _youtubeTextFocusCreator.textEditingController.text
        ];

        _clubInfo.entrancePrice =
            _entrancePriceTextFocusCreator.textEditingController.text;
        _clubInfo.tablePrice =
            _tablePriceTextFocusCreator.textEditingController.text;

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

        _clubInfoBloc.dispatch(CreateClubInfoEvent(
            post: _clubInfo,
            byteDatas: _selectedOriginalDatas,
            removedImageUrls: _removeImageUrls,
            alreadyImageUrls: alreadyImageUrls));

        return;
      }
    });
  }
}
