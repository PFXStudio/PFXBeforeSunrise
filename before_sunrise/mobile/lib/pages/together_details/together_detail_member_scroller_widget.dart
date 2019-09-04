import 'package:before_sunrise/import.dart';

class TogetherDetailMemberScrollerWidget extends StatelessWidget {
  const TogetherDetailMemberScrollerWidget(this.together);
  final Together together;

  @override
  Widget build(BuildContext context) {
    return TogetherDetailMemberScrollerWidgetContent(together.memberProfiles);
  }
}

class TogetherDetailMemberScrollerWidgetContent extends StatelessWidget {
  const TogetherDetailMemberScrollerWidgetContent(this.profiles);
  final List<Profile> profiles;

  @override
  Widget build(BuildContext context) {
    return _TogetherDetailMemberScrollerWidgetWrapper(
      ListView.builder(
        padding: const EdgeInsets.only(left: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: profiles.length,
        itemBuilder: (_, int index) {
          final profile = profiles[index];
          return _ProfileListItem(profile);
        },
      ),
    );
  }
}

class _TogetherDetailMemberScrollerWidgetWrapper extends StatelessWidget {
  _TogetherDetailMemberScrollerWidgetWrapper(this.child);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const decoration = BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          offset: Offset(0.0, -2.0),
          spreadRadius: 2.0,
          blurRadius: 30.0,
          color: Colors.black12,
        ),
      ],
    );

    final title = Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        "cast",
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    return Container(
      decoration: decoration,
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          title,
          const SizedBox(height: 16.0),
          SizedBox(
            height: 110.0,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ProfileListItem extends StatelessWidget {
  _ProfileListItem(this.profile);
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.0,
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          _ProfileAvatar(profile),
          const SizedBox(height: 8.0),
          Text(
            profile.nickname,
            style: const TextStyle(fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  _ProfileAvatar(this.profile);
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[
      const Icon(
        FontAwesomeIcons.userFriends,
        color: Colors.white,
        size: 26.0,
      ),
    ];

    if (profile.imageUrl != null) {
      content.add(ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: DefineImages.icon_main_256_path,
          image: profile.imageUrl,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 250),
        ),
      ));
    }

    return Container(
      width: 56.0,
      height: 56.0,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: content,
      ),
    );
  }
}
