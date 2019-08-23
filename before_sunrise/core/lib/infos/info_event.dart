import 'package:core/import.dart';

@immutable
abstract class InfoEvent {
  Future<InfoState> applyAsync({InfoState currentState, InfoBloc bloc});
  // final InfoRepository _infoRepository = new InfoRepository();
}

class LoadInfoEvent extends InfoEvent {
  @override
  String toString() => 'LoadInfoEvent';

  @override
  Future<InfoState> applyAsync({InfoState currentState, InfoBloc bloc}) async {
    try {
      await Future.delayed(new Duration(seconds: 2));
      // this._infoRepository.test();
      return new InInfoState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorInfoState(_?.toString());
    }
  }
}
