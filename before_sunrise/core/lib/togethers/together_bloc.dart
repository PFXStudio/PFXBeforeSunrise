import 'package:core/import.dart';

class TogetherBloc extends Bloc<TogetherEvent, TogetherState> {
  static final TogetherBloc _postBlocSingleton = new TogetherBloc._internal();
  factory TogetherBloc() {
    return _postBlocSingleton;
  }
  TogetherBloc._internal();

  TogetherState get initialState => new UnTogetherState();

  @override
  Stream<TogetherState> mapEventToState(
    TogetherEvent event,
  ) async* {
    try {
      yield FetchingTogetherState();
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield currentState;
    }
  }
}
