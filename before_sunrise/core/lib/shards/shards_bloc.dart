import 'package:core/import.dart';

class ShardsBloc extends Bloc<ShardsEvent, ShardsState> {
  static final ShardsBloc _postBlocSingleton = new ShardsBloc._internal();
  factory ShardsBloc() {
    return _postBlocSingleton;
  }
  ShardsBloc._internal();

  ShardsState get initialState => new UnShardsState();

  @override
  Stream<ShardsState> mapEventToState(
    ShardsEvent event,
  ) async* {
    try {
      yield UnShardsState();
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield currentState;
    }
  }
}
