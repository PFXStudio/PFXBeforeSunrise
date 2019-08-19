import 'package:core/import.dart';

@immutable
abstract class ProfileEvent {
  Future<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc});
  final ProfileRepository _profileRepository = new ProfileRepository();
}

class LoadProfileEvent extends ProfileEvent {
  @override
  String toString() => 'LoadProfileEvent';

  @override
  Future<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc}) async {
    try {
      await Future.delayed(new Duration(seconds: 2));
      return new InProfileState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorProfileState(_?.toString());
    }
  }
}
