import 'package:core/import.dart';

@immutable
abstract class ProfileEvent {
  Future<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc});
  final ProfileRepository _profileRepository = new ProfileRepository();
}

class LoadProfileEvent extends ProfileEvent {
  LoadProfileEvent({@required this.userID});
  @override
  String toString() => 'LoadProfileEvent';
  final IProfileProvider _profileProvider = ProfileProvider();

  String userID;

  @override
  Future<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc}) async {
    try {
      await _profileProvider.hasProfile(userID: user)
      return new InProfileState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorProfileState(_?.toString());
    }
  }
}
