import 'package:before_sunrise/import.dart';

class ThumbnailItem extends StatefulWidget {
  final ByteData data;

  /// The thumb width
  final int width;

  /// The thumb height
  final int height;

  /// The thumb quality
  final int quality;

  /// This is the widget that will be displayed while the
  /// thumb is loading.
  final Widget spinner;

  const ThumbnailItem({
    Key key,
    @required this.data,
    @required this.width,
    @required this.height,
    this.quality = 100,
    this.spinner = const Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(),
      ),
    ),
  }) : super(key: key);

  @override
  _ThumbnailItemState createState() => _ThumbnailItemState();
}

class _ThumbnailItemState extends State<ThumbnailItem> {
  ByteData _thumbData;

  int get width => widget.width;
  int get height => widget.height;
  int get quality => widget.quality;
  Widget get spinner => widget.spinner;

  @override
  void initState() {
    super.initState();
    this._loadThumb();
  }

  @override
  void didUpdateWidget(ThumbnailItem oldWidget) {
    if (oldWidget.data.hashCode != widget.data.hashCode) {
      this._loadThumb();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _loadThumb() async {
    setState(() {
      _thumbData = null;
    });

    if (this.mounted) {
      setState(() {
        _thumbData = widget.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbData == null) {
      return spinner;
    }
    return Image.memory(
      _thumbData.buffer.asUint8List(),
      key: ValueKey(widget.data.hashCode),
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
  }
}
