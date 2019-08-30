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
    final isReply =
        _comment.parentCommentID != null && _comment.parentCommentID.length > 0
            ? true
            : false;

    if (_comment.isMine == true && isReply == true) {
      return _buildMyReplyComment(context);
    }

    if (_comment.isMine == true) {
      return _buildMyComment(context);
    }

    if (isReply == true) {
      return _buildYourReplyComment(context);
    }

    return _buildYourComment(context);
  }

  Widget _buildProfile(BuildContext context) {
    Profile profile = _comment.profile;
    if (profile == null) {
      return SizedBox();
    }

    return ListTile(
      leading: Container(
        height: 30.0,
        width: 30.0,
        child: profile.imageUrl != null && profile.imageUrl.length > 0
            ? CachedNetworkImage(
                imageUrl: '${profile.imageUrl}',
                placeholder: (context, imageUrl) =>
                    Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                errorWidget: (context, imageUrl, error) =>
                    Center(child: Icon(Icons.error)),
                imageBuilder: (BuildContext context, ImageProvider image) {
                  return Hero(
                    tag: '${_comment.commentID}_${profile.imageUrl}',
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: image, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12, width: 1.0),
                      image: DecorationImage(
                          image: ExactAssetImage('assets/avatars/avatar.png'),
                          fit: BoxFit.fill),
                    )),
              ),
      ),
      title: Text('${profile.nickname}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildParentComment(BuildContext context) {
    if (_comment.parentCommentID == null ||
        _comment.parentCommentID.length <= 0) {
      return SizedBox();
    }

    return Container(
      decoration: BoxDecoration(
        color: _comment.isMine == false ? Colors.grey[50] : Colors.blue[50],
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      constraints: BoxConstraints(
        minHeight: 25,
        maxHeight: 157,
        minWidth: 80,
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Text(
                _comment.parentProfile.nickname,
                style: TextStyle(
                  color: MainTheme.enabledButtonColor,
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
              child: _comment.parentImageUrls != null &&
                      _comment.parentImageUrls.length > 0
                  ? _buildImage(context, _comment.parentImageUrls.first)
                  : Text(
                      _comment.parentText,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                    ),
              alignment: Alignment.centerLeft,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, String imageUrl) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute<void>(builder: (BuildContext context) {
            return ImageDetailScreen(
                '${_comment.commentID}_$imageUrl', imageUrl);
          }));
        },
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, imageUrl) =>
              Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
          errorWidget: (context, imageUrl, error) =>
              Center(child: Icon(Icons.error)),
          imageBuilder: (BuildContext context, ImageProvider image) {
            return Hero(
              tag: '${_comment.commentID}_$imageUrl',
              child: Container(
                height: 130,
                width: MediaQuery.of(context).size.width / 1.3,
                decoration: BoxDecoration(
                  image: DecorationImage(image: image, fit: BoxFit.cover),
                ),
              ),
            );
          },
        ));
  }

  Widget _buildTimeage(BuildContext context) {
    return Padding(
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
    );
  }

  Widget _buildMyComment(BuildContext context) {
    final radius = BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(10.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: MainTheme.bgndColor,
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
              // _comment.isMine == false ? _buildProfile(context) : SizedBox(),
              SizedBox(width: 2),
              SizedBox(),
              Padding(
                padding: EdgeInsets.all(
                    (_comment.text != null && _comment.text.length > 0)
                        ? 5
                        : 0),
                child: (_comment.text != null && _comment.text.length > 0)
                    ? Text(
                        _comment.text,
                        style: TextStyle(color: Colors.white),
                      )
                    : _buildImage(context, _comment.imageUrls.first),
              ),
            ],
          ),
        ),
        _buildTimeage(context),
      ],
    );
  }

  Widget _buildMyReplyComment(BuildContext context) {
    final radius = BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(10.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: MainTheme.bgndColor,
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
              // _comment.isMine == false ? _buildProfile(context) : SizedBox(),
              _buildParentComment(context),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.all(
                    (_comment.text != null && _comment.text.length > 0)
                        ? 5
                        : 0),
                child: (_comment.text != null && _comment.text.length > 0)
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _comment.text,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : _buildImage(context, _comment.imageUrls.first),
              ),
            ],
          ),
        ),
        _buildTimeage(context),
      ],
    );
  }

  Widget _buildYourReplyComment(BuildContext context) {
    final radius = BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
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
              // _comment.isMine == false ? _buildProfile(context) : SizedBox(),
              _buildProfile(context),
              _buildParentComment(context),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.all(
                    (_comment.text != null && _comment.text.length > 0)
                        ? 5
                        : 0),
                child: (_comment.text != null && _comment.text.length > 0)
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _comment.text,
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : _buildImage(context, _comment.imageUrls.first),
              ),
            ],
          ),
        ),
        _buildTimeage(context),
      ],
    );
  }

  Widget _buildYourComment(BuildContext context) {
    final radius = BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
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
              _buildProfile(context),
              Padding(
                padding: EdgeInsets.all(
                    (_comment.text != null && _comment.text.length > 0)
                        ? 5
                        : 0),
                child: (_comment.text != null && _comment.text.length > 0)
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _comment.text,
                          style: TextStyle(color: Colors.black),
                        ))
                    : _buildImage(context, _comment.imageUrls.first),
              ),
            ],
          ),
        ),
        _buildTimeage(context),
      ],
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final String tag;
  final String imageUrl;

  ImageDetailScreen(this.tag, this.imageUrl); // 생성자를 통해 imageUrl 을 전달받음

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Center(
          child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, imageUrl) =>
            Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
        errorWidget: (context, imageUrl, error) =>
            Center(child: Icon(Icons.error)),
        imageBuilder: (BuildContext context, ImageProvider image) {
          return Hero(
            tag: tag,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: image, fit: BoxFit.fitWidth),
              ),
            ),
          );
        },
      )),
    ));
  }
}
