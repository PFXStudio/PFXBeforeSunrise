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

  final String userID;

  @override
  Future<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc}) async {
    try {
      await _profileProvider.hasProfile(userID: userID);
      return new InProfileState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorProfileState(_?.toString());
    }
  }
}

class UpdateProfileEvent extends ProfileEvent {
  UpdateProfileEvent({@required this.profile});
  @override
  String toString() => 'UpdateProfileEvent';
  final IProfileProvider _profileProvider = ProfileProvider();

  final Profile profile;

  @override
  Future<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc}) async {
    try {
      await _profileProvider.updateProfile(
          userID: profile.userID, data: profile.data());
      return new InProfileState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorProfileState(_?.toString());
    }
  }
}

class DeleteProfileEvent extends ProfileEvent {
  DeleteProfileEvent({@required this.userID});
  @override
  String toString() => 'DeleteProfileEvent';
  final IProfileProvider _profileProvider = ProfileProvider();

  final String userID;

  @override
  Future<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc}) async {
    try {
      await _profileProvider.removeProfile(userID: userID);
      return new UnProfileState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorProfileState(_?.toString());
    }
  }
}
