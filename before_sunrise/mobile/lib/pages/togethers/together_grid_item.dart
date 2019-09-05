import 'package:before_sunrise/import.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TogetherGridItem extends StatelessWidget {
  TogetherGridItem({
    @required this.together,
    @required this.onTapped,
  });

  final Together together;
  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Stack(
        fit: StackFit.expand,
        children: [
          TogetherPoster(together: together),
          _TextualInfo(together),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTapped,
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextualInfo extends StatelessWidget {
  _TextualInfo(this.together);
  final Together together;

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [0.0, 0.4, 0.6, 1],
        colors: [
          Colors.black54,
          Colors.transparent,
          Colors.transparent,
          Colors.black54,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildGradientBackground(),
      padding: const EdgeInsets.all(16),
      child: _TextualInfoContent(together),
    );
  }
}

class _TextualInfoContent extends StatelessWidget {
  _TextualInfoContent(this.together);
  final Together together;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              timeago.format(together.lastUpdate.toDate(), locale: 'ko'),
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: 40.0,
                    child: together.profile.imageUrl != null &&
                            together.profile.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: '${together.profile.imageUrl}',
                            placeholder: (context, imageUrl) => Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.0)),
                            errorWidget: (context, imageUrl, error) => Center(
                                child:
                                    Icon(FontAwesomeIcons.exclamationCircle)),
                            imageBuilder:
                                (BuildContext context, ImageProvider image) {
                              return Hero(
                                tag:
                                    '${together.postID}_${together.profile.imageUrl}',
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: image, fit: BoxFit.cover),
                                  ),
                                ),
                              );
                            },
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white54, width: 1.0),
                                  image: DecorationImage(
                                      image: ExactAssetImage(
                                          'assets/avatars/avatar.png'),
                                      fit: BoxFit.fill),
                                )),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Text(
                    together.profile.nickname,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      together.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      together.synopsisItemText(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ],
    );
  }
}
