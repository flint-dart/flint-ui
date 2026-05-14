import '../storage/browser_storage.dart';
import '../storage/local_storage.dart';

/// Represents the AuthSessionSnapshot API in Flint UI.
class AuthSessionSnapshot {
  /// Creates a AuthSessionSnapshot instance.
  const AuthSessionSnapshot({required this.token, required this.user});

  /// The token value.
  final String token;

  /// The user value.
  final Map<String, dynamic> user;

  /// Returns the role value.
  String? get role => user['role']?.toString();
}

/// Represents the AuthSessionManager API in Flint UI.
class AuthSessionManager {
  /// Creates a AuthSessionManager instance.
  const AuthSessionManager({
    this.tokenKey = 'auth.token',
    this.userKey = 'auth.user',
    this.storage = localStorage,
  });

  /// The tokenKey value.
  final String tokenKey;

  /// The userKey value.
  final String userKey;

  /// The storage value.
  final BrowserStorage storage;

  /// Returns the token value.
  String? get token {
    final value = storage.read(tokenKey);
    if (value == null || value.isEmpty) return null;
    return value;
  }

  /// Returns the user value.
  Map<String, dynamic> get user => storage.readMap(userKey);

  /// Returns the role value.
  String? get role => user['role']?.toString();

  /// Returns the isLoggedIn value.
  bool get isLoggedIn => token != null;

  /// Returns the current value.
  AuthSessionSnapshot? get current {
    final currentToken = token;
    if (currentToken == null) return null;
    return AuthSessionSnapshot(token: currentToken, user: user);
  }

  /// Runs the save operation.
  void save({required String token, Map<String, dynamic> user = const {}}) {
    storage.write(tokenKey, token);
    storage.writeJson(userKey, user);
  }

  /// Runs the updateUser operation.
  void updateUser(Map<String, dynamic> user) {
    storage.writeJson(userKey, user);
  }

  /// Runs the clear operation.
  void clear() {
    storage.remove(tokenKey);
    storage.remove(userKey);
  }
}

const authSession = AuthSessionManager();
