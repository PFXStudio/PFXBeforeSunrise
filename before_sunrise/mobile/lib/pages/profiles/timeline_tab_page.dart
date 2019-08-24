import 'package:before_sunrise/import.dart';

class TimelineTabPage extends StatelessWidget {
  final List<Post> posts;
  final bool enabeldMorePosts;

  const TimelineTabPage(
      {Key key, @required this.posts, @required this.enabeldMorePosts})
      : super(key: key);

  Widget _buildSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return index >= posts.length
              ? BottomLoader()
              : PostItemCardDefault(post: posts[index], isProfilePost: true);
        },
        childCount: posts.length + (enabeldMorePosts == true ? 1 : 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSliverList();
  }
}
