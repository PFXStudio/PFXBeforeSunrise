import 'package:core/import.dart';

@immutable
abstract class ClubInfoEvent {
  Future<ClubInfoState> applyAsync(
      {ClubInfoState currentState, ClubInfoBloc bloc});
  // final ClubInfoRepository _infoRepository = new ClubInfoRepository();
}

class LoadClubInfoEvent extends ClubInfoEvent {
  @override
  String toString() => 'LoadClubInfoEvent';

  @override
  Future<ClubInfoState> applyAsync(
      {ClubInfoState currentState, ClubInfoBloc bloc}) async {
    try {
      await Future.delayed(new Duration(seconds: 2));
      // this._infoRepository.test();
      return new InClubInfoState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorClubInfoState(_?.toString());
    }
  }
}
