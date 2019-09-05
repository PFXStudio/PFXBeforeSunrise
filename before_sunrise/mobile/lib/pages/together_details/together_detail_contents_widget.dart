import 'package:before_sunrise/import.dart';

class TogetherDetailContentsWidget extends StatefulWidget {
  TogetherDetailContentsWidget(this.together);
  final Together together;

  @override
  _TogetherDetailContentsWidgetState createState() =>
      _TogetherDetailContentsWidgetState();
}

class _TogetherDetailContentsWidgetState
    extends State<TogetherDetailContentsWidget> {
  bool _isExpandable;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpandable = true;
  }

  void _toggleExpandedState() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedCrossFade(
      firstChild: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Text(widget.together.synopsisText(),
            style: MainTheme.contentsTextStyle),
      ),
      secondChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatIconTextButton(
                          iconData: FontAwesomeIcons.calendar,
                          color: MainTheme.contentsTextStyle.color,
                          text: _isExpanded == false
                              ? ""
                              : widget.together.dateText(),
                          onPressed: () => {}),
                      FlatIconTextButton(
                          iconData: FontAwesomeIcons.mapMarkerAlt,
                          color: MainTheme.contentsTextStyle.color,
                          text: _isExpanded == false
                              ? ""
                              : widget.together.clubID,
                          onPressed: () => {}),
                      FlatIconTextButton(
                          iconData: FontAwesomeIcons.wonSign,
                          color: MainTheme.contentsTextStyle.color,
                          text: _isExpanded == false
                              ? ""
                              : widget.together.priceText(),
                          onPressed: () => {}),
                    ],
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FlatIconTextButton(
                            iconData: FontAwesomeIcons.users,
                            color: MainTheme.contentsTextStyle.color,
                            text: _isExpanded == false
                                ? ""
                                : widget.together.countText(),
                            onPressed: () => {}),
                        FlatIconTextButton(
                            iconData: FontAwesomeIcons.cocktail,
                            color: MainTheme.contentsTextStyle.color,
                            text: _isExpanded == false
                                ? ""
                                : widget.together.cocktailText(),
                            onPressed: () => {}),
                        FlatIconTextButton(
                            iconData: FontAwesomeIcons.moneyBillWave,
                            color: MainTheme.contentsTextStyle.color,
                            text: _isExpanded == false
                                ? ""
                                : widget.together.douchPriceText(),
                            onPressed: () => {}),
                      ],
                    )),
              ],
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  widget.together.contents,
                  style: MainTheme.contentsTextStyle,
                )),
          ]),
      crossFadeState:
          _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: kThemeAnimationDuration,
    );

    return InkWell(
      onTap: _isExpandable ? _toggleExpandedState : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Title(_isExpandable, _isExpanded),
            const SizedBox(height: 8.0),
            content,
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  _Title(this.expandable, this.expanded);
  final bool expandable;
  final bool expanded;

  Widget _buildExpandCollapsePrompt(String contents) {
    const captionStyle = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
      color: MainTheme.enabledButtonColor,
    );

    return Text(
      expanded ? contents : contents,
      style: captionStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[
      Text(
        LocalizableLoader.of(context).text("board_contents_text"),
        style: MainTheme.subTitleTextStyle,
      ),
    ];

    if (expandable) {
      content.add(Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: _buildExpandCollapsePrompt(
            LocalizableLoader.of(context).text("board_contents_more_text")),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: content,
    );
  }
}
