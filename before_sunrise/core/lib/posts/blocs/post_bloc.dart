import 'package:core/import.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  static final PostBloc _postBlocSingleton = new PostBloc._internal();
  factory PostBloc() {
    return _postBlocSingleton;
  }
  PostBloc._internal();

  PostState get initialState => new UnPostState();

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    try {
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield currentState;
    }
  }
}
