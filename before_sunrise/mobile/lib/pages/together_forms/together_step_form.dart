import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/import.dart' as prefix0;
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
                        onStepContinue: () {},
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TogetherFormDate(callback: (dateTime) {
          together.dateString = CoreConst.togetherDateFormat.format(dateTime);
        }),
        TogetherFormClub(
          callback: (clubID) {
            print(clubID);
            together.clubID = clubID;
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
        TogetherFormCocktailCount(
          callback: (hardCount, champagneCount, serviceCount) {
            together.hardCount = hardCount;
            together.champagneCount = champagneCount;
            together.serviceCount = serviceCount;
          },
        ),
        FlatIconTextButton(
            width: 200,
            color: prefix0.MainTheme.enabledButtonColor,
            iconData: FontAwesomeIcons.moneyBillWave,
            text: (together.totalCount != 0 && together.tablePrice != 0)
                ? "${together.tablePrice + together.tipPrice}만원 / ${together.totalCount}명 = ${((together.tablePrice + together.tipPrice) / together.totalCount.toDouble()).toStringAsFixed(1)} 만원"
                : "..."),
      ],
    );
  }

  Widget _buildContents() {
    return Center(
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
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new TextFormField(
                                controller: _titleController,
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
                                          prefix0.FontAwesomeIcons.pencilAlt),
                                    )),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 20, top: 5, bottom: 5),
                                child: TextField(
                                  focusNode: _focusNode,
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
                      )),
                ],
              ),
            ))
          ],
        )
      ],
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
                                  // TODO : Snackbar

                                  // showInSnackBar(LocalizableLoader.of(context)
                                  //     .text("notice_remove_pictures"));
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
                          focusNode: _focusNode,
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
    return Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: prefix0.Column(
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
        ));
  }
}
