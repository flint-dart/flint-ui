import '../storage/browser_storage.dart';
import '../storage/local_storage.dart';

class AuthSessionSnapshot {
  const AuthSessionSnapshot({
    required this.token,
    required this.user,
  });

  final String token;
  final Map<String, dynamic> user;

  String? get role => user['role']?.toString();
}

class AuthSessionManager {
  const AuthSessionManager({
    this.tokenKey = 'auth.token',
    this.userKey = 'auth.user',
    this.storage = localStorage,
  });

  final String tokenKey;
  final String userKey;
  final BrowserStorage storage;

  String? get token {
    final value = storage.read(tokenKey);
    if (value == null || value.isEmpty) return null;
    return value;
  }

  Map<String, dynamic> get user => storage.readMap(userKey);

  String? get role => user['role']?.toString();

  bool get isLoggedIn => token != null;

  AuthSessionSnapshot? get current {
    final currentToken = token;
    if (currentToken == null) return null;
    return AuthSessionSnapshot(token: currentToken, user: user);
  }

  void save({
    required String token,
    Map<String, dynamic> user = const {},
  }) {
    storage.write(tokenKey, token);
    storage.writeJson(userKey, user);
  }

  void updateUser(Map<String, dynamic> user) {
    storage.writeJson(userKey, user);
  }

  void clear() {
    storage.remove(tokenKey);
    storage.remove(userKey);
  }
}

const authSession = AuthSessionManager();
