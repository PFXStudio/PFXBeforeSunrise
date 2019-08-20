import 'package:before_sunrise/import.dart';

@immutable
abstract class HomeEvent {
  Future<HomeState> applyAsync({HomeState currentState, HomeBloc bloc});
}

class LoadTabEvent extends HomeEvent {
  LoadTabEvent({this.index});
  @override
  String toString() => 'LoadTabEvent';
  final int index;

  @override
  Future<HomeState> applyAsync({HomeState currentState, HomeBloc bloc}) async {
    try {
      if (this.index == 0) {
        return PostTabState();
      }

      if (this.index == 1) {
        return ProfileTabState();
      }

      return new InHomeState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorHomeState(_?.toString());
    }
  }
}
