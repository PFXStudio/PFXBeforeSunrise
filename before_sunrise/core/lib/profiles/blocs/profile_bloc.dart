import 'package:core/import.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  static final ProfileBloc _profileBlocSingleton = new ProfileBloc._internal();
  factory ProfileBloc() {
    return _profileBlocSingleton;
  }
  ProfileBloc._internal();

  ProfileState get initialState => new UnProfileState();
  Profile signedProfile;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    try {
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield currentState;
    }
  }
}
