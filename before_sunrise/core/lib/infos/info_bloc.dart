import 'package:core/import.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  static final InfoBloc _infoBlocSingleton = new InfoBloc._internal();
  factory InfoBloc() {
    return _infoBlocSingleton;
  }
  InfoBloc._internal();

  InfoState get initialState => new UnInfoState();

  @override
  Stream<InfoState> mapEventToState(
    InfoEvent event,
  ) async* {
    try {
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield currentState;
    }
  }
}
