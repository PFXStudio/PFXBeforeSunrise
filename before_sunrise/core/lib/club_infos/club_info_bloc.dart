import 'package:core/import.dart';

class ClubInfoBloc extends Bloc<ClubInfoEvent, ClubInfoState> {
  static final ClubInfoBloc _postBlocSingleton = new ClubInfoBloc._internal();
  factory ClubInfoBloc() {
    return _postBlocSingleton;
  }
  ClubInfoBloc._internal();

  ClubInfoState get initialState => new UnClubInfoState();

  @override
  Stream<ClubInfoState> mapEventToState(
    ClubInfoEvent event,
  ) async* {
    try {
      yield FetchingClubInfoState();
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield currentState;
    }
  }
}
