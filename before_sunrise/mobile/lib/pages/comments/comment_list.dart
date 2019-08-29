import 'package:before_sunrise/import.dart';

Random random = Random();
List names = [
  "Ling Waldner",
  "Gricelda Barrera",
  "Lenard Milton",
  "Bryant Marley",
  "Rosalva Sadberry",
  "Guadalupe Ratledge",
  "Brandy Gazda",
  "Kurt Toms",
  "Rosario Gathright",
  "Kim Delph",
  "Stacy Christensen",
];

List messages = [
  "Hey, how are you doing?",
  "Are you available tomorrow?",
  "It's late. Go to bed!",
  "This cracked me up 😂😂",
  "Flutter Rocks!!!",
  "The last rocket🚀",
  "Griezmann signed for Barca❤️❤️",
  "Will you be attending the meetup tomorrow?",
  "Are you angry at something?",
  "Let's make a UI serie.",
  "Can i hear your voice?",
];

List notifs = [
  "${names[random.nextInt(10)]} and ${random.nextInt(100)} others liked your post",
  "${names[random.nextInt(10)]} mentioned you in a comment",
  "${names[random.nextInt(10)]} shared your post",
  "${names[random.nextInt(10)]} commented on your post",
  "${names[random.nextInt(10)]} replied to your comment",
  "${names[random.nextInt(10)]} reacted to your comment",
  "${names[random.nextInt(10)]} asked you to join a Group️",
  "${names[random.nextInt(10)]} asked you to like a page",
  "You have memories with ${names[random.nextInt(10)]}",
  "${names[random.nextInt(10)]} Tagged you and ${random.nextInt(100)} others in a post",
  "${names[random.nextInt(10)]} Sent you a friend request",
];

List notifications = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/images/cm${random.nextInt(10)}.jpeg",
          "time": "${random.nextInt(50)} min ago",
          "notif": notifs[random.nextInt(10)]
        });

List posts = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/images/images/cm${random.nextInt(10)}.jpeg",
          "time": "${random.nextInt(50)} min ago",
          "img": "assets/images/cm${random.nextInt(10)}.jpeg"
        });

List chats = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/images/cm${random.nextInt(10)}.jpeg",
          "msg": messages[random.nextInt(10)],
          "counter": random.nextInt(20),
          "time": "${random.nextInt(50)} min ago",
          "isOnline": random.nextBool(),
        });

List groups = List.generate(
    13,
    (index) => {
          "name": "Group ${random.nextInt(20)}",
          "dp": "assets/images/cm${random.nextInt(10)}.jpeg",
          "msg": messages[random.nextInt(10)],
          "counter": random.nextInt(20),
          "time": "${random.nextInt(50)} min ago",
          "isOnline": random.nextBool(),
        });

List types = ["text", "image"];
List conversation = List.generate(
    10,
    (index) => {
          "username": "Group ${random.nextInt(20)}",
          "time": "${random.nextInt(50)} min ago",
          "type": types[random.nextInt(2)],
          "replyText": messages[random.nextInt(10)],
          "isMe": random.nextBool(),
          "isGroup": false,
          "isReply": random.nextBool(),
        });

List friends = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/images/cm${random.nextInt(10)}.jpeg",
          "status": "Anything could be here",
          "isAccept": random.nextBool(),
        });

class CommentList extends StatefulWidget {
  CommentList({this.comment});
  @override
  _CommentListState createState() => _CommentListState();
  Comment comment;
}

class _CommentListState extends State<CommentList> {
  Comment get _comment => widget.comment;
  @override
  void initState() {
    super.initState();
    this._commentBloc.dispatch(LoadCommentEvent(comment: _comment));
  }

  final TextEditingController _textController = TextEditingController();
  static Random random = Random();
  String name = names[random.nextInt(10)];
  ByteData _selectedThumbData;
  ByteData _selectedOriginalData;
  final _commentBloc = CommentBloc();

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Container(
      height: MediaQuery.of(context).size.height -
          (MediaQuery.of(context).size.height - 500),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Flexible(
            child: BlocListener(
                bloc: _commentBloc,
                listener: (context, state) async {},
                child: BlocBuilder<CommentBloc, CommentState>(
                    bloc: _commentBloc,
                    builder: (
                      BuildContext context,
                      CommentState currentState,
                    ) {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        itemCount: conversation.length,
                        reverse: true,
                        itemBuilder: (BuildContext context, int index) {
                          Map msg = conversation[index];
                          return CommentBubble(
                            message: msg['type'] == "text"
                                ? messages[random.nextInt(10)]
                                : "assets/images/cm${random.nextInt(10)}.jpeg",
                            username: msg["username"],
                            time: msg["time"],
                            type: msg['type'],
                            replyText: msg["replyText"],
                            isMe: msg['isMe'],
                            isGroup: msg['isGroup'],
                            isReply: msg['isReply'],
                            replyName: name,
                          );
                        },
                      );
                    })),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
//                height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[900],
                    offset: Offset(0.0, 1.5),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              constraints: BoxConstraints(
                maxHeight: 190,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Flexible(
                  //   child:
                  _selectedThumbData == null
                      ? ListTile(
                          leading: IconButton(
                            icon: Icon(
                              Icons.photo,
                              color: MainTheme.enabledButtonColor,
                            ),
                            onPressed: () {
                              _loadAssets();
                            },
                          ),
                          contentPadding: EdgeInsets.all(0),
                          title: TextField(
                            controller: _textController,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Theme.of(context).textTheme.title.color,
                            ),
                            decoration: InputDecoration(
                              focusColor: Colors.black,
                              fillColor: Colors.black,
                              hoverColor: Colors.black,
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: LocalizableLoader.of(context)
                                  .text("comment_hint_text"),
                            ),
                            maxLines: null,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: MainTheme.enabledButtonColor,
                            ),
                            onPressed: () {
                              _touchedSendButton();
                            },
                          ),
                        )
                      : _buildGridView(context),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
      );

      if (resultList == null) {
        return;
      }

      if (resultList.length <= 0) {
        return;
      }

      for (Asset asset in resultList) {
        ByteData data = await asset.getThumbByteData(
          100,
          100,
          quality: 50,
        );
        _selectedThumbData = data;

        ByteData originalData = await asset.getByteData();
        _selectedOriginalData = originalData;
        setState(() {});
        break;
      }
    } catch (e) {
      error = e.message;
      print(e.message);
    }

    if (!mounted) return;
  }

  Widget _buildGridView(BuildContext context) {
    if (_selectedThumbData == null) {
      return Container();
    }

    return ListTile(
      contentPadding: EdgeInsets.all(10),
      title: Stack(children: <Widget>[
        ThumbnailItem(
          data: _selectedThumbData,
          width: 50,
          height: 50,
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
              _selectedThumbData = null;
              _selectedOriginalData = null;
              setState(() {});
              print("deleted");
            },
          ),
        ),
      ]),
      trailing: IconButton(
        icon: Icon(
          Icons.send,
          color: MainTheme.enabledButtonColor,
        ),
        onPressed: () {
          _touchedSendImageButton();
        },
      ),
    );
  }

  void _touchedSendButton() {
    if (_textController.text.length <= 0) {
      FailSnackbar().show("E41122", null);
      return;
    }
  }

  void _touchedSendImageButton() {
    if (_selectedOriginalData == null) {
      FailSnackbar().show("E41123", null);
      return;
    }
  }
}
