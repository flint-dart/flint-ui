# Flint UI Advance Plan

This is a short roadmap for browser helpers and app-level utilities that should make Flint UI feel more natural for Dart developers building fullstack web apps.

## Storage

- Done: Refactor `LocalStorage` and `SessionStorage` to share one internal storage base.
- Keep the public API simple:
  - `read(key)`
  - `write(key, value)`
  - `has(key)`
  - `readJson(key)`
  - `readMap(key)`
  - `writeJson(key, value)`
  - `remove(key)`
  - `clear()`
- Done: Add browser tests for both storage managers.

## Cookies

Done: Add a cookie manager for auth, preferences, and backend integration.

```dart
cookies.write('token', token);
final token = cookies.read('token');
cookies.remove('token');
```

Useful options:

- `expires`
- `maxAge`
- `path`
- `domain`
- `secure`
- `sameSite`

## Auth Session

Done: Add a higher-level session helper built on top of storage.

```dart
authSession.save(token: token, user: user);

final token = authSession.token;
final user = authSession.user;

if (authSession.isLoggedIn) {
  navigate('/dashboard');
}

authSession.clear();
```

This would keep app code away from raw storage keys and make login/logout flows easier to read.

## Navigation

Done: Add small browser navigation helpers.

```dart
navigate('/dashboard');
replace('/login');

final path = currentPath;
```

Possible additions:

- `back()`
- `forward()`
- `reload()`
- `currentUrl`
- `currentPath`

## Query Params

Done: Add helpers for reading and updating URL query parameters.

```dart
final page = query.get('page');

query.set('tab', 'users');
query.remove('search');
```

This is useful for dashboards, filters, pagination, and tabs.

## Environment Config

Done: Add a small config helper for app values such as API base URLs.

```dart
final apiUrl = env.get('API_URL', fallback: '/api');
```

Possible sources:

- Compile-time environment values
- Browser globals
- Meta tags
- Runtime config object

## Suggested Order

1. Refactor storage into a shared base.
2. Add storage tests.
3. Add `AuthSession`.
4. Add navigation helpers.
5. Add query param helpers.
6. Add cookies.
7. Add environment config.
