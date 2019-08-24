import 'package:core/import.dart';
import 'package:core/my_posts/my_post_state.dart';

class MyPostBloc extends Bloc<MyPostEvent, MyPostState> {
  static final MyPostBloc _postBlocSingleton = new MyPostBloc._internal();
  factory MyPostBloc() {
    return _postBlocSingleton;
  }
  MyPostBloc._internal();

  MyPostState get initialState => new UnMyPostState();

  @override
  Stream<MyPostState> mapEventToState(
    MyPostEvent event,
  ) async* {
    try {
      yield FetchingMyPostState();
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield currentState;
    }
  }
}
