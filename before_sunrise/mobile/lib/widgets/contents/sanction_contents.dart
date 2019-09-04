import 'package:before_sunrise/import.dart';

class SanctionContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '건전한 커뮤니티를 위한 제재 안내',
          style: MainTheme.subTitleTextStyle,
        ),
        Divider(),
        Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.times, size: 15.0, color: Colors.red),
            SizedBox(width: 5.0),
            Expanded(
                child: Text(
              '과도한 욕설, 비속어 및 저속한 언어를 사용하여 불쾌감을 주는 내용',
              style: MainTheme.contentsTextStyle,
            )),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.times, size: 15.0, color: Colors.red),
            SizedBox(width: 5.0),
            Text(
              '허위 내용을 사실인 것처럼 표현하는 내용',
              style: MainTheme.contentsTextStyle,
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.times, size: 15.0, color: Colors.red),
            SizedBox(width: 5.0),
            Expanded(
              child: Text(
                '과도한 신체의 노출이나 성적 수치심을 불러 일으킬 수 있는 내용',
                style: MainTheme.contentsTextStyle,
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
