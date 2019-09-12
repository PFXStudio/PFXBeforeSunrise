import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/pages/together_forms/together_form_club.dart';
import 'package:before_sunrise/pages/together_forms/together_form_price.dart';

class TogetherStepForm extends StatefulWidget {
  static const String routeName = "/togetherStepForm";
  TogetherStepForm({Key key}) : super(key: key);

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

  FocusNode _focusNode = new FocusNode();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Together together = Together();
// multi image picker 이미지 데이터가 사라짐. 받아오면 바로 백업.
  final List<ByteData> selectedThumbDatas = List<ByteData>();
  final List<ByteData> selectedOriginalDatas = List<ByteData>();

  int currentStep = 0;
  final int maxPicturesCount = 20;
  String _error;
  bool enabled = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });

    SuccessSnackbar().initialize(_scaffoldKey);
    FailSnackbar().initialize(_scaffoldKey);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    together = Together();

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
                          if (currentStep == 0 ||
                              currentStep == steps.length - 1) {
                            if (together.dateString == null ||
                                together.dateString.length <= 0) {
                              FailSnackbar().show("error_together_form_date",
                                  () {
                                setState(() {
                                  currentStep = 0;
                                });
                              });
                              return;
                            }

                            if (together.clubID == null ||
                                together.clubID.length <= 0) {
                              FailSnackbar().show("error_together_form_club",
                                  () {
                                setState(() {
                                  currentStep = 0;
                                });
                              });
                              return;
                            }

                            if (together.hardCount == 0 &&
                                together.champagneCount == 0) {
                              FailSnackbar()
                                  .show("error_together_form_cocktail", () {
                                setState(() {
                                  currentStep = 0;
                                });
                              });
                              return;
                            }

                            if (together.tablePrice <= 0) {
                              FailSnackbar().show("error_together_form_price",
                                  () {
                                setState(() {
                                  currentStep = 0;
                                });
                              });
                              return;
                            }

                            if (together.totalCount < 2 ||
                                together.restCount < 1) {
                              FailSnackbar().show("error_together_form_count",
                                  () {
                                setState(() {
                                  currentStep = 0;
                                });
                              });
                              return;
                            }
                          }

                          if (currentStep == 1 ||
                              currentStep == steps.length - 1) {
                            if (_titleController.text.length <= 0) {
                              FailSnackbar().show("error_together_form_title",
                                  () {
                                setState(() {
                                  currentStep = 1;
                                });
                              });
                              return;
                            }

                            if (_contentsController.text.length <= 0) {
                              FailSnackbar()
                                  .show("error_together_form_contents", () {
                                setState(() {
                                  currentStep = 1;
                                });
                              });
                              return;
                            }
                          }

                          if (currentStep == 2 ||
                              currentStep == steps.length - 1) {}
                          if (currentStep == 3 ||
                              currentStep == steps.length - 1) {
                            if (enabled == false) {
                              FailSnackbar()
                                  .show("error_agree_phone_number", null);
                              return;
                            }
                          }

                          setState(() {
                            if (currentStep < steps.length - 1) {
                              currentStep = currentStep + 1;
                            } else {
                              together.title = _titleController.text;
                              together.contents = _contentsController.text;
                              together.youtubeUrl = _youtubeController.text;

                              _togetherBloc.dispatch(CreateTogetherEvent(
                                  together: together,
                                  byteDatas: selectedOriginalDatas));

                              return;
                            }
                          });
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
                TogetherFormDate(callback: (dateTime) {
                  if (dateTime == null) {
                    return;
                  }

                  together.dateString =
                      CoreConst.togetherDateFormat.format(dateTime);
                }),
                TogetherFormClub(
                  callback: (clubID) {
                    print(clubID);
                    together.clubID = clubID;
                  },
                ),
                TogetherFormCocktailCount(
                  callback: (hardCount, champagneCount, serviceCount) {
                    together.hardCount = hardCount;
                    together.champagneCount = champagneCount;
                    together.serviceCount = serviceCount;
                  },
                ),
                TogetherFormPrice(callback: (tablePrice, tipPrice) {
                  together.tablePrice = tablePrice;
                  together.tipPrice = tipPrice;
                  setState(() {});
                }),
                TogetherFormMemberCount(callback: (totalCount, restCount) {
                  together.totalCount = totalCount;
                  together.restCount = restCount;
                  setState(() {});
                }),
                FlatIconTextButton(
                    color: MainTheme.enabledButtonColor,
                    iconData: FontAwesomeIcons.moneyBillWave,
                    text: (together.totalCount != 0 && together.tablePrice != 0)
                        ? "${together.tablePrice + together.tipPrice}만원 / ${together.totalCount}명 = ${((together.tablePrice + together.tipPrice) / together.totalCount.toDouble()).toStringAsFixed(1)} 만원"
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
                                          left: 10.0, right: 10.0),
                                      child: new TextFormField(
                                        maxLines: 15,
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
                  height: (selectedThumbDatas.length > 0) ? 300 : 114,
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
                                      selectedThumbDatas.length,
                                      maxPicturesCount
                                    ]),
                                style: MainTheme.enabledFlatIconTextButtonStyle,
                              ),
                              onPressed: () {
                                if (selectedThumbDatas.length >=
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
                      selectedThumbDatas.length == 0
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
                          focusNode: _focusNode,
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
                FontAwesomeIcons.trashAlt,
                size: 20,
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

  Widget _buildAgree() {
    return Card(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
            width: kDeviceWidth - MainTheme.edgeInsets.left,
            height: 230,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    SanctionContents(),
                    Row(
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
                    ),
                  ],
                ))));
  }
}
