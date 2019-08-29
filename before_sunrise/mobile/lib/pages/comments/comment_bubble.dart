import 'package:before_sunrise/import.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentBubble extends StatefulWidget {
  CommentBubble({
    @required this.comment,
  });

  Comment comment;

  @override
  _CommentBubbleState createState() => _CommentBubbleState();
}

class _CommentBubbleState extends State<CommentBubble> {
  Comment get _comment => widget.comment;
  List colors = Colors.primaries;

  @override
  Widget build(BuildContext context) {
    final bg = _comment.isMine ? MainTheme.bgndColor : Colors.grey[200];
    final align =
        _comment.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = _comment.isMine
        ? BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: radius,
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.3,
            minWidth: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _comment.isMine
                  ? SizedBox()
                  : true
                      ? Padding(
                          padding: EdgeInsets.only(right: 48.0),
                          child: Container(
                            child: Text(
                              "Group!!",
                              style: TextStyle(
                                fontSize: 13,
                                color: MainTheme.liteBgndColor,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        )
                      : SizedBox(),
              true
                  ? _comment.isMine ? SizedBox() : SizedBox(height: 5)
                  : SizedBox(),
              _comment.parentCommentID != null
                  ? Container(
                      decoration: BoxDecoration(
                        color: !_comment.isMine
                            ? Colors.grey[50]
                            : Colors.blue[50],
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      constraints: BoxConstraints(
                        minHeight: 25,
                        maxHeight: 100,
                        minWidth: 80,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              child: Text(
                                _comment.isMine
                                    ? _comment.profile.nickname
                                    : _comment.parentProfile.nickname,
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.left,
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            SizedBox(height: 2),
                            Container(
                              child: Text(
                                _comment.text,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                                maxLines: 2,
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(width: 2),
              _comment.parentCommentID != null
                  ? SizedBox(height: 5)
                  : SizedBox(),
              Padding(
                padding: EdgeInsets.all(
                    (_comment.text != null && _comment.text.length > 0)
                        ? 5
                        : 0),
                child: (_comment.text != null && _comment.text.length > 0)
                    ? _comment.parentCommentID == null
                        ? Text(
                            _comment.text,
                            style: TextStyle(
                              color:
                                  _comment.isMine ? Colors.white : Colors.black,
                            ),
                          )
                        : Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _comment.parentText,
                              style: TextStyle(
                                color: _comment.isMine
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          )
                    : Image.asset(
                        "${_comment.imageUrls.first}",
                        height: 130,
                        width: MediaQuery.of(context).size.width / 1.3,
                        fit: BoxFit.cover,
                      ),
              ),
            ],
          ),
        ),
        Padding(
          padding: _comment.isMine
              ? EdgeInsets.only(
                  right: 10,
                  bottom: 10.0,
                )
              : EdgeInsets.only(
                  left: 10,
                  bottom: 10.0,
                ),
          child: Text(
            timeago.format(_comment.lastUpdate.toDate(), locale: 'ko'),
            style: TextStyle(
              color: Colors.black,
              fontSize: 10.0,
            ),
          ),
        ),
      ],
    );
  }
}
