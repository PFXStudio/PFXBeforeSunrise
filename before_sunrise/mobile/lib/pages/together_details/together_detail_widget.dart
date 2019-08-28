import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/pages/together_details/together_detail_poster.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:latlong/latlong.dart';

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
    addIfNonNull(_buildJoin(context), content);

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
      body: Stack(
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
      floatingActionButton: FloatingActionButton(
        onPressed: touchedButton,
        tooltip: 'Increment',
        child: const Icon(FontAwesomeIcons.signInAlt),
      ),
    );
  }

  void touchedButton() {}

  Widget _body() {
    return Container();
  }

  Widget _panel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          height: 18.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Comments",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 24.0,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 36.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _button("Popular", Icons.favorite, Colors.blue),
            _button("Food", Icons.restaurant, Colors.red),
            _button("Events", Icons.event, Colors.amber),
            _button("More", Icons.more_horiz, Colors.green),
          ],
        ),
        SizedBox(
          height: 36.0,
        ),
        Container(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Images",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(
                height: 12.0,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 36.0,
        ),
        Container(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("About",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(
                height: 12.0,
              ),
              Text(
                "Pittsburgh is a city in the Commonwealth of Pennsylvania "
                "in the United States, and is the county seat of Allegheny County. "
                "As of 2017, a population of 305,704 lives within the city limits, "
                "making it the 63rd-largest city in the U.S. The metropolitan population "
                "of 2,353,045 is the largest in both the Ohio Valley and Appalachia, "
                "the second-largest in Pennsylvania (behind Philadelphia), "
                "and the 26th-largest in the U.S.  Pittsburgh is located in the "
                "south west of the state, at the confluence of the Allegheny, "
                "Monongahela, and Ohio rivers, Pittsburgh is known both as 'the Steel City' "
                "for its more than 300 steel-related businesses and as the 'City of Bridges' "
                "for its 446 bridges. The city features 30 skyscrapers, two inclined railways, "
                "a pre-revolutionary fortification and the Point State Park at the "
                "confluence of the rivers. The city developed as a vital link of "
                "the Atlantic coast and Midwest, as the mineral-rich Allegheny "
                "Mountains made the area coveted by the French and British "
                "empires, Virginians, Whiskey Rebels, and Civil War raiders. ",
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _button(String label, IconData icon, Color color) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: Colors.white,
          ),
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 8.0,
            )
          ]),
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(label),
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
        size: const Size(125.0, 187.5),
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
          top: 200.0,
          left: 146.0,
          right: 0,
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.clock,
                  color: Colors.black54,
                  size: 16,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                Text(
                  timeago.format(together.lastUpdate.toDate(), locale: 'ko'),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: FlatIconTextButton(
                        iconData: Icons.visibility,
                        color: Colors.black54,
                        text: sprintf("%d", [138]),
                        onPressed: () => {}),
                  ),
                  Expanded(
                    flex: 1,
                    child: FlatIconTextButton(
                        iconData: Icons.message,
                        color: MainTheme.enabledButtonColor,
                        text: sprintf("%d", [121]),
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {},
                                  ))
                            }),
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
            FlatIconTextButton(
                iconData: FontAwesomeIcons.idBadge,
                color: Colors.black54,
                text: together.profile.nickname,
                onPressed: () => {}),
          ],
        ),
      ]),
      Padding(
        padding: EdgeInsets.only(left: 5, top: 5),
        child: Text(
          together.title,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
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

class _DirectorInfo extends StatelessWidget {
  _DirectorInfo(this.director);
  final String director;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "director",
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4.0),
        Expanded(
          child: Text(
            director,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
