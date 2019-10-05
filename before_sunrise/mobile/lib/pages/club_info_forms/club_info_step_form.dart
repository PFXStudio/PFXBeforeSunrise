import 'package:before_sunrise/import.dart';

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
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _zoneController = new TextEditingController();
  final TextEditingController _addressController = new TextEditingController();
  final TextEditingController _genreTypeController =
      new TextEditingController();
  final TextEditingController _entrancePriceController =
      new TextEditingController();
  final TextEditingController _tablePriceController =
      new TextEditingController();
  final TextEditingController _noticeController = new TextEditingController();
  final TextEditingController _openTimeMapController =
      new TextEditingController();
  final TextEditingController _youtubeController = new TextEditingController();

  FocusNode _titleFocusNode = new FocusNode();
  FocusNode _contentsFocusNode = new FocusNode();
  FocusNode _youtubeFocusNode = new FocusNode();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
// multi image picker 이미지 데이터가 사라짐. 받아오면 바로 백업.
  final List<ByteData> _selectedOriginalDatas = List<ByteData>();
  Map<String, dynamic> _editImageMap = Map<String, dynamic>();
  List<String> _removeImageUrls = List<String>();

  bool sanctionAgreeEnabled = false;
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

    SuccessSnackbar().initialize(_scaffoldKey);
    FailSnackbar().initialize(_scaffoldKey);
    _updateEditMode();
  }

  _updateEditMode() => Future.delayed(Duration(seconds: 1), () async {
        if (widget.editClubInfo == null) {
          return;
        }

        _nameController.text = widget.editClubInfo.name;
        _zoneController.text = widget.editClubInfo.zone;
        _addressController.text = widget.editClubInfo.address;
        // _typeController.text = widget.editClubInfo.type;
        _entrancePriceController.text = widget.editClubInfo.entrancePrice;
        _tablePriceController.text = widget.editClubInfo.tablePrice;
        _noticeController.text = widget.editClubInfo.notice;
        // _openTimeMapController.text = widget.editClubInfo.openTimeMap;

        if (widget.editClubInfo.imageUrls == null) {
          return;
        }
      });

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _contentsFocusNode.dispose();
    _youtubeFocusNode.dispose();
    _clubInfo = ClubInfo();
    SuccessSnackbar().initialize(null);
    FailSnackbar().initialize(null);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var typeStep = new Step(
        title: const Text('주소'),
        isActive: true,
        state: StepState.indexed,
        content: _buildAddress());

    var contentsStep = new Step(
        title: const Text('내용'),
        isActive: true,
        state: StepState.indexed,
        content: _buildContents());
    var mediaStep = new Step(
        title: const Text('미디어'),
        isActive: true,
        state: StepState.indexed,
        content: _buildGalleryFiles(context));
    var registStep = new Step(
        title: const Text('등록'),
        isActive: true,
        state: StepState.complete,
        content: _buildAgree());
    List<Step> steps = [];
    steps.add(typeStep);
    steps.add(contentsStep);
    steps.add(mediaStep);
    steps.add(registStep);

    return BlocListener(
        bloc: _clubInfoBloc,
        listener: (context, state) async {
          if (state is SuccessClubInfoState) {
            SuccessSnackbar().show("success_clubInfo", () {
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

  Widget _buildAddress() {
    if (widget.editClubInfo != null) {
      return Card(
          elevation: 2.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
              width: kDeviceWidth - MainTheme.edgeInsets.left,
              height: 45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FlatIconTextButton(
                    iconData: FontAwesomeIcons.thLarge,
                    color: MainTheme.enabledButtonColor,
                    text: "type",
                    enabled: false,
                  )
                ],
              )));
    }
    return DialogClubInfoAddress(
      callback: (String address) {
        print(address);
      },
    );
  }

  Widget _buildType() {
    if (widget.editClubInfo != null) {
      return Card(
          elevation: 2.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
              width: kDeviceWidth - MainTheme.edgeInsets.left,
              height: 45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FlatIconTextButton(
                    iconData: FontAwesomeIcons.thLarge,
                    color: MainTheme.enabledButtonColor,
                    text: "type",
                    enabled: false,
                  )
                ],
              )));
    }
    return Card(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
            width: kDeviceWidth - MainTheme.edgeInsets.left,
            height: 45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DialogClubInfoGenreType(
                  callback: (type) {
                    setState(() {
                      _clubInfo.genreType = type;
                    });
                  },
                ),
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
            height: 360,
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
                                        maxLength: 64,
                                        focusNode: _titleFocusNode,
                                        controller: _nameController,
                                        decoration: new InputDecoration(
                                            labelText: "Title",
                                            filled: false,
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 10.0,
                                                  top: 10.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              child: Icon(
                                                FontAwesomeIcons.quoteLeft,
                                                size: 14,
                                              ),
                                            )),
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: new TextFormField(
                                        maxLength: 512,
                                        maxLines: 10,
                                        focusNode: _contentsFocusNode,
                                        controller: _addressController,
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
                  height: (_selectedOriginalDatas.length > 0) ? 360 : 114,
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
                                        .text("add_pictures_button"),
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
                  ],
                ))));
  }

  void _touchedRegistButton(int lastIndex) {
    if (currentStep == 0 || currentStep == lastIndex) {
      if (_clubInfo.genreType == 0) {
        FailSnackbar().show("error_clubInfo_form_genre_type", null);
        return;
      }
    }

    if (currentStep == 1 || currentStep == lastIndex) {
      if (_nameController.text.length <= 0) {
        FailSnackbar().show("error_clubInfo_form_title", null);
        return;
      }

      if (_addressController.text.length <= 0) {
        FailSnackbar().show("error_clubInfo_form_title", null);
        return;
      }
    }

    if (currentStep == 2 || currentStep == lastIndex) {}
    if (currentStep == 3 || currentStep == lastIndex) {
      if (sanctionAgreeEnabled == false) {
        FailSnackbar().show("error_agree_check", null);
        return;
      }
    }

    setState(() {
      if (currentStep < lastIndex) {
        currentStep = currentStep + 1;
      } else {
        _clubInfo.name = _nameController.text;
        _clubInfo.address = _addressController.text;
        _clubInfo.youtubeUrls = [_youtubeController.text];

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
