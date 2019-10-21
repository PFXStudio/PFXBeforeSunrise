import 'package:before_sunrise/import.dart';

class TextFocusCreator {
  final TextEditingController _textEditingController =
      new TextEditingController();
  FocusNode _focusNode = new FocusNode();

  TextEditingController get textEditingController => _textEditingController;
  FocusNode get focusNode => _focusNode;
}
