import 'package:before_sunrise/import.dart';
import 'package:before_sunrise/pages/together_details/together_detail_poster.dart';

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
    // TODO : Gallery
    // addIfNonNull(_buildGallery(), content);
    addIfNonNull(_buildJoin(context), content);

    // Some padding for the bottom.
    content.add(const SizedBox(height: 32.0));

    final slivers = CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(delegate: SliverChildListDelegate(content)),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Stack(
        children: [
          _buildEventBackdrop(),
          slivers,
          _BackButton(_scrollEffects),
          _buildStatusBarBackground(),
        ],
      ),
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
          top: 218.0,
          left: 146.0,
          right: 0,
          child: Column(children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatIconTextButton(
                      iconData: Icons.visibility,
                      color: Colors.black54,
                      width: 70,
                      text: sprintf("%d", [138]),
                      onPressed: () => {}),
                  FlatIconTextButton(
                      iconData: Icons.thumb_up,
                      color: MainTheme.enabledButtonColor,
                      width: 70,
                      text: sprintf("%d", [138]),
                      onPressed: () => {}),
                  FlatIconTextButton(
                      iconData: Icons.message,
                      color: MainTheme.enabledButtonColor,
                      width: 70,
                      text: sprintf("%d", [12118]),
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {},
                                ))
                          }),
                ]),
            Padding(
                padding: EdgeInsets.only(left: 5),
                child: TogetherInfo(together)),
          ]))
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatIconTextButton(
                iconData: FontAwesomeIcons.userEdit,
                color: Colors.black54,
                width: 150,
                text: "작성자댕댕이이12",
                onPressed: () => {}),
            FlatIconTextButton(
                iconData: FontAwesomeIcons.clock,
                color: Colors.black54,
                width: 70,
                text: "1시간 ��",
                onPressed: () => {}),
          ],
        ),
      ]),
      Text(
        together.title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
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
