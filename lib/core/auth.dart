import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isAuthenticated;
  final String? name;
  final String? email;
  const AuthState({required this.isAuthenticated, this.name, this.email});

  AuthState copyWith({bool? isAuthenticated, String? name, String? email}) =>
      AuthState(isAuthenticated: isAuthenticated ?? this.isAuthenticated, name: name ?? this.name, email: email ?? this.email);
}

class AuthNotifier extends Notifier<AuthState> {
  static const _kTokenKey = 'auth_token';
  static const _kNameKey = 'user_name';
  static const _kEmailKey = 'user_email';
  final _storage = const FlutterSecureStorage();

  @override
  AuthState build() {
    // default to signed-out guest
    final initial = const AuthState(isAuthenticated: false);
    // async load saved session
    Future.microtask(() async {
      try {
        final token = await _storage.read(key: _kTokenKey);
        final prefs = await SharedPreferences.getInstance();
        final name = prefs.getString(_kNameKey);
        final email = prefs.getString(_kEmailKey);
        if (token != null && token.isNotEmpty) {
          state = AuthState(isAuthenticated: true, name: name ?? 'User', email: email ?? 'user@example.com');
        }
      } catch (e) {
        debugPrint('Auth load failed: $e');
      }
    });
    return initial;
  }

  Future<void> login({required String name, required String email, String token = 'local_token'}) async {
    try {
      await _storage.write(key: _kTokenKey, value: token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kNameKey, name);
      await prefs.setString(_kEmailKey, email);
      state = AuthState(isAuthenticated: true, name: name, email: email);
    } catch (e) {
      debugPrint('Auth login failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: _kTokenKey);
    } catch (e) {
      debugPrint('Auth token clear failed: $e');
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kNameKey);
      await prefs.remove(_kEmailKey);
    } catch (e) {
      debugPrint('Auth prefs clear failed: $e');
    }
    state = const AuthState(isAuthenticated: false);
  }
}

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());
