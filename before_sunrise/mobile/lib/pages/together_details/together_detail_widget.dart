import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/pages/together_details/together_detail_poster.dart';
import 'package:timeago/timeago.dart' as timeago;

class TogetherDetailWidget extends StatefulWidget {
  TogetherDetailWidget(this.together);

  final Together together;

  @override
  _TogetherDetailWidgetState createState() => _TogetherDetailWidgetState();
}

class _TogetherDetailWidgetState extends State<TogetherDetailWidget> {
  ScrollController _scrollController;
  TogetherDetailScrollEffects _scrollEffects;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _scrollEffects = TogetherDetailScrollEffects();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      _scrollEffects.updateScrollOffset(context, _scrollController.offset);
    });
  }

  Widget _buildSynopsis() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: widget.together == null ? 12.0 : 0.0,
        bottom: 16.0,
      ),
      child: TogetherDetailContentsWidget(widget.together),
    );
  }

  Widget _buildGallery() => widget.together.imageUrls.isNotEmpty
      ? TogetherDetailGalleryGridWidget(widget.together)
      : Container(color: Colors.white, height: 0.0);

  Widget _buildEventBackdrop() {
    return Positioned(
      top: _scrollEffects.headerOffset,
      child: TogetherDetailBackdropPhotoWidget(
        together: widget.together,
        scrollEffects: _scrollEffects,
      ),
    );
  }

  Widget _buildStatusBarBackground() {
    final statusBarColor = Theme.of(context).primaryColor;

    return Container(
      height: _scrollEffects.statusBarHeight,
      color: statusBarColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[
      _Header(widget.together),
    ];

    addIfNonNull(_buildSynopsis(), content);
    addIfNonNull(_buildGallery(), content);
    // addIfNonNull(_buildJoin(context), content);
    addIfNonNull(
        Padding(
          padding: EdgeInsets.only(bottom: 100),
          child: Container(),
        ),
        content);

    // Some padding for the bottom.
    content.add(const SizedBox(height: 32.0));

    final slivers = CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(delegate: SliverChildListDelegate(content)),
      ],
    );

    final double _initFabHeight = 120.0;
    double _fabHeight;
    double _panelHeightOpen = 575.0;
    double _panelHeightClosed = 95.0;

    return Scaffold(
        body: GestureDetector(
      onTapDown: (tap) { print("tap")},
      child: Stack(
        children: [
          // Container(
          //   decoration: new BoxDecoration(
          //     gradient: MainTheme.primaryLinearGradient,
          //   ),
          // ),
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: Stack(
              children: <Widget>[
                _buildEventBackdrop(),
                slivers,
                _BackButton(_scrollEffects),
                _buildStatusBarBackground(),
              ],
            ),
            panel: _panel(),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),
        ],
      ),
    ));
  }

  void touchedButton() {}
  Widget _panel() {
    final CommentBloc _commentBloc = CommentBloc();
    final Comment comment = Comment();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
              color: MainTheme.bgndColor,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0))),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 150,
                    child: BlocListener(
                        bloc: _commentBloc,
                        listener: (context, state) async {
                          print(state.toString());
                          if (state is SuccessCommentState) {
                            widget.together.commentCount++;
                          }
                        },
                        child: BlocBuilder<CommentBloc, CommentState>(
                            bloc: _commentBloc,
                            builder: (
                              BuildContext context,
                              CommentState currentState,
                            ) {
                              return FlatIconTextButton(
                                  color: Colors.white,
                                  iconData: FontAwesomeIcons.comment,
                                  text:
                                      "Comments (${widget.together.commentCount})");
                            })),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
        CommentList(
            category: widget.together.category(),
            postID: widget.together.postID),
      ],
    );
  }
}

Widget _buildJoin(BuildContext context) {
  double margin = MediaQuery.of(context).size.width / 6;
  return Container(
    margin: EdgeInsets.only(top: 28, left: margin, right: margin),
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: MainTheme.gradientStartColor,
          offset: Offset(1.0, 1.0),
          blurRadius: 4.0,
        ),
        BoxShadow(
          color: MainTheme.gradientEndColor,
          offset: Offset(1.0, 1.0),
          blurRadius: 4.0,
        ),
      ],
      gradient: MainTheme.buttonLinearGradient,
    ),
    child: MaterialButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.red,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
          child: Text(
            LocalizableLoader.of(context).text("together_join_button"),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        onPressed: () {
          _requestJoin(context);
        }),
  );
}

void _requestJoin(BuildContext context) {}

class _BackButton extends StatelessWidget {
  _BackButton(this.scrollEffects);
  final TogetherDetailScrollEffects scrollEffects;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 4.0,
      child: IgnorePointer(
        ignoring: scrollEffects.backButtonOpacity == 0.0,
        child: Material(
          type: MaterialType.circle,
          color: Colors.transparent,
          child: BackButton(
            color: Colors.white.withOpacity(
              scrollEffects.backButtonOpacity * 0.9,
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  _Header(this.together);
  final Together together;

  @override
  Widget build(BuildContext context) {
    final moviePoster = Padding(
      padding: const EdgeInsets.all(6.0),
      child: TogetherDetailPoster(
        together: together,
        size: const Size(125, 160),
        displayPlayButton: true,
      ),
    );

    return Stack(children: [
      // Transparent container that makes the space for the backdrop photo.
      Container(
        height: 225.0,
        margin: const EdgeInsets.only(bottom: 132.0),
      ),
      // Makes for the white background in poster and event information.
      Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Container(
          color: Colors.white,
          height: 132.0,
        ),
      ),
      Positioned(
        left: 10.0,
        bottom: 0.0,
        child: moviePoster,
      ),
      Positioned(
          top: 215.0,
          left: 146.0,
          right: 0,
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                flex: 1,
                child: FlatIconTextButton(
                    iconData: FontAwesomeIcons.eye,
                    color: MainTheme.contentsTextStyle.color,
                    text: sprintf("%d", [138]),
                    onPressed: () => {}),
              ),
              Expanded(
                flex: 2,
                child: FlatIconTextButton(
                    iconData: FontAwesomeIcons.clock,
                    color: MainTheme.contentsTextStyle.color,
                    text: timeago.format(together.lastUpdate.toDate(),
                        locale: 'ko'),
                    onPressed: () => {}),
              ),
            ]),
            TogetherInfo(together),
          ])),
    ]);
  }
}

class TogetherInfo extends StatelessWidget {
  TogetherInfo(this.together);
  final Together together;

  List<Widget> _buildTitleAndLengthInMinutes() {
    final length = "";
    final genres = "";

    return [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: FlatIconTextButton(
                  iconData: FontAwesomeIcons.idBadge,
                  color: MainTheme.contentsTextStyle.color,
                  text: together.profile.nickname,
                  onPressed: () => {}),
            ),
            Expanded(
              flex: 2,
              child: FlatIconTextButton(
                  iconData: FontAwesomeIcons.mobile,
                  color: MainTheme.contentsTextStyle.color,
                  text: together.profile.displayPhoneNumber(),
                  onPressed: () => {}),
            )
          ],
        ),
      ]),
      Padding(
        padding: EdgeInsets.only(left: 5, top: 5),
        child: Text(
          together.title,
          style: MainTheme.titleTextStyle,
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[]..addAll(
        _buildTitleAndLengthInMinutes(),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content,
    );
  }
}
