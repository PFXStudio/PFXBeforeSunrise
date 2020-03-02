import 'package:before_sunrise/import.dart';

class ClubInfoStepAddress extends StatefulWidget {
  @override
  _ClubInfoStepAddressState createState() => _ClubInfoStepAddressState();
}

class _ClubInfoStepAddressState extends State<ClubInfoStepAddress> {
  WebViewController _webViewController;
  String filePath = 'assets/files/kakao_address.html';

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: '',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
        _loadHtmlFromAssets();
      },
    );
  }

  _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
