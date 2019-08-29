import 'package:core/import.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  static final CommentBloc _postBlocSingleton = new CommentBloc._internal();
  factory CommentBloc() {
    return _postBlocSingleton;
  }
  CommentBloc._internal();

  CommentState get initialState => new UnCommentState();

  @override
  Stream<CommentState> mapEventToState(
    CommentEvent event,
  ) async* {
    try {
      yield FetchingCommentState();
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield currentState;
    }
  }
}
