import 'package:core/import.dart';

@immutable
abstract class ProfileEvent {
  Future<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc});
  final IProfileProvider _profileProvider = ProfileProvider();
}

class LoadProfileEvent extends ProfileEvent {
  LoadProfileEvent({@required this.userID});
  @override
  String toString() => 'LoadProfileEvent';

  final String userID;

  @override
  Future<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc}) async {
    try {
      DocumentSnapshot snapshot =
          await _profileProvider.hasProfile(userID: userID);
      if (snapshot == null) {
        return UnProfileState();
      }

      Profile profile = Profile();
      profile.initialize(snapshot);
      return new InProfileState(profile: profile);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new UnProfileState();
    }
  }
}

class UpdateProfileEvent extends ProfileEvent {
  UpdateProfileEvent({@required this.profile})
      : _firestoreTimestamp = FieldValue.serverTimestamp();

  @override
  String toString() => 'UpdateProfileEvent';
  FieldValue _firestoreTimestamp;
  final IProfileProvider _profileProvider = ProfileProvider();

  final Profile profile;

  @override
  Future<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc}) async {
    try {
      profile.created = _firestoreTimestamp;
      profile.lastUpdate = _firestoreTimestamp;
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
