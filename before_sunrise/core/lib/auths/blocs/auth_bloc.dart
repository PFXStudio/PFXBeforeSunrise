import 'package:core/import.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static final AuthBloc _authBlocSingleton = new AuthBloc._internal();
  factory AuthBloc() {
    return _authBlocSingleton;
  }
  AuthBloc._internal();

  // getters
  AuthState get initialState => new UnAuthState();

  final IAuthProvider _authProvider = AuthProvider();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield UnAuthState();
    try {
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield currentState;
    }
  }

  Future<bool> isSingedIn() async {
    return _authProvider.isSingedIn();
  }

  Future<String> getUserID() async {
    if (await isSingedIn() == false) {
      return null;
    }

    return await _authProvider.getUserID();
  }

  Future<String> getPhoneNumber() async {
    if (await isSingedIn() == false) {
      return null;
    }

    return await _authProvider.getPhoneNumber();
  }
}
